package com.danmin.home_service.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.danmin.home_service.model.TaskerReputation;
import com.danmin.home_service.repository.TaskerRepository;
import com.danmin.home_service.repository.TaskerReputationRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReputationService {

    private final TaskerReputationRepository taskerReputationRepository;
    private final TaskerRepository taskerRepository;
    private static final BigDecimal DEFAULT_REPUTATION_SCORE = new BigDecimal("1.8");
    private static final int TOP_TASKERS_COUNT = 5;

    public BigDecimal getTaskerReputationScore(Long taskerId) {
        Optional<TaskerReputation> reputation = taskerReputationRepository.findByTaskerId(taskerId.intValue());
        return reputation.map(TaskerReputation::getReputationScore).orElse(DEFAULT_REPUTATION_SCORE);
    }

    public boolean isTopPerformer(Long taskerId) {
        // Get all taskers ranked by reputation
        List<Long> allTaskerIds = taskerRepository.findAll().stream()
                .map(tasker -> tasker.getId().longValue())
                .sorted((id1, id2) -> {
                    BigDecimal score1 = getTaskerReputationScore(id1);
                    BigDecimal score2 = getTaskerReputationScore(id2);
                    return score2.compareTo(score1); // Higher score first
                })
                .collect(Collectors.toList());

        // Check if the tasker is in the top 5
        int position = allTaskerIds.indexOf(taskerId);
        return position >= 0 && position < TOP_TASKERS_COUNT;
    }
}
