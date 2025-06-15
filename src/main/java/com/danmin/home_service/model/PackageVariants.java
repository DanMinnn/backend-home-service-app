package com.danmin.home_service.model;

import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "package_variants")
public class PackageVariants extends AbstractEntityNoDate<Long> {

    @ManyToOne
    @JoinColumn(name = "package_id")
    @JsonIgnore
    private ServicePackages servicePackages;

    @Column(name = "variant_name", nullable = false)
    private String variantName;

    @Column(name = "variant_description")
    private String variantDescription;

    @Column(name = "additional_price")
    private BigDecimal additionalPrice;

    @Column(name = "is_deleted")
    @Builder.Default
    private Boolean isDeleted = false;

}
