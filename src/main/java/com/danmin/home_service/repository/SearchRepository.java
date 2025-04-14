package com.danmin.home_service.repository;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.danmin.home_service.dto.response.PageResponse;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Repository
public class SearchRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public <T> PageResponse<?> getAllUserWithSortByColumnsAndSearch(int pageNo, int pageSize, String search,
            String sortBy, Class<T> entityClass) {

        StringBuilder sqlQuery = new StringBuilder(
                "select new com.danmin.home_service.dto.response.UserResponse(u.id, u.firstLastName, u.phoneNumber, u.email, u.isActive, u.lastLogin) from "
                        + entityClass + " u where 1=1");

        if (StringUtils.hasLength(search)) {
            sqlQuery.append(" and lower(u.firstLastName) like lower(:firstLastName)");
            sqlQuery.append(" or lower(u.phoneNumber) like lower(:phoneNumber)");
        }

        if (StringUtils.hasLength(sortBy)) {
            Pattern pattern = Pattern.compile("(\\w+?)(:)(.*)");
            Matcher matcher = pattern.matcher(sortBy);
            if (matcher.find()) {
                sqlQuery.append(String.format(" order by u.%s %s", matcher.group(1), matcher.group(3)));
            }
        }

        Query selectQuery = entityManager.createQuery(sqlQuery.toString());

        selectQuery.setFirstResult(pageNo);
        selectQuery.setMaxResults(pageSize);

        if (StringUtils.hasLength(search)) {
            selectQuery.setParameter("firstLastName", String.format("%%%s%%", search));
            selectQuery.setParameter("phoneNumber", String.format("%%%s%%", search));
        }

        List users = selectQuery.getResultList();

        System.out.println(users);

        StringBuilder sqlCountQuery = new StringBuilder("select count(*) from " + entityClass + " u");
        if (StringUtils.hasLength(search)) {
            sqlCountQuery.append(" where lower(u.firstLastName) like lower(?1)");
            sqlCountQuery.append(" or lower(u.phoneNumber) like lower(?2)");
        }

        Query selectCountQuery = entityManager.createQuery(sqlCountQuery.toString());

        if (StringUtils.hasLength(search)) {
            selectCountQuery.setParameter(1, String.format("%%%s%%", search));
            selectCountQuery.setParameter(2, String.format("%%%s%%", search));
        }

        Long totalElements = (Long) selectCountQuery.getSingleResult();

        Page<?> page = new PageImpl<Object>(users, PageRequest.of(pageNo, pageSize), totalElements);

        return PageResponse.builder()
                .pageNo(pageNo)
                .pageSize(pageSize)
                .totalPage(page.getTotalPages())
                .items(page.stream().toList())
                .build();
    }
}
