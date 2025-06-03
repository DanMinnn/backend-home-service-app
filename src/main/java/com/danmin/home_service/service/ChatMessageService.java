package com.danmin.home_service.service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.request.ChatMessageDTO;
import com.danmin.home_service.dto.request.ChatNotificationDTO;
import com.danmin.home_service.model.ChatMessage;
import com.danmin.home_service.model.ChatRoom;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.ChatMessageRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatMessageService {
    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomService chatRoomService;
    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;
    private final SimpMessagingTemplate simpMessagingTemplate;

    // Enhanced caching with expiration
    private final Map<Long, User> userCache = new ConcurrentHashMap<>();
    private final Map<Long, Tasker> taskerCache = new ConcurrentHashMap<>();

    public ChatMessage saveMessage(ChatMessage message) {
        // Set current timestamp if not set
        if (message.getSentAt() == null) {
            message.setSentAt(LocalDateTime.now());
        }

        ChatMessage savedMessage = chatMessageRepository.save(message);
        chatRoomService.updateLastMessageTimeOptimized(message.getChatRoom().getId());

        // Send real-time notification
        sendChatNotification(savedMessage);

        return savedMessage;
    }

    @Transactional(readOnly = true)
    public List<ChatMessageDTO> getChatMessages(Integer roomId, Integer page, Integer size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "sentAt"));
        List<ChatMessage> messages = chatMessageRepository.findChatRoomByIdOrderBySentAtDesc(roomId, pageable);
        Collections.reverse(messages);

        return messages.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ChatMessageDTO> getChatMessages(Integer roomId) {
        List<ChatMessage> messages = chatMessageRepository.findChatRoomByIdOrderBySentAtAsc(roomId);
        return messages.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ChatMessageDTO> getRecentMessages(Integer roomId, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "sentAt"));
        List<ChatMessage> messages = chatMessageRepository.findChatRoomByIdOrderBySentAtDesc(roomId, pageable);
        Collections.reverse(messages);

        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public ChatMessageDTO convertToDTO(ChatMessage message) {
        String senderName = getSenderName(message);
        String senderImage = getSenderImage(message);

        return ChatMessageDTO.builder()
                .id(message.getId())
                .roomId(message.getChatRoom().getId())
                .senderType(message.getSenderType())
                .senderId(message.getSenderId())
                .messageText(message.getMessageText())
                .sentAt(message.getSentAt())
                .senderName(senderName)
                .senderImage(senderImage)
                .read(message.getReadAt() != null)
                .build();
    }

    @Transactional
    public String getSenderName(ChatMessage message) {
        if (message.getSenderType() == SenderType.user) {
            User user = getUserById(message.getSenderId().longValue());
            return user != null ? user.getFirstLastName() : "Unknown User";
        } else if (message.getSenderType() == SenderType.tasker) {
            Tasker tasker = getTaskerById(message.getSenderId().longValue());
            return tasker != null ? tasker.getFirstLastName() : "Unknown Tasker";
        }
        return "System";
    }

    @Transactional
    private String getSenderImage(ChatMessage message) {
        if (message.getSenderType() == SenderType.user) {
            User user = getUserById(message.getSenderId().longValue());
            return user != null ? user.getProfileImage() : null;
        } else if (message.getSenderType() == SenderType.tasker) {
            Tasker tasker = getTaskerById(message.getSenderId().longValue());
            return tasker != null ? tasker.getProfileImage() : null;
        }
        return null;
    }

    // Cached user/tasker retrieval
    @Cacheable(value = "users", key = "#userId")
    private User getUserById(Long userId) {
        return userCache.computeIfAbsent(userId, id -> userRepository.findById(id).orElse(null));
    }

    @Cacheable(value = "taskers", key = "#taskerId")
    @Transactional
    private Tasker getTaskerById(Long taskerId) {
        return taskerCache.computeIfAbsent(taskerId, id -> taskerRepository.findById(id).orElse(null));
    }

    public void sendChatNotification(ChatMessage message) {
        try {
            String senderName = getSenderName(message);
            ChatRoom room = chatRoomService.getChatRoomById(message.getChatRoom().getId());

            if (room == null)
                return;

            // Create notification DTO
            ChatNotificationDTO notification = ChatNotificationDTO.builder()
                    .roomId(message.getChatRoom().getId())
                    .messageId(message.getId())
                    .senderId(message.getSenderId())
                    .senderType(message.getSenderType())
                    .senderName(senderName)
                    .messageText(message.getMessageText())
                    .timestamp(message.getSentAt())
                    .build();

            // Send to appropriate destination
            if (message.getSenderType() == SenderType.user) {
                String destination = "/queue/tasker." + room.getTasker().getId();
                simpMessagingTemplate.convertAndSend(destination, notification);
            } else {
                String destination = "/queue/user." + room.getUser().getId();
                simpMessagingTemplate.convertAndSend(destination, notification);
            }
        } catch (Exception e) {
            // Log error but don't fail the message save
            // log.error("Failed to send chat notification", e);
        }
    }

    @Transactional
    public void markMessagesAsRead(Integer roomId, Integer userId, SenderType userType) {
        List<ChatMessage> unreadMessages = chatMessageRepository.findUnreadMessagesForUser(
                roomId, userId, userType == SenderType.user ? SenderType.tasker : SenderType.user);

        if (!unreadMessages.isEmpty()) {
            java.sql.Date now = new java.sql.Date(System.currentTimeMillis());
            unreadMessages.forEach(message -> {
                message.setReadAt(now);
                chatMessageRepository.save(message);
            });

            // Notify sender that messages were read
            ChatRoom room = chatRoomService.getChatRoomById(roomId);
            if (room != null) {
                Map<String, Object> readReceipt = Map.of(
                        "type", "messageRead",
                        "roomId", roomId,
                        "readerId", userId,
                        "messageIds", unreadMessages.stream().map(ChatMessage::getId).collect(Collectors.toList()));

                String destination = userType == SenderType.user
                        ? "/queue/tasker." + room.getTasker().getId()
                        : "/queue/user." + room.getUser().getId();

                simpMessagingTemplate.convertAndSend(destination, readReceipt);
            }
        }
    }

    @Transactional(readOnly = true)
    public int getUnreadMessageCount(Integer roomId, Integer userId, SenderType userType) {
        return chatMessageRepository.countUnreadMessagesForUser(
                roomId, userId, userType == SenderType.user ? SenderType.tasker : SenderType.user);
    }

    // Clear cache methods
    public void clearUserCache(Long userId) {
        userCache.remove(userId);
    }

    public void clearTaskerCache(Long taskerId) {
        taskerCache.remove(taskerId);
    }

    public void clearAllCaches() {
        userCache.clear();
        taskerCache.clear();
    }
}
