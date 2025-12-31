package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.SystemLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * 系统日志Repository
 */
@Repository
public interface SystemLogRepository extends JpaRepository<SystemLog, Long> {

    /**
     * 分页查询系统日志
     */
    @Query("SELECT s FROM SystemLog s WHERE " +
            "(:logType IS NULL OR s.logType = :logType) " +
            "AND (:logLevel IS NULL OR s.logLevel = :logLevel) " +
            "AND (:operator IS NULL OR s.operator LIKE %:operator%) " +
            "ORDER BY s.createdTime DESC")
    Page<SystemLog> findByConditions(
            @Param("logType") String logType,
            @Param("logLevel") String logLevel,
            @Param("operator") String operator,
            Pageable pageable
    );
}

