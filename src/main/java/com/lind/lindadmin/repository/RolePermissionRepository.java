package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.RolePermission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 角色权限关联Repository
 */
@Repository
public interface RolePermissionRepository extends JpaRepository<RolePermission, Long> {

    /**
     * 根据角色ID查询
     */
    List<RolePermission> findByRoleId(Long roleId);

    /**
     * 根据权限ID查询
     */
    List<RolePermission> findByPermissionId(Long permissionId);

    /**
     * 根据角色ID删除
     */
    void deleteByRoleId(Long roleId);

    /**
     * 根据权限ID删除
     */
    void deleteByPermissionId(Long permissionId);
}

