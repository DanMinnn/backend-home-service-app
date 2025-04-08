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
@Table(name = "tasker_roles")
public class TaskerRole extends AbstractEntity<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    @Column(name = "assigned_at")
    private Date assignedAt;

    @ManyToOne
    @JoinColumn(name = "assigned_by")
    private User assignedBy;
}
