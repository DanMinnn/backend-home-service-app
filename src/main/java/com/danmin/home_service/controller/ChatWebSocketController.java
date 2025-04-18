package com.danmin.home_service.controller;

import java.util.Date;
import java.util.List;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.request.ChatMessageDTO;
import com.danmin.home_service.model.ChatMessage;
import com.danmin.home_service.model.ChatRoom;
import com.danmin.home_service.service.ChatMessageService;
import com.danmin.home_service.service.ChatRoomService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j(topic = "CHAT-WEBSOCKET")
public class ChatWebSocketController {
    private final ChatMessageService chatMessageService;
    private final ChatRoomService chatRoomService;
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessageDTO chatMessageDTO, SimpMessageHeaderAccessor headerAccessor) {

        // Extract user from session attributes
        Long userId = (Long) headerAccessor.getSessionAttributes().get("userId");
        List<String> roles = (List<String>) headerAccessor.getSessionAttributes().get("roles");

        // Check permission to access chat room
        if (!hasAccessToChatRoom(userId, roles, chatMessageDTO)) {
            log.warn("Unauthorized access to chat room: {}", chatMessageDTO.getRoomId());
            return;
        }

        ChatRoom chatRoom = chatRoomService.getChatRoomById(chatMessageDTO.getRoomId());

        ChatMessage message = ChatMessage.builder().chatRoom(chatRoom)
                .senderId(chatMessageDTO.getSenderId())
                .senderType(chatMessageDTO.getSenderType())
                .messageText(chatMessageDTO.getMessageText())
                .sentAt(new Date().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime())
                .build();

        ChatMessage savedMessage = chatMessageService.saveMessage(message);

        // Convert to DTO for sending to client
        ChatRoom room = chatRoomService.getChatRoomById(chatMessageDTO.getRoomId());
        ;
        if (room == null) {
            log.error("Chat room not found: {}", chatMessageDTO.getRoomId());
            return;
        }
        String userDestination = "/queue/user."
                + (message.getSenderType() == SenderType.user ? message.getSenderId() : room.getUser().getId());

        String taskerDestination = "/queue/tasker."
                + (message.getSenderType() == SenderType.tasker ? message.getSenderId()
                        : room.getTasker().getId());

        // Send to both parties
        messagingTemplate.convertAndSend(userDestination, chatMessageService.convertToDTO(savedMessage));
        messagingTemplate.convertAndSend(taskerDestination, chatMessageService.convertToDTO(savedMessage));

        // Send notification
        chatMessageService.sendChatNotification(savedMessage);
    }

    // check chat room access
    private boolean hasAccessToChatRoom(Long userId, List<String> roles, ChatMessageDTO chatMessage) {
        if (userId == null)
            return false;

        ChatRoom room = chatRoomService.getChatRoomById(chatMessage.getRoomId());
        if (room == null)
            return false;

        // Check if the sender is a user or tasker of this chat room
        boolean isUser = userId.intValue() == room.getUser().getId() && chatMessage.getSenderType() == SenderType.user;
        boolean isTasker = userId.intValue() == room.getTasker().getId()
                && chatMessage.getSenderType() == SenderType.tasker;

        return isUser || isTasker;
    }
}
