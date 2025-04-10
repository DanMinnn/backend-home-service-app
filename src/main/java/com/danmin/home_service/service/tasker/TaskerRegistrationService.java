package com.danmin.home_service.service.tasker;

import com.danmin.home_service.dto.request.TaskerRegisterDTO;

public interface TaskerRegistrationService {

    long saveTasker(TaskerRegisterDTO reqTasker);
}
