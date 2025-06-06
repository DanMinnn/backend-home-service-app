package com.danmin.home_service.service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.ChatbotDTO;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.ChatbotInteraction;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.ChatbotRepository;
import com.danmin.home_service.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatbotService {
    private final ChatbotRepository chatbotRepository;
    private final UserRepository userRepository;

    private User getUserById(Integer userId) {
        return userRepository.findById(userId.longValue())
                .orElseThrow(() -> new ResourceNotFoundException("CHATBOT-USER NOT FOUND!"));
    }

    public void saveConversation(ChatbotDTO chatbotDTO) {
        User user = getUserById(chatbotDTO.getUserId());

        chatbotRepository.save(ChatbotInteraction.builder().user(user).message(chatbotDTO.getQuery())
                .response(chatbotDTO.getResponse()).build());
    }

    public List<ChatbotDTO> getConversation(Integer userId, int page, int size) {
        User user = getUserById(userId);

        Pageable pageable = PageRequest.of(page, size);
        List<ChatbotInteraction> messages = chatbotRepository.getChatByUserId(user.getId(), pageable);
        Collections.reverse(messages);

        return messages.stream()
                .map(message -> ChatbotDTO.builder().query(message.getMessage()).response(message.getResponse())
                        .userId(message.getUser().getId()).sentAt(message.getCreatedAt()).build())
                .collect(Collectors.toList());
    }
}
