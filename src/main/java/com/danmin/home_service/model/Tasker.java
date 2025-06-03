package com.danmin.home_service.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.locationtech.jts.geom.Point;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import com.danmin.home_service.common.AvailabilityStatus;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@Entity
@Table(name = "tasker", uniqueConstraints = { @UniqueConstraint(columnNames = "email, phone_number") })
public class Tasker extends AbstractUser<Integer> implements BaseUser {

    @Column(name = "earth_location", columnDefinition = "geometry(Point,4326)")
    private Point earthLocation;

    @Column(name = "latitude")
    private BigDecimal latitude;

    @Column(name = "longitude")
    private BigDecimal longitude;

    @Column(name = "average_rating")
    private Double average_rating;

    @Column(name = "total_earnings")
    private Double total_earnings;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "availability_status")
    private AvailabilityStatus availabilityStatus;

    @OneToMany(mappedBy = "tasker", fetch = FetchType.LAZY)
    @Builder.Default
    private Set<UserVerifications> userVerifications = new HashSet<>();

    @OneToMany(mappedBy = "tasker", fetch = FetchType.EAGER)
    @JsonIgnore
    @Builder.Default
    private Set<TaskerRole> taskerRoles = new HashSet<>();

    @JsonIgnore
    @OneToMany(mappedBy = "tasker", fetch = FetchType.LAZY)
    @Builder.Default
    private Set<TaskerServiceModel> taskerServices = new HashSet<>();

    public void saveService(TaskerServiceModel services) {
        if (services != null) {
            if (taskerServices == null) {
                taskerServices = new HashSet<>();
            }
            taskerServices.add(services);
            services.setTasker(this);
        }
    }

    @Override
    public String getPassword() {
        return super.getPasswordHash();
    }

    @Override
    public String getUsername() {
        return super.getEmail();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();

        try {
            if (taskerRoles != null && !taskerRoles.isEmpty()) {
                for (TaskerRole taskerRole : taskerRoles) {
                    authorities.add(
                            new SimpleGrantedAuthority("ROLE_" + taskerRole.getRole().getRoleName().toUpperCase()));

                    for (Role_Permission role_Permission : taskerRole.getRole().getRolePermissions()) {
                        Permission permission = role_Permission.getPermission();
                        authorities.add(new SimpleGrantedAuthority(
                                permission.getMethods() + ":" + permission.getMethodPath()));
                    }
                }
            }
        } catch (Exception e) {
            // If lazy loading fails, return empty authorities
            // The permission check will be handled by PermissionService
            return authorities;
        }
        return authorities;
    }

}
