package com.danmin.home_service.controller;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.request.UserRegisterDTO;
import com.danmin.home_service.model.User;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.service.EmailService;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/register/user")
@Tag(name = "User Register Controller")
@Slf4j
@Validated
public class UserRegisterController extends RegistrationController<User, UserRegisterDTO> {

    public UserRegisterController(
            RedisService redisService,
            EmailService emailService,
            RegistrationService registrationService,
            UserRepository userRepository,
            TaskerRepository taskerRepository) {
        super(redisService, emailService, registrationService,
                User.class, "USER", "https://tayjava.vn/wp-admin", userRepository, taskerRepository);
    }

    // private final UserRegisterService userRegisterService;
    // private final RedisService redisService;
    // private final EmailService emailService;

    // @PostMapping("/")
    // public String addUser(@Valid @RequestBody UserRegisterDTO req) throws
    // IOException {

    // log.info("Request add user " + req.getFirstLastName());

    // try {
    // // save reg into Redis
    // redisService.save("REGISTER::", req, 24);

    // emailService.sendEmailVerification(req.getEmail());

    // return "Verification code sent to your email.";
    // } catch (Exception e) {
    // log.error("errorMessage={}", e.getMessage(), e.getCause());
    // System.out.println("errorMessage={}" + e.getMessage() + e.getCause());
    // return "Failed to send verification code.";
    // }
    // }

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
    // }

    // // save user
    // UserRegisterDTO req = redisService.get("REGISTER::", UserRegisterDTO.class);
    // req.setVerify(true);
    // long userId = userRegisterService.saveUser(req);

    // redisService.delete("secretCode");
    // redisService.delete("REGISTER::");

    // return new ResponseData<>(HttpStatus.OK.value(), "Save successfully",
    // userId);
    // } catch (Exception e) {
    // log.error("Confirm email was failed!, errorMessage={}", e.getMessage());
    // return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Save failed");
    // } finally {
    // response.sendRedirect("https://tayjava.vn/wp-admin");
    // }

    // }

}
