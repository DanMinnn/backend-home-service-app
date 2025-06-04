package com.danmin.home_service.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.common.SenderType;
import com.danmin.home_service.config.CustomizeRequestFilter;
import com.danmin.home_service.dto.request.ChatMessageDTO;
import com.danmin.home_service.dto.request.ChatRoomDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.model.ChatRoom;
import com.danmin.home_service.service.ChatMessageService;
import com.danmin.home_service.service.ChatRoomService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@Slf4j(topic = "CHAT-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Chat Controller")
@RequestMapping("/chat")
public class ChatController {
        private final ChatRoomService chatRoomService;
        private final ChatMessageService chatMessageService;

        @Operation(summary = "Get chat room for user or tasker")
        @GetMapping("/user/")
        public ResponseData<List<ChatRoomDTO>> getUserChatRoom(Authentication authentication) {
                if (authentication == null) {
                        throw new IllegalStateException("Authentication is null. Are you sending token?");
                }

                Integer userId;
                if (authentication.getDetails() instanceof CustomizeRequestFilter.CustomWebAuthenticationDetails) {
                        CustomizeRequestFilter.CustomWebAuthenticationDetails details = (CustomizeRequestFilter.CustomWebAuthenticationDetails) authentication
                                        .getDetails();
                        userId = details.getUserId();
                } else {
                        // Fallback to extract from principal if details don't contain userId
                        userId = Integer.parseInt(
                                        ((Map<String, Object>) authentication.getDetails()).get("userId").toString());
                }

                boolean isUser = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));
                boolean isTasker = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_TASKER"));

                List<ChatRoomDTO> chatRooms;

                if (isUser) {
                        chatRooms = chatRoomService.getChatRoomForUser(userId);
                } else if (isTasker) {
                        chatRooms = chatRoomService.getChatRoomForTasker(userId);
                } else {
                        return new ResponseError(HttpStatus.FORBIDDEN.value(), "You don't have permission");
                }

                return new ResponseData<List<ChatRoomDTO>>(HttpStatus.ACCEPTED.value(), "chat room", chatRooms);
        }

        // @Operation(summary = "Get chat room")
        // @GetMapping("/room")
        // public ResponseData<ChatRoom> getChatRoom(@RequestParam Integer userId,
        // @RequestParam Integer taskerId,
        // @RequestParam(required = false) Long bookingId) {

        // return new ResponseData<ChatRoom>(HttpStatus.ACCEPTED.value(), "chat room",
        // chatRoomService.getChatRoom(userId, taskerId, bookingId != null ? bookingId :
        // 0));
        // }

        @Operation(summary = "Get message chat room")
        @GetMapping("/message/{roomId}")
        @Transactional
        public ResponseData<List<ChatMessageDTO>> getChatRoom(
                        @PathVariable(value = "roomId") Integer roomId,
                        @RequestParam(required = false, defaultValue = "0") Integer page,
                        @RequestParam(required = false, defaultValue = "50") Integer size,
                        Authentication authentication) {

                Integer userId;
                if (authentication.getDetails() instanceof CustomizeRequestFilter.CustomWebAuthenticationDetails) {
                        CustomizeRequestFilter.CustomWebAuthenticationDetails details = (CustomizeRequestFilter.CustomWebAuthenticationDetails) authentication
                                        .getDetails();
                        userId = details.getUserId();
                } else {
                        // Fallback to extract from principal if details don't contain userId
                        userId = Integer.parseInt(
                                        ((Map<String, Object>) authentication.getDetails()).get("userId").toString());
                }
                // check permission on user to access this chat room
                ChatRoom chatRoom = chatRoomService.getChatRoomById(roomId);
                if (chatRoom == null) {
                        return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Room not found");
                }

                boolean isUser = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));
                boolean isTasker = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_TASKER"));

                boolean hasAccess = (isUser && chatRoom.getUser().getId().equals(userId)) ||
                                (isTasker && chatRoom.getTasker().getId().equals(userId));

                if (!hasAccess) {
                        return new ResponseError(HttpStatus.FORBIDDEN.value(), "Can not allow this room");
                }

                // Mark messages as read when fetched
                if (isUser) {
                        chatMessageService.markMessagesAsRead(roomId, userId, SenderType.user);
                } else if (isTasker) {
                        chatMessageService.markMessagesAsRead(roomId, userId, SenderType.tasker);
                }

                List<ChatMessageDTO> messages;

                // If pagination parameters are provided, use them
                if (page != null && size != null) {
                        messages = chatMessageService.getChatMessages(roomId, page, size);
                } else {
                        messages = chatMessageService.getChatMessages(roomId);
                }

                return new ResponseData<List<ChatMessageDTO>>(HttpStatus.ACCEPTED.value(),
                                "message chat room",
                                messages);
        }

        @Operation(summary = "Get message recent")
        @GetMapping("/message/{roomId}/recent")
        public ResponseData<List<ChatMessageDTO>> getMessageRecent(@PathVariable(value = "roomId") Integer roomId,
                        @RequestParam(defaultValue = "20") Integer limit) {

                return new ResponseData<List<ChatMessageDTO>>(HttpStatus.ACCEPTED.value(), "message chat room",
                                chatMessageService.getRecentMessages(roomId, limit));
        }

        @PostMapping("/rooms/create")
        public ResponseData<ChatRoomDTO> createChatRoom(@RequestBody ChatRoomDTO request) {
                try {

                        return new ResponseData(HttpStatus.CREATED.value(), "Created chat room successfully",
                                        chatRoomService.createChatRoom(request));
                } catch (Exception e) {
                        return new ResponseError(HttpStatus.BAD_REQUEST.value(), e.getMessage());
                }
        }

        @Operation(summary = "Mark messages as read")
        @PostMapping("/message/{roomId}/read")
        @Transactional
        public ResponseData<String> markMessagesAsRead(
                        @PathVariable(value = "roomId") Integer roomId,
                        Authentication authentication) {

                Integer userId;
                if (authentication.getDetails() instanceof CustomizeRequestFilter.CustomWebAuthenticationDetails) {
                        CustomizeRequestFilter.CustomWebAuthenticationDetails details = (CustomizeRequestFilter.CustomWebAuthenticationDetails) authentication
                                        .getDetails();
                        userId = details.getUserId();
                } else {
                        // Fallback to extract from principal if details don't contain userId
                        userId = Integer.parseInt(
                                        ((Map<String, Object>) authentication.getDetails()).get("userId").toString());
                }
                ChatRoom chatRoom = chatRoomService.getChatRoomById(roomId);
                if (chatRoom == null) {
                        return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Room not found");
                }

                boolean isUser = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));
                boolean isTasker = authentication.getAuthorities().stream()
                                .anyMatch(a -> a.getAuthority().equals("ROLE_TASKER"));

                if (isUser) {
                        chatMessageService.markMessagesAsRead(roomId, userId, SenderType.user);
                } else if (isTasker) {
                        chatMessageService.markMessagesAsRead(roomId, userId, SenderType.tasker);
                }

                return new ResponseData<>(HttpStatus.OK.value(), "Messages marked as read", null);
        }
}
