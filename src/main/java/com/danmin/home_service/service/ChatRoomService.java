package com.danmin.home_service.service;

import com.danmin.home_service.repository.BookingRepository;
import com.danmin.home_service.repository.ChatMessageRepository;
import com.danmin.home_service.repository.ChatRoomRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.dto.request.ChatMessageDTO;
import com.danmin.home_service.dto.request.ChatRoomDTO;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.Bookings;
import com.danmin.home_service.model.ChatMessage;
import com.danmin.home_service.model.ChatRoom;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.User;

@Service
@RequiredArgsConstructor
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository messageRepository;
    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;
    private final BookingRepository bookingRepository;

    public ChatRoomDTO createChatRoom(ChatRoomDTO req) {

        Bookings bookings;

        if (req.getBookingId() != null) {
            bookings = bookingRepository.findById(req.getBookingId())
                    .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        } else {
            bookings = null;
        }

        User user = userRepository.findById(req.getUserId().longValue())
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Tasker tasker = taskerRepository.findById(req.getTaskerId().longValue())
                .orElseThrow(() -> new ResourceNotFoundException("Tasker not found"));

        ChatRoom chatRoom = chatRoomRepository.findByUserIdAndTaskerId(user.getId(), tasker.getId())
                .orElseGet(() -> {
                    return chatRoomRepository.save(ChatRoom.builder().booking(bookings).user(user)
                            .tasker(tasker).build());
                });

        return ChatRoomDTO.builder().bookingId(chatRoom.getBooking().getId()).userId(chatRoom.getUser().getId())
                .taskerId(chatRoom.getTasker().getId()).build();
    }

    @Transactional
    public List<ChatRoomDTO> getChatRoomForUser(Integer userId) {
        List<ChatRoom> rooms = chatRoomRepository.findRoomByUserId(userId);
        return mapToChatRoomDTOs(rooms, SenderType.tasker);
    }

    @Transactional
    public List<ChatRoomDTO> getChatRoomForTasker(Integer taskerId) {
        List<ChatRoom> rooms = chatRoomRepository.findRoomByTaskerId(taskerId);
        return mapToChatRoomDTOs(rooms, SenderType.user);
    }

    public ChatRoom getChatRoomById(Integer roomId) {
        return chatRoomRepository.findById(roomId).orElse(null);
    }

    private List<ChatRoomDTO> mapToChatRoomDTOs(List<ChatRoom> rooms, SenderType senderType) {
        return rooms.stream().map(room -> {
            User user = userRepository.findById(room.getUser().getId().longValue()).orElse(null);
            Tasker tasker = taskerRepository.findById(room.getTasker().getId().longValue()).orElse(null);

            ChatMessageDTO lastMessage = messageRepository.findTopChatRoomByIdOrderBySentAtDesc(room.getId())
                    .map(this::mapToChatMessageDTO).orElse(null);

            return ChatRoomDTO.builder().id(room.getId()).bookingId(room.getBooking().getId())
                    .userId(room.getUser().getId())
                    .taskerId(room.getTasker().getId())
                    .userName(user != null ? user.getFirstLastName() : "Unknow User")
                    .taskerName(tasker != null ? tasker.getFirstLastName() : "Unknow Tasker")
                    .userProfile(user != null ? user.getProfileImage() : null)
                    .taskerProfile(tasker != null ? tasker.getProfileImage() : null)
                    .lastMessageAt(room.getLastMessageAt())
                    .lastMessage(lastMessage)
                    .build();
        })
                .sorted(Comparator.comparing(ChatRoomDTO::getLastMessageAt).reversed())
                .collect(Collectors.toList());
    }

    private ChatMessageDTO mapToChatMessageDTO(ChatMessage message) {
        String senderName = null;
        String senderImage = null;

        if (message.getSenderType() == SenderType.user) {
            User user = userRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = user != null ? user.getFirstLastName() : "Unknow User";
            senderImage = user != null ? user.getProfileImage() : null;
        } else {
            Tasker tasker = taskerRepository.findById(message.getSenderId().longValue()).orElse(null);
            senderName = tasker != null ? tasker.getFirstLastName() : "Unknow Tasker";
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

    public void updateLastMessageTime(Integer roomId) {
        chatRoomRepository.findById(roomId).ifPresent(room -> {
            room.setLastMessageAt(LocalDateTime.now());
            chatRoomRepository.save(room);
        });
    }

    @Transactional
    public void updateLastMessageTimeOptimized(Integer roomId) {
        chatRoomRepository.updateLastMessageAt(roomId, LocalDateTime.now());
    }
}
