package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.User;
import com.lind.lindadmin.security.SecurityUserDetails;
import com.lind.lindadmin.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 个人中心Controller
 */
@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class ProfileController {

	private final UserService userService;

	/**
	 * 获取当前用户信息
	 */
	@GetMapping
	public Result<User> getCurrentUser() {
		SecurityUserDetails userDetails = getCurrentUserDetails();
		if (userDetails == null) {
			return Result.unauthorized();
		}
		User user = userService.findById(userDetails.getUserId());
		user.setPassword(null); // 不返回密码
		return Result.success(user);
	}

	/**
	 * 更新个人信息
	 */
	@PutMapping
	public Result<User> updateProfile(@RequestBody User user) {
		SecurityUserDetails userDetails = getCurrentUserDetails();
		if (userDetails == null) {
			return Result.unauthorized();
		}
		user.setId(userDetails.getUserId());
		return Result.success(userService.update(user));
	}

	/**
	 * 修改密码
	 */
	@PutMapping("/password")
	public Result<Void> changePassword(@RequestBody Map<String, String> params) {
		SecurityUserDetails userDetails = getCurrentUserDetails();
		if (userDetails == null) {
			return Result.unauthorized();
		}
		String oldPassword = params.get("oldPassword");
		String newPassword = params.get("newPassword");
		userService.changePassword(userDetails.getUserId(), oldPassword, newPassword);
		return Result.success();
	}

	/**
	 * 获取当前登录用户
	 */
	private SecurityUserDetails getCurrentUserDetails() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication != null && authentication.getPrincipal() instanceof SecurityUserDetails) {
			return (SecurityUserDetails) authentication.getPrincipal();
		}
		return null;
	}

}
