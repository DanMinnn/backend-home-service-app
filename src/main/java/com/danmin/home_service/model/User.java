package com.danmin.home_service.model;

import java.util.HashSet;
import java.util.Set;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.danmin.home_service.common.UserType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User extends AbstractEntityNoDate<Integer> {

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "user_type")
    private UserType userType;

    @OneToOne(mappedBy = "user", fetch = FetchType.LAZY)
    private Account account;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<UserVerifications> userVerifications = new HashSet<>();
}
