package com.danmin.home_service.model;

import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "permissions")
public class Permission extends AbstractEntityCreatedAt<Integer> {

    @Column(name = "methods", nullable = false, unique = true)
    private String methods;

    @Column(name = "method_path")
    private String methodPath;

    @Column(name = "description")
    private String description;

    @OneToMany(mappedBy = "permission", fetch = FetchType.EAGER)
    @JsonIgnore
    private Set<Role_Permission> permissions = new HashSet<>();
}
