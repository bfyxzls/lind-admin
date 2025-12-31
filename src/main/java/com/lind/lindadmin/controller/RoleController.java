package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.Role;
import com.lind.lindadmin.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 角色管理Controller
 */
@RestController
@RequestMapping("/api/role")
@RequiredArgsConstructor
public class RoleController {

    private final RoleService roleService;

    /**
     * 分页查询角色
     */
    @GetMapping("/page")
    @PreAuthorize("hasAuthority('system:role:list')")
    public Result<PageResult<Role>> page(
            @RequestParam(required = false) String roleName,
            @RequestParam(required = false) String roleCode,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(roleService.findPage(roleName, roleCode, status, pageNum, pageSize));
    }

    /**
     * 查询所有角色
     */
    @GetMapping("/list")
    @PreAuthorize("hasAuthority('system:role:list')")
    public Result<List<Role>> list() {
        return Result.success(roleService.findAll());
    }

    /**
     * 根据ID查询角色
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('system:role:list')")
    public Result<Role> get(@PathVariable Long id) {
        return Result.success(roleService.findById(id));
    }

    /**
     * 新增角色
     */
    @PostMapping
    @PreAuthorize("hasAuthority('system:role:add')")
    public Result<Role> save(@RequestBody Role role) {
        return Result.success(roleService.save(role));
    }

    /**
     * 更新角色
     */
    @PutMapping
    @PreAuthorize("hasAuthority('system:role:edit')")
    public Result<Role> update(@RequestBody Role role) {
        return Result.success(roleService.update(role));
    }

    /**
     * 删除角色
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('system:role:delete')")
    public Result<Void> delete(@PathVariable Long id) {
        roleService.delete(id);
        return Result.success();
    }

    /**
     * 批量删除角色
     */
    @DeleteMapping("/batch")
    @PreAuthorize("hasAuthority('system:role:delete')")
    public Result<Void> deleteBatch(@RequestBody List<Long> ids) {
        roleService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 分配权限
     */
    @PutMapping("/{id}/permissions")
    @PreAuthorize("hasAuthority('system:role:edit')")
    public Result<Void> assignPermissions(@PathVariable Long id, @RequestBody List<Long> permissionIds) {
        roleService.assignPermissions(id, permissionIds);
        return Result.success();
    }

    /**
     * 分配菜单
     */
    @PutMapping("/{id}/menus")
    @PreAuthorize("hasAuthority('system:role:edit')")
    public Result<Void> assignMenus(@PathVariable Long id, @RequestBody List<Long> menuIds) {
        roleService.assignMenus(id, menuIds);
        return Result.success();
    }
}

