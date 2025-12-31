package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.Permission;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * 权限Repository
 */
@Repository
public interface PermissionRepository extends JpaRepository<Permission, Long> {

    /**
     * 根据权限编码查找权限
     */
    Optional<Permission> findByPermissionCodeAndDeleted(String permissionCode, Integer deleted);

    /**
     * 检查权限编码是否存在
     */
    boolean existsByPermissionCodeAndDeleted(String permissionCode, Integer deleted);

    /**
     * 查询所有未删除的权限
     */
    List<Permission> findByDeletedOrderBySortOrderAsc(Integer deleted);

    /**
     * 根据父ID查询权限
     */
    List<Permission> findByParentIdAndDeletedOrderBySortOrderAsc(Long parentId, Integer deleted);

    /**
     * 分页查询权限
     */
    @Query("SELECT p FROM Permission p WHERE p.deleted = 0 " +
            "AND (:permissionName IS NULL OR p.permissionName LIKE %:permissionName%) " +
            "AND (:permissionCode IS NULL OR p.permissionCode LIKE %:permissionCode%) " +
            "AND (:status IS NULL OR p.status = :status) " +
            "ORDER BY p.sortOrder ASC")
    Page<Permission> findByConditions(
            @Param("permissionName") String permissionName,
            @Param("permissionCode") String permissionCode,
            @Param("status") Integer status,
            Pageable pageable
    );

    /**
     * 根据角色ID集合查询权限
     */
    @Query("SELECT DISTINCT p FROM Permission p JOIN RolePermission rp ON rp.permissionId = p.id WHERE rp.roleId IN :roleIds AND p.deleted = 0 AND p.status = 1")
    Set<Permission> findByRoleIds(@Param("roleIds") Set<Long> roleIds);
}

