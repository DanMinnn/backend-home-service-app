package com.danmin.home_service.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "favorite_tasker", uniqueConstraints = {
        @UniqueConstraint(columnNames = { "user_id, tasker_id, service_id" }) })
public class FavoriteTasker extends AbstractEntityNoDate<Integer> {

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "tasker_id")
    private Tasker tasker;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Services service;
}
