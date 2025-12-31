package com.lind.lindadmin.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.LoginLog;
import com.lind.lindadmin.service.LogService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 登录失败处理器
 */
@Component
@RequiredArgsConstructor
public class LoginFailureHandler implements AuthenticationFailureHandler {

	private final ObjectMapper objectMapper;

	private final LogService logService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		String message = getErrorMessage(exception);
		String username = request.getParameter("username");

		// 记录登录日志
		LoginLog loginLog = new LoginLog();
		loginLog.setUsername(username);
		loginLog.setLoginIp(getClientIp(request));
		loginLog.setBrowser(request.getHeader("User-Agent"));
		loginLog.setStatus(0);
		loginLog.setMsg(message);
		logService.saveLoginLog(loginLog);

		// 判断是否是AJAX请求
		String requestedWith = request.getHeader("X-Requested-With");
		if ("XMLHttpRequest".equals(requestedWith)) {
			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().write(objectMapper.writeValueAsString(Result.error(401, message)));
		}
		else {
			// 页面请求，重定向到登录页并带上错误信息
			response.sendRedirect("/login?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
		}
	}

	private String getErrorMessage(AuthenticationException exception) {
		if (exception instanceof BadCredentialsException) {
			return "用户名或密码错误";
		}
		else if (exception instanceof DisabledException) {
			return "账户已被禁用";
		}
		else if (exception instanceof LockedException) {
			return "账户已被锁定";
		}
		else if (exception instanceof AccountExpiredException) {
			return "账户已过期";
		}
		else if (exception instanceof CredentialsExpiredException) {
			return "密码已过期";
		}
		else {
			return "登录失败";
		}
	}

	private String getClientIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

}
