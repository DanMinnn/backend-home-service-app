package com.danmin.home_service.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.danmin.home_service.dto.response.TaskerServiceResponse;
import com.danmin.home_service.model.TaskerServiceModel;

@Repository
public interface TaskerServiceRepository extends JpaRepository<TaskerServiceModel, Long> {

    @Query("SELECT new com.danmin.home_service.dto.response.TaskerServiceResponse(ts.service.id, ts.serviceName, ts.service.icon) "
            +
            " FROM TaskerServiceModel ts JOIN Tasker t ON ts.tasker.id = t.id WHERE t.id = :taskerId")
    List<TaskerServiceResponse> getServicesOfTasker(@Param("taskerId") Integer taskerId);
}
