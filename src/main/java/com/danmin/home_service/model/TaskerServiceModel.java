package com.danmin.home_service.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tasker_services", uniqueConstraints = { @UniqueConstraint(columnNames = { "tasker_id, service_id" }) })
public class TaskerServiceModel extends AbstractEntityNoDate<Integer> {

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Services service;

    @Column(name = "tasker_name")
    private String taskerName;

    @Column(name = "service_name")
    private String serviceName;

    @Column(name = "is_verified")
    @Builder.Default
    private Boolean isVerified = false;

}
