package com.danmin.home_service.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.notification.FCMNotificationResponse;
import com.danmin.home_service.dto.request.ChatMessageDTO;
import com.danmin.home_service.model.ChatMessage;
import com.danmin.home_service.model.ChatRoom;
import com.danmin.home_service.service.ChatMessageService;
import com.danmin.home_service.service.ChatRoomService;
import com.danmin.home_service.service.FirebaseNotificationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j(topic = "CHAT-WEBSOCKET")
public class ChatWebSocketController {
    private final ChatMessageService chatMessageService;
    private final ChatRoomService chatRoomService;
    private final SimpMessagingTemplate messagingTemplate;
    private final FirebaseNotificationService firebaseNotificationService;

    // Track online users
    private final Map<String, Long> sessionUserMap = new ConcurrentHashMap<>();
    private final Map<Long, String> userSessionMap = new ConcurrentHashMap<>();

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        try {
            StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
            String sessionId = headerAccessor.getSessionId();

            log.info("WebSocket connection event for session: {}", sessionId);

            // Get session attributes from the CONNECT message
            StompHeaderAccessor connectAccessor = StompHeaderAccessor.wrap(
                    (org.springframework.messaging.Message<?>) headerAccessor.getMessageHeaders()
                            .get("simpConnectMessage"));

            Map<String, Object> sessionAttributes = null;
            if (connectAccessor != null) {
                sessionAttributes = connectAccessor.getSessionAttributes();
                log.debug("Extracted session attributes from connect message: {}",
                        sessionAttributes != null ? sessionAttributes.keySet() : "null");
            }

            // Fallback to direct session attributes
            if (sessionAttributes == null) {
                sessionAttributes = headerAccessor.getSessionAttributes();
                log.debug("Using direct session attributes: {}",
                        sessionAttributes != null ? sessionAttributes.keySet() : "null");
            }

            if (sessionAttributes == null) {
                log.error(
                        "Unable to authenticate WebSocket connection for session: {} - session attributes remain null",
                        sessionId);
                logSessionDetails(headerAccessor);
                return;
            }

            Long userId = extractUserIdSafely(sessionAttributes, sessionId);
            if (userId == null) {
                log.warn("UserId not found in session attributes for session: {}", sessionId);
                log.debug("Available session attributes: {}", sessionAttributes.keySet());
                return;
            }

            // Store user session mapping
            sessionUserMap.put(sessionId, userId);
            userSessionMap.put(userId, sessionId);

            // Notify others about user online status
            notifyUserOnlineStatus(userId, true);
            log.info("User {} successfully connected with session {}", userId, sessionId);

        } catch (Exception e) {
            log.error("Error handling WebSocket connect event: {}", e.getMessage(), e);
        }
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        try {
            StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
            String sessionId = headerAccessor.getSessionId();

            Long userId = sessionUserMap.remove(sessionId);
            if (userId != null) {
                userSessionMap.remove(userId);

                // Notify others about user offline status
                notifyUserOnlineStatus(userId, false);
                log.info("User {} disconnected from session {}", userId, sessionId);
            } else {
                log.debug("No user mapping found for disconnected session: {}", sessionId);
            }
        } catch (Exception e) {
            log.error("Error handling WebSocket disconnect event: {}", e.getMessage(), e);
        }
    }

    @MessageMapping("/chat.sendMessage")
    @Transactional
    public void sendMessage(@Payload ChatMessageDTO chatMessageDTO, SimpMessageHeaderAccessor headerAccessor) {
        try {
            // Extract user from session attributes with comprehensive null checks
            Map<String, Object> sessionAttributes = getSessionAttributesSafely(headerAccessor);
            if (sessionAttributes == null) {
                log.error("Session attributes are null when sending message for session: {}",
                        headerAccessor.getSessionId());
                return;
            }

            Long userId = extractUserIdSafely(sessionAttributes, headerAccessor.getSessionId());
            if (userId == null) {
                log.error("UserId not found in session when sending message for session: {}",
                        headerAccessor.getSessionId());
                return;
            }

            List<String> roles = extractRolesSafely(sessionAttributes);

            // Validate input
            if (chatMessageDTO.getMessageText() == null || chatMessageDTO.getMessageText().trim().isEmpty()) {
                sendErrorToUser(userId, "Message text cannot be empty");
                return;
            }

            // Ensure senderId matches authenticated user
            chatMessageDTO.setSenderId(userId.intValue());

            // Check permission to access chat room
            if (!hasAccessToChatRoom(userId, roles, chatMessageDTO)) {
                log.warn("Unauthorized access to chat room: {} by user: {}", chatMessageDTO.getRoomId(), userId);
                sendErrorToUser(userId, "Unauthorized access to chat room");
                return;
            }

            ChatRoom chatRoom = chatRoomService.getChatRoomById(chatMessageDTO.getRoomId());
            if (chatRoom == null) {
                log.error("Chat room not found: {}", chatMessageDTO.getRoomId());
                sendErrorToUser(userId, "Chat room not found");
                return;
            }

            // Eagerly load the associations to avoid LazyInitializationException
            Long chatRoomUserId = chatRoom.getUser().getId().longValue();
            Long chatRoomTaskerId = chatRoom.getTasker().getId().longValue();

            ChatMessage message = ChatMessage.builder()
                    .chatRoom(chatRoom)
                    .senderId(chatMessageDTO.getSenderId())
                    .senderType(chatMessageDTO.getSenderType())
                    .messageText(chatMessageDTO.getMessageText().trim())
                    .sentAt(LocalDateTime.now())
                    .build();

            ChatMessage savedMessage = chatMessageService.saveMessage(message);
            ChatMessageDTO messageDTO = chatMessageService.convertToDTO(savedMessage);

            // Determine recipient using the eagerly loaded IDs
            Long recipientId = chatMessageDTO.getSenderType() == SenderType.user
                    ? chatRoomTaskerId
                    : chatRoomUserId;

            // Send to both parties via their dedicated queues
            String userDestination = "/queue/user." + chatRoomUserId;
            String taskerDestination = "/queue/tasker." + chatRoomTaskerId;

            messagingTemplate.convertAndSend(userDestination, messageDTO);
            messagingTemplate.convertAndSend(taskerDestination, messageDTO);

            // Send FCM push notification if recipient is offline
            if (!isUserOnline(recipientId)) {
                sendChatPushNotification(savedMessage, chatRoom, chatRoomUserId, chatRoomTaskerId);
            }

            // Send typing indicator stop
            sendTypingIndicator(chatRoom, userId, false, chatRoomUserId, chatRoomTaskerId);

        } catch (Exception e) {
            log.error("Error processing message: {}", e.getMessage(), e);

            // Try to get userId for error response
            try {
                Map<String, Object> sessionAttributes = getSessionAttributesSafely(headerAccessor);
                if (sessionAttributes != null) {
                    Long userId = extractUserIdSafely(sessionAttributes, headerAccessor.getSessionId());
                    if (userId != null) {
                        sendErrorToUser(userId, "Failed to send message: " + e.getMessage());
                    }
                }
            } catch (Exception ex) {
                log.error("Error sending error message to user: {}", ex.getMessage());
            }
        }
    }

    @MessageMapping("/chat.markRead")
    @Transactional
    public void markAsRead(@Payload Map<String, Object> payload, SimpMessageHeaderAccessor headerAccessor) {
        try {
            Map<String, Object> sessionAttributes = getSessionAttributesSafely(headerAccessor);
            if (sessionAttributes == null) {
                log.error("Session attributes are null when marking messages as read for session: {}",
                        headerAccessor.getSessionId());
                return;
            }

            Integer roomId = (Integer) payload.get("roomId");
            Long userId = extractUserIdSafely(sessionAttributes, headerAccessor.getSessionId());

            if (userId == null) {
                log.error("UserId not found when marking messages as read for session: {}",
                        headerAccessor.getSessionId());
                return;
            }

            List<String> roles = extractRolesSafely(sessionAttributes);

            ChatRoom chatRoom = chatRoomService.getChatRoomById(roomId);
            if (chatRoom == null) {
                log.error("Chat room not found: {}", roomId);
                return;
            }

            SenderType userType = determineUserType(userId, roles, chatRoom);
            if (userType != null) {
                chatMessageService.markMessagesAsRead(roomId, userId.intValue(), userType);

                // Notify the other party that messages were read
                String destination = userType == SenderType.user
                        ? "/queue/tasker." + chatRoom.getTasker().getId()
                        : "/queue/user." + chatRoom.getUser().getId();

                messagingTemplate.convertAndSend(destination,
                        Map.of("type", "messagesRead", "roomId", roomId, "readerId", userId));
            }
        } catch (Exception e) {
            log.error("Error marking messages as read: {}", e.getMessage(), e);
        }
    }

    @MessageMapping("/chat.typing")
    @Transactional
    public void handleTyping(@Payload Map<String, Object> payload, SimpMessageHeaderAccessor headerAccessor) {
        try {
            Map<String, Object> sessionAttributes = getSessionAttributesSafely(headerAccessor);
            if (sessionAttributes == null) {
                return;
            }

            Integer roomId = (Integer) payload.get("roomId");
            Boolean isTyping = (Boolean) payload.get("isTyping");

            Long userId = extractUserIdSafely(sessionAttributes, headerAccessor.getSessionId());
            if (userId == null) {
                return;
            }

            ChatRoom chatRoom = chatRoomService.getChatRoomById(roomId);
            if (chatRoom != null) {
                sendTypingIndicator(chatRoom, userId, isTyping);
            }
        } catch (Exception e) {
            log.error("Error handling typing indicator: {}", e.getMessage(), e);
        }
    }

    // Helper methods
    private boolean hasAccessToChatRoom(Long userId, List<String> roles, ChatMessageDTO chatMessage) {
        if (userId == null)
            return false;

        ChatRoom room = chatRoomService.getChatRoomById(chatMessage.getRoomId());
        if (room == null)
            return false;

        boolean isUser = userId.intValue() == room.getUser().getId() && chatMessage.getSenderType() == SenderType.user;
        boolean isTasker = userId.intValue() == room.getTasker().getId()
                && chatMessage.getSenderType() == SenderType.tasker;

        return isUser || isTasker;
    }

    private SenderType determineUserType(Long userId, List<String> roles, ChatRoom chatRoom) {
        boolean isUser = roles.contains("ROLE_USER");
        boolean isTasker = roles.contains("ROLE_TASKER");

        if (isUser && userId.intValue() == chatRoom.getUser().getId()) {
            return SenderType.user;
        } else if (isTasker && userId.intValue() == chatRoom.getTasker().getId()) {
            return SenderType.tasker;
        }
        return null;
    }

    private boolean isUserOnline(Long userId) {
        return userSessionMap.containsKey(userId);
    }

    private void sendErrorToUser(Long userId, String errorMessage) {
        if (userId != null) {
            messagingTemplate.convertAndSendToUser(userId.toString(), "/queue/errors",
                    Map.of("error", errorMessage, "timestamp", System.currentTimeMillis()));
        }
    }

    private void notifyUserOnlineStatus(Long userId, boolean isOnline) {
        Map<String, Object> statusUpdate = Map.of(
                "type", "userStatus",
                "userId", userId,
                "isOnline", isOnline,
                "timestamp", System.currentTimeMillis());

        // Broadcast to all connected users (you might want to limit this to relevant
        // chat rooms)
        messagingTemplate.convertAndSend("/topic/user-status", statusUpdate);
    }

    private void sendTypingIndicator(ChatRoom chatRoom, Long senderId, boolean isTyping) {
        // Eagerly load the IDs to avoid LazyInitializationException
        Long chatRoomUserId = chatRoom.getUser().getId().longValue();
        Long chatRoomTaskerId = chatRoom.getTasker().getId().longValue();
        sendTypingIndicator(chatRoom, senderId, isTyping, chatRoomUserId, chatRoomTaskerId);
    }

    private void sendTypingIndicator(ChatRoom chatRoom, Long senderId, boolean isTyping, Long chatRoomUserId,
            Long chatRoomTaskerId) {
        Map<String, Object> typingIndicator = Map.of(
                "type", "typing",
                "roomId", chatRoom.getId(),
                "userId", senderId,
                "isTyping", isTyping);

        String userDestination = "/queue/user." + chatRoomUserId;
        String taskerDestination = "/queue/tasker." + chatRoomTaskerId;

        messagingTemplate.convertAndSend(userDestination, typingIndicator);
        messagingTemplate.convertAndSend(taskerDestination, typingIndicator);
    }

    private void sendChatPushNotification(ChatMessage message, ChatRoom chatRoom, Long chatRoomUserId,
            Long chatRoomTaskerId) {
        try {
            String senderName = chatMessageService.getSenderName(message);
            String notificationTitle = "New message from " + senderName;
            String notificationBody = message.getMessageText();

            Map<String, String> data = new HashMap<>();
            data.put("type", "chat");
            data.put("roomId", chatRoom.getId().toString());
            data.put("senderId", message.getSenderId().toString());
            data.put("senderType", message.getSenderType().toString());

            FCMNotificationResponse fcmNotification = FCMNotificationResponse.builder()
                    .title(notificationTitle)
                    .body(notificationBody)
                    .data(data)
                    .build();

            // Send to appropriate recipient using the pre-loaded IDs
            if (message.getSenderType() == SenderType.user) {
                // Send to tasker
                firebaseNotificationService.sendNotificationToTasker(
                        chatRoomTaskerId.intValue(), fcmNotification);
            } else {
                // Send to user
                firebaseNotificationService.sendNotificationToUser(
                        chatRoomUserId.intValue(), fcmNotification);
            }

        } catch (Exception e) {
            log.error("Error sending chat push notification: {}", e.getMessage(), e);
        }
    }

    private Map<String, Object> getSessionAttributesSafely(SimpMessageHeaderAccessor headerAccessor) {
        try {
            // First try to get session attributes directly
            Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();
            if (sessionAttributes != null && sessionAttributes.get("userId") != null) {
                log.debug("Session attributes found directly with keys: {}", sessionAttributes.keySet());
                return sessionAttributes;
            }

            String sessionId = headerAccessor.getSessionId();
            log.debug("Session attributes null or missing userId for session: {}, attempting alternative methods",
                    sessionId);

            // Try to get from stored session mapping as fallback
            Long userId = sessionUserMap.get(sessionId);
            if (userId != null) {
                log.debug("Found userId {} from session mapping for session: {}", userId, sessionId);
                // Create a minimal session attributes map for the fallback
                Map<String, Object> fallbackAttributes = Map.of(
                        "userId", userId,
                        "authenticated", true);
                return fallbackAttributes;
            }

            // Log message headers for debugging
            log.debug("Available message headers for session {}: {}", sessionId,
                    headerAccessor.getMessageHeaders().keySet());

            return null;
        } catch (Exception e) {
            log.error("Error getting session attributes safely: {}", e.getMessage());
            return null;
        }
    }

    private void logSessionDetails(SimpMessageHeaderAccessor headerAccessor) {
        try {
            String sessionId = headerAccessor.getSessionId();
            log.debug("Session details for {}: ", sessionId);
            log.debug("  Session ID: {}", sessionId);
            log.debug("  Message headers: {}", headerAccessor.getMessageHeaders().keySet());
            log.debug("  Session attributes: {}", headerAccessor.getSessionAttributes());

            // Log all message headers
            headerAccessor.getMessageHeaders().forEach((key, value) -> log.debug("  Header {}: {}", key,
                    value != null ? value.getClass().getSimpleName() : "null"));
        } catch (Exception e) {
            log.error("Error logging session details: {}", e.getMessage());
        }
    }

    private Long extractUserIdSafely(Map<String, Object> sessionAttributes, String sessionId) {
        try {
            Object userIdObj = sessionAttributes.get("userId");
            if (userIdObj == null) {
                log.warn("UserId is null in session attributes for session: {}", sessionId);
                return null;
            }

            if (userIdObj instanceof Integer) {
                return ((Integer) userIdObj).longValue();
            } else if (userIdObj instanceof Long) {
                return (Long) userIdObj;
            } else if (userIdObj instanceof String) {
                try {
                    return Long.parseLong((String) userIdObj);
                } catch (NumberFormatException e) {
                    log.error("Invalid userId format in session: {} for session: {}", userIdObj, sessionId);
                    return null;
                }
            } else {
                log.warn("Invalid userId type in session: {} for session: {}",
                        userIdObj.getClass(), sessionId);
                return null;
            }
        } catch (Exception e) {
            log.error("Error extracting userId from session: {}", e.getMessage());
            return null;
        }
    }

    private List<String> extractRolesSafely(Map<String, Object> sessionAttributes) {
        try {
            Object rolesObj = sessionAttributes.get("roles");
            if (rolesObj instanceof List) {
                return (List<String>) rolesObj;
            }
        } catch (Exception e) {
            log.warn("Error extracting roles from session: {}", e.getMessage());
        }
        return List.of();
    }

}
