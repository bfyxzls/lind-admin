package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.LoginLog;
import com.lind.lindadmin.entity.OperationLog;
import com.lind.lindadmin.entity.SystemLog;
import com.lind.lindadmin.repository.LoginLogRepository;
import com.lind.lindadmin.repository.OperationLogRepository;
import com.lind.lindadmin.repository.SystemLogRepository;
import com.lind.lindadmin.service.LogService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 日志服务实现类
 */
@Service
@RequiredArgsConstructor
public class LogServiceImpl implements LogService {

	private final SystemLogRepository systemLogRepository;

	private final OperationLogRepository operationLogRepository;

	private final LoginLogRepository loginLogRepository;

	// ==================== 系统日志 ====================

	@Override
	public PageResult<SystemLog> findSystemLogPage(String logType, String logLevel, String operator, Integer pageNum,
			Integer pageSize) {
		Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
		Page<SystemLog> page = systemLogRepository.findByConditions(
				logType != null && !logType.isEmpty() ? logType : null,
				logLevel != null && !logLevel.isEmpty() ? logLevel : null,
				operator != null && !operator.isEmpty() ? operator : null, pageable);
		return PageResult.of(page);
	}

	@Override
	@Async
	public void saveSystemLog(SystemLog log) {
		systemLogRepository.save(log);
	}

	// ==================== 操作日志 ====================

	@Override
	public PageResult<OperationLog> findOperationLogPage(String module, Integer businessType, String operator,
			Integer status, Integer pageNum, Integer pageSize) {
		Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
		Page<OperationLog> page = operationLogRepository.findByConditions(
				module != null && !module.isEmpty() ? module : null, businessType,
				operator != null && !operator.isEmpty() ? operator : null, status, pageable);
		return PageResult.of(page);
	}

	@Override
	@Async
	public void saveOperationLog(OperationLog log) {
		operationLogRepository.save(log);
	}

	// ==================== 登录日志 ====================

	@Override
	public PageResult<LoginLog> findLoginLogPage(String username, String loginIp, Integer status, Integer pageNum,
			Integer pageSize) {
		Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
		Page<LoginLog> page = loginLogRepository.findByConditions(
				username != null && !username.isEmpty() ? username : null,
				loginIp != null && !loginIp.isEmpty() ? loginIp : null, status, pageable);
		return PageResult.of(page);
	}

	@Override
	@Async
	public void saveLoginLog(LoginLog log) {
		loginLogRepository.save(log);
	}

}
