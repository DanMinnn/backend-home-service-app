package com.danmin.home_service.service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

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

    public ChatMessage saveMessage(ChatMessage message) {
        ChatMessage savedMessage = chatMessageRepository.save(message);
        chatRoomService.updateLastMessageTime(message.getChatRoom().getId());
        return savedMessage;
    }

    public List<ChatMessageDTO> getChatMessages(Integer roomId) {
        List<ChatMessage> messages = chatMessageRepository.findChatRoomByIdOrderBySentAtAsc(roomId);
        return messages.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    public List<ChatMessageDTO> getRecentMessages(Integer roomId, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "sentAt"));
        List<ChatMessage> messages = chatMessageRepository.findChatRoomByIdOrderBySentAtDesc(roomId, pageable);
        Collections.reverse(messages); // Reverse to get ascending order

        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public ChatMessageDTO convertToDTO(ChatMessage message) {
        String senderName = null;
        String senderImage = null;

        if (message.getSenderType() == SenderType.user) {
            User user = userRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = user != null ? user.getFirstLastName() : "Unknown User";
            senderImage = user != null ? user.getProfileImage() : null;
        } else {
            Tasker tasker = taskerRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = tasker != null ? tasker.getFirstLastName() : "Unknown Tasker";
            senderImage = tasker != null ? tasker.getProfileImage() : null;
        }

        return ChatMessageDTO.builder()
                .id(message.getId())
                .roomId(message.getChatRoom().getId())
                .senderType(message.getSenderType())
                .senderId(message.getSenderId())
                .messageText(message.getMessageText())
                .sentAt(message.getSentAt())
                .senderName(senderName)
                .senderImage(senderImage)
                .build();
    }

    public void sendChatNotification(ChatMessage message) {
        String senderName = null;
        ChatRoom room = null;

        if (message.getSenderType() == SenderType.user) {
            User user = userRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = user != null ? user.getFirstLastName() : "Unknown User";

            // Send notification to tasker
            room = chatRoomService.getChatRoomById(message.getChatRoom().getId());
            if (room != null) {
                String destination = "/queue/tasker." + room.getTasker().getId();
                sendNotification(message, senderName, destination);
            }
        } else {
            Tasker tasker = taskerRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = tasker != null ? tasker.getFirstLastName() : "Unknown Tasker";

            // Send notification to user
            room = chatRoomService.getChatRoomById(message.getChatRoom().getId());
            if (room != null) {
                String destination = "/queue/user." + room.getUser().getId();
                sendNotification(message, senderName, destination);
            }
        }
    }

    private void sendNotification(ChatMessage message, String senderName, String destination) {
        ChatNotificationDTO notification = ChatNotificationDTO.builder()
                .roomId(message.getChatRoom().getId())
                .messageId(message.getId())
                .senderId(message.getSenderId())
                .senderType(message.getSenderType())
                .senderName(senderName)
                .messageText(message.getMessageText())
                .build();

        simpMessagingTemplate.convertAndSend(destination, notification);
    }
}
