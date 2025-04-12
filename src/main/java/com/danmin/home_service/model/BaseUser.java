package com.danmin.home_service.model;

import java.io.Serializable;
import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public interface BaseUser extends UserDetails, Serializable {
    Integer getId();

    String getEmail();

    Collection<? extends GrantedAuthority> getAuthorities();

}
