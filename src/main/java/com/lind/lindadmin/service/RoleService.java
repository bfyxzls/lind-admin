package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Role;

import java.util.List;

/**
 * 角色服务接口
 */
public interface RoleService {

    /**
     * 根据ID查找角色
     */
    Role findById(Long id);

    /**
     * 分页查询角色
     */
    PageResult<Role> findPage(String roleName, String roleCode, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 查询所有角色
     */
    List<Role> findAll();

    /**
     * 根据用户ID查询角色
     */
    List<Role> findByUserId(Long userId);

    /**
     * 保存角色
     */
    Role save(Role role);

    /**
     * 更新角色
     */
    Role update(Role role);

    /**
     * 删除角色（逻辑删除）
     */
    void delete(Long id);

    /**
     * 批量删除角色
     */
    void deleteBatch(List<Long> ids);

    /**
     * 分配权限
     */
    void assignPermissions(Long roleId, List<Long> permissionIds);

    /**
     * 分配菜单
     */
    void assignMenus(Long roleId, List<Long> menuIds);
}

