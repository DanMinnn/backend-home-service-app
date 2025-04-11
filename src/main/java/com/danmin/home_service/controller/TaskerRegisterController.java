package com.danmin.home_service.controller;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.TaskerRegisterDTO;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.service.EmailService;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/register/tasker")
@Tag(name = "Tasker Register Controller")
@Slf4j
@Validated
public class TaskerRegisterController extends RegistrationController<Tasker, TaskerRegisterDTO> {

    public TaskerRegisterController(
            RedisService redisService,
            EmailService emailService,
            RegistrationService registrationService) {
        super(redisService, emailService, registrationService,
                Tasker.class, "TASKER", "https://tayjava.vn/tasker-dashboard");
    }

    // private final TaskerRegistrationService taskerRegistrationService;
    // private final RedisService redisService;
    // private final EmailService emailService;

    // @PostMapping("/")
    // public String addTasker(@Valid @RequestBody TaskerRegisterDTO req) throws
    // IOException {

    // log.info("Request add tasker " + req.getFirstLastName());

    // try {
    // // save reg into Redis
    // redisService.save("REGISTER-TASKER::", req, 24);

    // emailService.sendEmailVerification(req.getEmail());

    // return "Verification code sent to your email.";
    // } catch (Exception e) {
    // log.error("errorMessage={}", e.getMessage(), e.getCause());
    // System.out.println("errorMessage={}" + e.getMessage() + e.getCause());
    // return "Failed to send verification code.";
    // }
    // }

    // // @PostMapping("/")
    // // public ResponseData<Long> addTasker(@Valid @RequestBody TaskerRegisterDTO
    // // req) throws IOException {

    // // log.info("Request add tasker " + req.getFirstLastName());

    // // try {
    // // long taskerId = taskerRegistrationService.saveTasker(req);

    // // return new ResponseData<>(HttpStatus.OK.value(), "Save successfully",
    // // taskerId);
    // // } catch (Exception e) {
    // // log.error("errorMessage={}", e.getMessage(), e.getCause());
    // // System.out.println("errorMessage={}" + e.getMessage() + e.getCause());
    // // return new ResponseError(HttpStatus.BAD_REQUEST.value(), "save failed");
    // // }
    // // }

    // @GetMapping("/confirm-email")
    // public ResponseData<Long> confirmEmail(@RequestParam String secretCode,
    // HttpServletResponse response)
    // throws IOException {
    // log.info("Confirm email: {}", secretCode);

    // try {
    // // check secretCode from Redis
    // String key = redisService.getSecretCode("secretCode");

    // if (key == null) {
    // log.info("Verification expired or registration not found.");
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Verification
    // expired");
    // }

    // // save user
    // TaskerRegisterDTO req = redisService.get("REGISTER-TASKER::",
    // TaskerRegisterDTO.class);
    // req.setVerify(true);
    // long taskerId = taskerRegistrationService.saveTasker(req);

    // redisService.delete("secretCode");
    // redisService.delete("REGISTER-TASKER::");

    // return new ResponseData<>(HttpStatus.OK.value(), "Save successfully",
    // taskerId);
    // } catch (Exception e) {
    // log.error("Confirm email was failed!, errorMessage={}", e.getMessage());
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Save failed");
    // } finally {
    // response.sendRedirect("https://tayjava.vn/wp-admin");
    // }

    // }

}
