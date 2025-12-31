package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.LoginLog;
import com.lind.lindadmin.entity.OperationLog;
import com.lind.lindadmin.entity.SystemLog;

/**
 * 日志服务接口
 */
public interface LogService {

    // ==================== 系统日志 ====================

    /**
     * 分页查询系统日志
     */
    PageResult<SystemLog> findSystemLogPage(String logType, String logLevel, String operator, Integer pageNum, Integer pageSize);

    /**
     * 保存系统日志
     */
    void saveSystemLog(SystemLog log);

    // ==================== 操作日志 ====================

    /**
     * 分页查询操作日志
     */
    PageResult<OperationLog> findOperationLogPage(String module, Integer businessType, String operator, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 保存操作日志
     */
    void saveOperationLog(OperationLog log);

    // ==================== 登录日志 ====================

    /**
     * 分页查询登录日志
     */
    PageResult<LoginLog> findLoginLogPage(String username, String loginIp, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 保存登录日志
     */
    void saveLoginLog(LoginLog log);
}

