package com.lind.lindadmin.common;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

	/**
	 * 处理业务异常
	 */
	@ExceptionHandler(BusinessException.class)
	public Result<Void> handleBusinessException(BusinessException e, HttpServletRequest request) {
		log.error("业务异常: {} - {}", request.getRequestURI(), e.getMessage());
		return Result.error(e.getCode(), e.getMessage());
	}

	/**
	 * 处理参数校验异常
	 */
	@ExceptionHandler(MethodArgumentNotValidException.class)
	public Result<Void> handleValidationException(MethodArgumentNotValidException e) {
		List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
		StringBuilder sb = new StringBuilder();
		for (FieldError error : fieldErrors) {
			sb.append(error.getField()).append(": ").append(error.getDefaultMessage()).append("; ");
		}
		log.error("参数校验失败: {}", sb);
		return Result.error(400, sb.toString());
	}

	/**
	 * 处理绑定异常
	 */
	@ExceptionHandler(BindException.class)
	public Result<Void> handleBindException(BindException e) {
		List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
		StringBuilder sb = new StringBuilder();
		for (FieldError error : fieldErrors) {
			sb.append(error.getField()).append(": ").append(error.getDefaultMessage()).append("; ");
		}
		log.error("参数绑定失败: {}", sb);
		return Result.error(400, sb.toString());
	}

	/**
	 * 处理认证异常
	 */
	@ExceptionHandler(AuthenticationException.class)
	public Result<Void> handleAuthenticationException(AuthenticationException e) {
		log.error("认证失败: {}", e.getMessage());
		return Result.unauthorized();
	}

	/**
	 * 处理授权异常
	 */
	@ExceptionHandler(AccessDeniedException.class)
	public Result<Void> handleAccessDeniedException(AccessDeniedException e) {
		log.error("权限不足: {}", e.getMessage());
		return Result.forbidden();
	}

	/**
	 * 处理其他异常
	 */
	@ExceptionHandler(Exception.class)
	public Result<Void> handleException(Exception e, HttpServletRequest request) {
		log.error("系统异常: {} - {}", request.getRequestURI(), e.getMessage(), e);
		return Result.error("系统内部错误，请稍后再试");
	}

}
