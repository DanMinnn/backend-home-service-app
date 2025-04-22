package com.danmin.home_service.model;

import com.danmin.home_service.common.MethodType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "payment_methods")
public class PaymentMethods extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "method_type", nullable = false)
    private MethodType methodType;

    @Column(name = "is_active")
    private Boolean isActive = true;

}
