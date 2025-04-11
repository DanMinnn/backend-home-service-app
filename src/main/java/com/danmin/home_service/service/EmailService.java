package com.danmin.home_service.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Email;
import com.sendgrid.helpers.mail.objects.Personalization;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j(topic = "EMAIL-SERVICE")
@RequiredArgsConstructor
public class EmailService {

    private final SendGrid sendGrid;
    private final RedisService redisService;

    @Value("${spring.sendgrid.fromEmail}")
    private String from;

    @Value("${spring.sendgrid.templateId}")
    private String templateId;

    @Value("${spring.sendgrid.verificationLink}")
    private String verificationLink;

    /**
     * Email verification by SendGrid
     * 
     * @param to
     * @throws IOException
     */
    public void sendEmailVerification(String to, String userType) throws IOException {
        log.info("Email verification started");

        Email fromEmail = new Email(from, "Home Service");
        Email toEmail = new Email(to);

        String subject = "Home Service Verification";

        String value = UUID.randomUUID().toString();

        String secretCode = String.format("?secretCode=%s", value);

        // TODO generate secretCode and save to redis
        redisService.save(userType, value, 24);

        // definition template
        Map<String, String> map = new HashMap<>();
        map.put("verification_link", verificationLink + secretCode + "&userType=" + userType);

        Mail mail = new Mail();
        mail.setFrom(fromEmail);
        mail.setSubject(subject);

        Personalization personalization = new Personalization();
        personalization.addTo(toEmail);

        // add to dynamic data
        map.forEach(personalization::addDynamicTemplateData);

        mail.addPersonalization(personalization);
        mail.setTemplateId(templateId);

        Request request = new Request();
        request.setMethod(Method.POST);
        request.setEndpoint("mail/send");
        request.setBody(mail.build());

        Response response = sendGrid.api(request);
        if (response.getStatusCode() == 202) {
            log.info("Email sent successfully !");
        } else {
            log.info("Email sent failed");
            log.info("status code = {}", response.getStatusCode());
        }
    }
}
