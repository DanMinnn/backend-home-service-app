package com.danmin.home_service.model;

import java.math.BigDecimal;
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
@Table(name = "service_packages")
public class ServicePackages extends AbstractEntityNoDate<Long> {

    @ManyToOne
    @JoinColumn(name = "service_id")
    @JsonIgnore
    private Services services;

    @Column(name = "name", nullable = false)
    private String packageName;

    @Column(name = "description")
    private String packageDescription;

    @Column(name = "base_price")
    private BigDecimal basePrice;

    @OneToMany(mappedBy = "servicePackages", fetch = FetchType.LAZY)
    @Builder.Default
    private Set<PackageVariants> packageVariants = new HashSet<>();
}
