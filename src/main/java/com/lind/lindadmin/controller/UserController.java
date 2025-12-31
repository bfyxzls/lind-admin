package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.Role;
import com.lind.lindadmin.entity.User;
import com.lind.lindadmin.service.RoleService;
import com.lind.lindadmin.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 用户管理Controller
 */
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final RoleService roleService;

    /**
     * 分页查询用户
     */
    @GetMapping("/page")
    @PreAuthorize("hasAuthority('system:user:list')")
    public Result<PageResult<User>> page(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String nickname,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(userService.findPage(username, nickname, status, pageNum, pageSize));
    }

    /**
     * 查询所有用户
     */
    @GetMapping("/list")
    @PreAuthorize("hasAuthority('system:user:list')")
    public Result<List<User>> list() {
        return Result.success(userService.findAll());
    }

    /**
     * 根据ID查询用户
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('system:user:list')")
    public Result<User> get(@PathVariable Long id) {
        return Result.success(userService.findById(id));
    }

    /**
     * 新增用户
     */
    @PostMapping
    @PreAuthorize("hasAuthority('system:user:add')")
    public Result<User> save(@RequestBody User user) {
        return Result.success(userService.save(user));
    }

    /**
     * 更新用户
     */
    @PutMapping
    @PreAuthorize("hasAuthority('system:user:edit')")
    public Result<User> update(@RequestBody User user) {
        return Result.success(userService.update(user));
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('system:user:delete')")
    public Result<Void> delete(@PathVariable Long id) {
        userService.delete(id);
        return Result.success();
    }

    /**
     * 批量删除用户
     */
    @DeleteMapping("/batch")
    @PreAuthorize("hasAuthority('system:user:delete')")
    public Result<Void> deleteBatch(@RequestBody List<Long> ids) {
        userService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 重置密码
     */
    @PutMapping("/{id}/resetPassword")
    @PreAuthorize("hasAuthority('system:user:edit')")
    public Result<Void> resetPassword(@PathVariable Long id, @RequestBody Map<String, String> params) {
        userService.resetPassword(id, params.get("password"));
        return Result.success();
    }

    /**
     * 获取用户角色
     */
    @GetMapping("/{id}/roles")
    @PreAuthorize("hasAuthority('system:user:list')")
    public Result<List<Role>> getUserRoles(@PathVariable Long id) {
        return Result.success(roleService.findByUserId(id));
    }

    /**
     * 分配角色
     */
    @PutMapping("/{id}/roles")
    @PreAuthorize("hasAuthority('system:user:edit')")
    public Result<Void> assignRoles(@PathVariable Long id, @RequestBody List<Long> roleIds) {
        userService.assignRoles(id, roleIds);
        return Result.success();
    }
}

