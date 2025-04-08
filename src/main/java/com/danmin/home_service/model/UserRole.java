package com.danmin.home_service.model;

import java.util.Date;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_roles")
public class UserRole extends AbstractEntityNoDate<Integer> {
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    @Column(name = "assigned_at")
    private Date assignedAt;

    @ManyToOne
    @JoinColumn(name = "assigned_by")
    private User assignedBy;
}
