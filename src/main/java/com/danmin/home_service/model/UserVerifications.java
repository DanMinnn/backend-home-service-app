package com.danmin.home_service.model;

import java.util.Date;

import org.hibernate.annotations.Check;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.VerificationType;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_verifications")
@Check(constraints = "(user_id IS NULL AND tasker_id IS NOT NULL) OR (user_id IS NOT NULL AND tasker_id IS NULL)")
public class UserVerifications extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = true)
    private User user;

    @ManyToOne
    @JoinColumn(name = "tasker_id", referencedColumnName = "id", nullable = true)
    private Tasker tasker;

    @Column(name = "verification_code")
    private String verificationCode;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "verification_type")
    private VerificationType verificationType;

    @Column(name = "expires_at")
    private Date expiresAt;

    @Column(name = "is_used")
    private boolean isUsed = false;
}
