package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.LoginLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * 登录日志Repository
 */
@Repository
public interface LoginLogRepository extends JpaRepository<LoginLog, Long> {

    /**
     * 分页查询登录日志
     */
    @Query("SELECT l FROM LoginLog l WHERE " +
            "(:username IS NULL OR l.username LIKE %:username%) " +
            "AND (:loginIp IS NULL OR l.loginIp LIKE %:loginIp%) " +
            "AND (:status IS NULL OR l.status = :status) " +
            "ORDER BY l.loginTime DESC")
    Page<LoginLog> findByConditions(
            @Param("username") String username,
            @Param("loginIp") String loginIp,
            @Param("status") Integer status,
            Pageable pageable
    );
}

