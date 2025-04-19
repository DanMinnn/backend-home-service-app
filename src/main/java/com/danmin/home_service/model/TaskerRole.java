package com.danmin.home_service.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_roles")
public class TaskerRole extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
}
