package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Permission;

import java.util.List;
import java.util.Set;

/**
 * 权限服务接口
 */
public interface PermissionService {

    /**
     * 根据ID查找权限
     */
    Permission findById(Long id);

    /**
     * 分页查询权限
     */
    PageResult<Permission> findPage(String permissionName, String permissionCode, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 查询所有权限
     */
    List<Permission> findAll();

    /**
     * 根据角色ID集合查询权限
     */
    Set<Permission> findByRoleIds(Set<Long> roleIds);

    /**
     * 查询树形权限
     */
    List<Permission> findTree();

    /**
     * 保存权限
     */
    Permission save(Permission permission);

    /**
     * 更新权限
     */
    Permission update(Permission permission);

    /**
     * 删除权限（逻辑删除）
     */
    void delete(Long id);

    /**
     * 批量删除权限
     */
    void deleteBatch(List<Long> ids);
}

