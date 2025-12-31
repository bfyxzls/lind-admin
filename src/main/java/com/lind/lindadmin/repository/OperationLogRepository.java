package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.OperationLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * 操作日志Repository
 */
@Repository
public interface OperationLogRepository extends JpaRepository<OperationLog, Long> {

    /**
     * 分页查询操作日志
     */
    @Query("SELECT o FROM OperationLog o WHERE " +
            "(:module IS NULL OR o.module = :module) " +
            "AND (:businessType IS NULL OR o.businessType = :businessType) " +
            "AND (:operator IS NULL OR o.operator LIKE %:operator%) " +
            "AND (:status IS NULL OR o.status = :status) " +
            "ORDER BY o.createdTime DESC")
    Page<OperationLog> findByConditions(
            @Param("module") String module,
            @Param("businessType") Integer businessType,
            @Param("operator") String operator,
            @Param("status") Integer status,
            Pageable pageable
    );
}

