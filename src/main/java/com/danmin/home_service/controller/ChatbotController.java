package com.danmin.home_service.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.ChatbotDTO;
import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.ChatbotService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j(topic = "CHATBOT-CONTROLLER")
@RequiredArgsConstructor
@Tag(name = "Chatbot Controller")
@RequestMapping("/chatbot")
public class ChatbotController {
    private final ChatbotService chatbotService;

    @Operation(summary = "Chatbot interaction")
    @PostMapping("/save")
    public ResponseData<?> saveResponse(@RequestBody ChatbotDTO chatbotDTO) {
        chatbotService.saveConversation(chatbotDTO);
        return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Saved successfully");
    }

    @Operation(summary = "Get chat conversation")
    @GetMapping("/{userId}/chatbot-conversation")
    public ResponseData<?> getChatbotConversation(@PathVariable(value = "userId") Integer userId,
            @RequestParam(required = false, defaultValue = "0") Integer page,
            @RequestParam(required = false, defaultValue = "50") Integer size) {
        try {
            return new ResponseData<>(HttpStatus.ACCEPTED.value(), "Saved successfully",
                    chatbotService.getConversation(userId, page, size));
        } catch (Exception e) {
            return new ResponseError(HttpStatus.INTERNAL_SERVER_ERROR.value(), "Get chat conservation failed");
        }
    }
}
