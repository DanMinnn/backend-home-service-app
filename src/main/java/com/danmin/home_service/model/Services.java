package com.danmin.home_service.model;

import java.util.Comparator;
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
@Table(name = "services")
public class Services extends AbstractEntity<Long> {

    @ManyToOne
    @JoinColumn(name = "category_id")
    @JsonIgnore
    private ServiceCategory category;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "icon")
    private String icon;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    @OneToMany(mappedBy = "services", fetch = FetchType.LAZY)
    @Builder.Default
    private Set<ServicePackages> servicePackages = new HashSet<>();

    public static Comparator<Services> compareByName() {
        return Comparator.comparing(Services::getName,
                Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
    }
}
