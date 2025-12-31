package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.BusinessException;
import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Permission;
import com.lind.lindadmin.repository.PermissionRepository;
import com.lind.lindadmin.repository.RolePermissionRepository;
import com.lind.lindadmin.service.PermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * 权限服务实现类
 */
@Service
@RequiredArgsConstructor
public class PermissionServiceImpl implements PermissionService {

    private final PermissionRepository permissionRepository;
    private final RolePermissionRepository rolePermissionRepository;

    @Override
    public Permission findById(Long id) {
        return permissionRepository.findById(id)
                .filter(p -> p.getDeleted() == 0)
                .orElseThrow(() -> new BusinessException("权限不存在"));
    }

    @Override
    public PageResult<Permission> findPage(String permissionName, String permissionCode, Integer status, Integer pageNum, Integer pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<Permission> page = permissionRepository.findByConditions(
                permissionName != null && !permissionName.isEmpty() ? permissionName : null,
                permissionCode != null && !permissionCode.isEmpty() ? permissionCode : null,
                status,
                pageable
        );
        return PageResult.of(page);
    }

    @Override
    public List<Permission> findAll() {
        return permissionRepository.findByDeletedOrderBySortOrderAsc(0);
    }

    @Override
    public Set<Permission> findByRoleIds(Set<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return Set.of();
        }
        return permissionRepository.findByRoleIds(roleIds);
    }

    @Override
    public List<Permission> findTree() {
        List<Permission> allPermissions = findAll();
        return buildTree(allPermissions, 0L);
    }

    private List<Permission> buildTree(List<Permission> permissions, Long parentId) {
        List<Permission> tree = new ArrayList<>();
        for (Permission permission : permissions) {
            if (permission.getParentId().equals(parentId)) {
                tree.add(permission);
            }
        }
        return tree;
    }

    @Override
    @Transactional
    public Permission save(Permission permission) {
        // 检查权限编码是否存在
        if (permissionRepository.existsByPermissionCodeAndDeleted(permission.getPermissionCode(), 0)) {
            throw new BusinessException("权限编码已存在");
        }
        permission.setDeleted(0);
        return permissionRepository.save(permission);
    }

    @Override
    @Transactional
    public Permission update(Permission permission) {
        Permission existingPermission = findById(permission.getId());
        
        existingPermission.setPermissionName(permission.getPermissionName());
        existingPermission.setPermissionType(permission.getPermissionType());
        existingPermission.setParentId(permission.getParentId());
        existingPermission.setSortOrder(permission.getSortOrder());
        existingPermission.setStatus(permission.getStatus());
        existingPermission.setRemark(permission.getRemark());
        
        return permissionRepository.save(existingPermission);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Permission permission = findById(id);
        // 检查是否有子权限
        List<Permission> children = permissionRepository.findByParentIdAndDeletedOrderBySortOrderAsc(id, 0);
        if (!children.isEmpty()) {
            throw new BusinessException("存在子权限，无法删除");
        }
        permission.setDeleted(1);
        permissionRepository.save(permission);
        // 删除角色权限关联
        rolePermissionRepository.deleteByPermissionId(id);
    }

    @Override
    @Transactional
    public void deleteBatch(List<Long> ids) {
        ids.forEach(this::delete);
    }
}

