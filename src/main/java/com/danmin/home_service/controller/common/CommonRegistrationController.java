package com.danmin.home_service.controller.common;

import java.io.IOException;
import java.io.PrintWriter;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.danmin.home_service.dto.response.ResponseData;
import com.danmin.home_service.dto.response.ResponseError;
import com.danmin.home_service.service.RegistrationService;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/register")
@Slf4j
@RequiredArgsConstructor
public class CommonRegistrationController {
    private final RegistrationService registrationService;

    @GetMapping("/confirm-email")
    public ResponseData<Long> confirmEmail(@RequestParam String secretCode, @RequestParam String userType,
            HttpServletResponse response)
            throws IOException {
        log.info("Confirm email for {}: {}", userType, secretCode);

        try {
            boolean verified = registrationService.verifyUser(secretCode, userType);

            if (!verified) {
                return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Verification failed or expired");
            }

            String redirectUrl = "";

            if (userType.equals("TASKER")) {
                redirectUrl = "homeservicetasker://authorized/email-verified?userType=" + userType
                        + "&success=true&secretCode="
                        + secretCode;
            } else {
                redirectUrl = "home_service_user://auth/email-verified?userType=" + userType
                        + "&success=true&secretCode="
                        + secretCode;
            }

            String fallbackUrl = "https://tayjava.vn";

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Email Verified Successfully</title>");
            out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            out.println("<script type=\"text/javascript\">");
            out.println("  window.onload = function() {");
            out.println("    setTimeout(function() {");
            out.println("      window.location.href = '" + redirectUrl + "';");
            out.println("    }, 3000);"); // Delay app open by 3 seconds
            out.println("    setTimeout(function() {");
            out.println("      window.location.href = '" + fallbackUrl + "';");
            out.println("    }, 20000);"); // Fallback after 20 seconds if app didn't open
            out.println("  };");
            out.println("</script>");
            out.println("<style>");
            out.println("  body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }");
            out.println("  .container { max-width: 500px; margin: 0 auto; }");
            out.println("  h1 { color: #4CAF50; }");
            out.println("  p { font-size: 16px; line-height: 1.5; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class=\"container\">");
            out.println("<h1>Email Verified Successfully!</h1>");
            out.println("<p>Redirecting you to the app...</p>");
            out.println("<p>If the app does not open, you will be redirected to the website in a few seconds.</p>");
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
            out.flush();

            return new ResponseData<>(HttpStatus.OK.value(), "Registration completed successfully", null);
        } catch (Exception e) {
            log.error("Confirm email was failed!, errorMessage={}", e.getMessage());
            return new ResponseError(HttpStatus.BAD_REQUEST.value(), "Registration failed");
        }
    }
}
