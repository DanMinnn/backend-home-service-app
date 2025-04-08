package com.danmin.home_service.model;

import java.time.LocalDateTime;

import org.hibernate.annotations.Check;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.*;

@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "account", uniqueConstraints = { @UniqueConstraint(columnNames = "email"),
        @UniqueConstraint(columnNames = "phone_number") })
@Check(constraints = "(user_id IS NULL AND tasker_id IS NOT NULL) OR (user_id IS NOT NULL AND tasker_id IS NULL)")
public class Account extends AbstractEntity<Long> {

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = true)
    private User user;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tasker_id", referencedColumnName = "id", nullable = true)
    private Tasker tasker;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(name = "phone_number", nullable = false, length = 15)
    private String phoneNumber;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "profile_image")
    private String profileImage;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "is_verified")
    private Boolean isVerified = false;

    @Column(name = "is_active")
    private Boolean isActive = true;
}
