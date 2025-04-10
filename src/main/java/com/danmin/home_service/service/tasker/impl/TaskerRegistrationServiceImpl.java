package com.danmin.home_service.service.tasker.impl;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.danmin.home_service.dto.request.TaskerRegisterDTO;
import com.danmin.home_service.exception.InvalidDataException;
import com.danmin.home_service.model.Tasker;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.service.tasker.TaskerRegistrationService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TaskerRegistrationServiceImpl implements TaskerRegistrationService {
    private final TaskerRepository taskerRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(rollbackOn = Exception.class)
    public long saveTasker(TaskerRegisterDTO reqTasker) {

        Tasker taskerByEmail = taskerRepository.findByEmail(reqTasker.getEmail());

        if (taskerByEmail != null) {
            throw new InvalidDataException("Email already exists");
        }

        // Tạo GeometryFactory với SRID 4326 (WGS84)
        GeometryFactory geometryFactory = new GeometryFactory(
                new PrecisionModel(PrecisionModel.FLOATING),
                4326 // SRID
        );

        Point location = geometryFactory.createPoint(
                new Coordinate(
                        reqTasker.getLongitude().doubleValue(),
                        reqTasker.getLatitude().doubleValue()));

        Tasker tasker = Tasker.builder().firstLastName(reqTasker.getFirstLastName())
                .email(reqTasker.getEmail())
                .phoneNumber(reqTasker.getPhoneNumber())
                .passwordHash(passwordEncoder.encode(reqTasker.getPassword()))
                .isVerified(reqTasker.isVerify())
                .availabilityStatus(reqTasker.getStatus())
                .average_rating(0.0)
                .total_earnings(0.0)
                .latitude(reqTasker.getLatitude())
                .longitude(reqTasker.getLongitude())
                .earthLocation(location)
                .build();

        taskerRepository.save(tasker);

        return tasker.getId();
    }

}
