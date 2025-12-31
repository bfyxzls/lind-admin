package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.LoginLog;
import com.lind.lindadmin.entity.OperationLog;
import com.lind.lindadmin.entity.SystemLog;
import com.lind.lindadmin.service.LogService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 日志管理Controller
 */
@RestController
@RequestMapping("/api/log")
@RequiredArgsConstructor
public class LogController {

    private final LogService logService;

    /**
     * 分页查询系统日志
     */
    @GetMapping("/system/page")
    @PreAuthorize("hasAuthority('system:log:system')")
    public Result<PageResult<SystemLog>> systemLogPage(
            @RequestParam(required = false) String logType,
            @RequestParam(required = false) String logLevel,
            @RequestParam(required = false) String operator,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(logService.findSystemLogPage(logType, logLevel, operator, pageNum, pageSize));
    }

    /**
     * 分页查询操作日志
     */
    @GetMapping("/operation/page")
    @PreAuthorize("hasAuthority('system:log:operation')")
    public Result<PageResult<OperationLog>> operationLogPage(
            @RequestParam(required = false) String module,
            @RequestParam(required = false) Integer businessType,
            @RequestParam(required = false) String operator,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(logService.findOperationLogPage(module, businessType, operator, status, pageNum, pageSize));
    }

    /**
     * 分页查询登录日志
     */
    @GetMapping("/login/page")
    @PreAuthorize("hasAuthority('system:log:login')")
    public Result<PageResult<LoginLog>> loginLogPage(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String loginIp,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(logService.findLoginLogPage(username, loginIp, status, pageNum, pageSize));
    }
}

