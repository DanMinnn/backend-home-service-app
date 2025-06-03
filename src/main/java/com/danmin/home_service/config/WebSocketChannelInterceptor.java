package com.danmin.home_service.config;

import java.util.List;
import java.util.Map;

import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class WebSocketChannelInterceptor implements ChannelInterceptor {

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message,
                StompHeaderAccessor.class);

        if (accessor != null) {
            StompCommand command = accessor.getCommand();
            String sessionId = accessor.getSessionId();

            log.debug("Processing WebSocket command: {} for session: {}", command,
                    sessionId);

            if (StompCommand.CONNECT.equals(command)) {
                // For CONNECT command, transfer handshake attributes to STOMP session
                log.debug("CONNECT command received for session: {}", sessionId);

                // Get handshake attributes that were set by JwtHandshakeInterceptor
                Map<String, Object> sessionAttributes = accessor.getSessionAttributes();
                if (sessionAttributes != null) {
                    Object userId = sessionAttributes.get("userId");
                    Object email = sessionAttributes.get("email");
                    Object roles = sessionAttributes.get("roles");
                    Object authenticated = sessionAttributes.get("authenticated");

                    if (userId != null) {
                        log.info("CONNECT successful for userId: {} session: {}", userId, sessionId);

                        // Store these attributes in the accessor for later use
                        accessor.getSessionAttributes().put("userId", userId);
                        accessor.getSessionAttributes().put("email", email);
                        accessor.getSessionAttributes().put("roles", roles);
                        accessor.getSessionAttributes().put("authenticated", authenticated);

                        log.debug("Session attributes preserved: userId={}, email={}, roles={}",
                                userId, email, roles);
                    } else {
                        log.warn("CONNECT userId is null for session: {}", sessionId);
                    }
                } else {
                    log.warn("CONNECT session attributes are null for session: {}", sessionId);
                }

            } else if (StompCommand.SUBSCRIBE.equals(command) ||
                    StompCommand.SEND.equals(command) ||
                    StompCommand.MESSAGE.equals(command)) {

                // For other commands, verify session attributes are available
                Map<String, Object> sessionAttributes = accessor.getSessionAttributes();
                if (sessionAttributes != null) {
                    Object userId = sessionAttributes.get("userId");
                    List<String> roles = (List<String>) sessionAttributes.get("roles");

                    log.debug("Command {} from user: {} with roles: {} for session: {}",
                            command, userId, roles, sessionId);
                } else {
                    log.warn("Session attributes are null for command: {} session: {}",
                            command, sessionId);
                }
            } else if (StompCommand.DISCONNECT.equals(command)) {
                log.debug("DISCONNECT command for session: {}", sessionId);
            }
        } else {
            log.warn("StompHeaderAccessor is null for message");
        }

        return message;
    }

    @Override
    public void postSend(Message<?> message, MessageChannel channel, boolean sent) {
        if (!sent) {
            StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message,
                    StompHeaderAccessor.class);
            if (accessor != null) {
                log.warn("Failed to send message for session: {}, command: {}",
                        accessor.getSessionId(), accessor.getCommand());
            }
        }
    }
}
