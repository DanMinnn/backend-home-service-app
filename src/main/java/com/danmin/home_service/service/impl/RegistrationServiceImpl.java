package com.danmin.home_service.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.RegisterDTO;
import com.danmin.home_service.dto.request.TaskerRegisterDTO;
import com.danmin.home_service.dto.request.UserRegisterDTO;
import com.danmin.home_service.exception.ResourceNotFoundException;
import com.danmin.home_service.model.AbstractUser;
import com.danmin.home_service.model.Role;
import com.danmin.home_service.model.Services;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.model.TaskerRole;
import com.danmin.home_service.model.TaskerService;
import com.danmin.home_service.model.User;
import com.danmin.home_service.model.UserRole;
import com.danmin.home_service.model.UserWallet;
import com.danmin.home_service.repository.RoleRepository;
import com.danmin.home_service.repository.ServiceRepository;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.TaskerRoleRepository;
import com.danmin.home_service.repository.TaskerServiceRepository;
import com.danmin.home_service.repository.UserRepository;
import com.danmin.home_service.repository.UserRoleRepository;
import com.danmin.home_service.repository.UserWalletRepository;
import com.danmin.home_service.service.RedisService;
import com.danmin.home_service.service.RegistrationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class RegistrationServiceImpl implements RegistrationService {

    private final UserRepository userRepository;
    private final TaskerRepository taskerRepository;
    private final PasswordEncoder passwordEncoder;
    private final RedisService redisService;
    private final ServiceRepository serviceRepository;
    private final TaskerServiceRepository taskerServiceRepository;

    // role
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final TaskerRoleRepository taskerRoleRepository;

    // wallet
    private final UserWalletRepository userWalletRepository;

    @Override
    public <T extends AbstractUser<?>> long registerUser(RegisterDTO dto, Class<T> userType) {
        String encodedPassword = passwordEncoder.encode(dto.getPassword());

        if (userType.equals(User.class)) {

            Role userRole = roleRepository.findByRoleName("user").orElse(null);

            UserRegisterDTO userDTO = (UserRegisterDTO) dto;
            User user = User.builder()
                    .email(dto.getEmail())
                    .phoneNumber(dto.getPhoneNumber())
                    .passwordHash(encodedPassword)
                    .firstLastName(dto.getFirstLastName())
                    .isVerified(dto.isVerify())
                    .isActive(dto.isActive())
                    .userType(userDTO.getType())
                    .build();

            User savedUser = userRepository.save(user);

            // role user
            userRoleRepository.save(UserRole.builder().user(savedUser).role(userRole).build());
            // wallet user
            userWalletRepository.save(UserWallet.builder().user(savedUser).balance(BigDecimal.valueOf(500000))
                    .updatedAt(LocalDateTime.now()).build());
            return savedUser.getId();

        } else if (userType.equals(Tasker.class)) {

            Role taskerRole = roleRepository.findByRoleName("tasker").orElse(null);

            TaskerRegisterDTO taskerDTO = (TaskerRegisterDTO) dto;
            Tasker tasker = Tasker.builder()
                    .email(dto.getEmail())
                    .phoneNumber(dto.getPhoneNumber())
                    .passwordHash(encodedPassword)
                    .firstLastName(dto.getFirstLastName())
                    .availabilityStatus(taskerDTO.getStatus())
                    .isVerified(dto.isVerify())
                    .isActive(dto.isActive())
                    .build();

            Tasker savedTasker = taskerRepository.save(tasker);

            // role tasker
            taskerRoleRepository.save(TaskerRole.builder().tasker(savedTasker).role(taskerRole).build());

            /*
             * // when tasker register, they can choose service apply for job
             * if (taskerDTO.getServiceIds() != null &&
             * !taskerDTO.getServiceIds().isEmpty()) {
             * for (Long serviceId : taskerDTO.getServiceIds()) {
             * Services services = serviceRepository.findById(serviceId).orElseThrow(
             * () -> new ResourceNotFoundException("Service not found with id: " +
             * serviceId));
             * 
             * TaskerService taskerService =
             * TaskerService.builder().tasker(tasker).service(services)
             * .experienceYears(2.0).isVerified(true).build();
             * 
             * taskerServiceRepository.save(taskerService);
             * }
             * }
             */

            return savedTasker.getId();
        }
        throw new IllegalArgumentException("Unsupported user type: " + userType.getName());
    }

    @Override
    public boolean verifyUser(String secretCode, String userType) {
        String key = redisService.getSecretCode(userType);

        if (key == null) {
            log.info("Verification expired or not found for {}", userType);
            return false;
        }

        if ("USER".equals(userType)) {
            UserRegisterDTO dto = redisService.get("REGISTER::USER", UserRegisterDTO.class);
            dto.setVerify(true);
            dto.setActive(true);

            log.info("User {} registered successfully", dto.getEmail());
            registerUser(dto, User.class);

        } else if ("TASKER".equals(userType)) {
            TaskerRegisterDTO dto = redisService.get("REGISTER::TASKER", TaskerRegisterDTO.class);
            dto.setVerify(true);
            dto.setActive(true);
            registerUser(dto, Tasker.class);
        }

        redisService.delete(userType);
        redisService.delete("REGISTER::" + userType);

        return true;
    }

}
