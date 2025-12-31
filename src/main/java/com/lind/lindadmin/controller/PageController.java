package com.lind.lindadmin.controller;

import com.lind.lindadmin.entity.Menu;
import com.lind.lindadmin.security.SecurityUserDetails;
import com.lind.lindadmin.service.MenuService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 页面控制器
 */
@Controller
@RequiredArgsConstructor
public class PageController {

	private final MenuService menuService;

	/**
	 * 登录页面
	 */
	@GetMapping("/login")
	public String login(@RequestParam(required = false) String error, @RequestParam(required = false) String expired,
			HttpServletRequest request, HttpServletResponse response, Model model) {
		// 强制加载CSRF Token，确保Cookie被设置
		CsrfToken csrfToken = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
		if (csrfToken != null) {
			// 调用getToken()触发延迟加载，确保CSRF Cookie被设置
			csrfToken.getToken();
		}
		if (error != null) {
			model.addAttribute("error", error);
		}
		if (expired != null) {
			model.addAttribute("error", "会话已过期，请重新登录");
		}
		return "login";
	}

	/**
	 * 首页
	 */
	@GetMapping("/")
	public String index(Model model) {
		SecurityUserDetails userDetails = getCurrentUser();
		if (userDetails != null) {
			model.addAttribute("user", userDetails);
			List<Menu> menus = menuService.findTreeByUserId(userDetails.getUserId());
			model.addAttribute("menus", menus);
		}
		return "index";
	}

	/**
	 * Dashboard页面
	 */
	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		return "dashboard";
	}

	/**
	 * 用户管理页面
	 */
	@GetMapping("/system/user")
	public String userPage() {
		return "system/user";
	}

	/**
	 * 角色管理页面
	 */
	@GetMapping("/system/role")
	public String rolePage() {
		return "system/role";
	}

	/**
	 * 菜单管理页面
	 */
	@GetMapping("/system/menu")
	public String menuPage() {
		return "system/menu";
	}

	/**
	 * 字典管理页面
	 */
	@GetMapping("/system/dict")
	public String dictPage() {
		return "system/dict";
	}

	/**
	 * 操作日志页面
	 */
	@GetMapping("/system/log/operation")
	public String operationLogPage() {
		return "system/log/operation";
	}

	/**
	 * 登录日志页面
	 */
	@GetMapping("/system/log/login")
	public String loginLogPage() {
		return "system/log/login";
	}

	/**
	 * 系统日志页面
	 */
	@GetMapping("/system/log/system")
	public String systemLogPage() {
		return "system/log/system";
	}

	/**
	 * 个人中心页面
	 */
	@GetMapping("/profile")
	public String profilePage(Model model) {
		SecurityUserDetails userDetails = getCurrentUser();
		if (userDetails != null) {
			model.addAttribute("user", userDetails);
		}
		return "profile";
	}

	/**
	 * 获取当前登录用户
	 */
	private SecurityUserDetails getCurrentUser() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication != null && authentication.getPrincipal() instanceof SecurityUserDetails) {
			return (SecurityUserDetails) authentication.getPrincipal();
		}
		return null;
	}

}
