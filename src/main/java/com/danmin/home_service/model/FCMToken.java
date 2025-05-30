package com.danmin.home_service.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "fcm_tokens")
public class FCMToken extends AbstractEntity<Long> {
    @Column(nullable = false)
    private String token;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "tasker_id")
    private Integer taskerId;

    @Column(name = "device_id")
    private String deviceId;
}
