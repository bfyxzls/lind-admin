package com.lind.lindadmin.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.LoginLog;
import com.lind.lindadmin.service.LogService;
import com.lind.lindadmin.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 登录成功处理器
 */
@Component
@RequiredArgsConstructor
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final ObjectMapper objectMapper;
    private final LogService logService;
    private final UserService userService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        SecurityUserDetails userDetails = (SecurityUserDetails) authentication.getPrincipal();
        
        // 更新登录信息
        String ip = getClientIp(request);
        userService.updateLoginInfo(userDetails.getUserId(), ip);

        // 记录登录日志
        LoginLog loginLog = new LoginLog();
        loginLog.setUsername(userDetails.getUsername());
        loginLog.setUserId(userDetails.getUserId());
        loginLog.setLoginIp(ip);
        loginLog.setBrowser(request.getHeader("User-Agent"));
        loginLog.setStatus(1);
        loginLog.setMsg("登录成功");
        logService.saveLoginLog(loginLog);

        // 判断是否是AJAX请求
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> data = new HashMap<>();
            data.put("userId", userDetails.getUserId());
            data.put("username", userDetails.getUsername());
            data.put("nickname", userDetails.getNickname());
            response.getWriter().write(objectMapper.writeValueAsString(Result.success(data)));
        } else {
            // 页面请求，重定向到首页
            response.sendRedirect("/");
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

