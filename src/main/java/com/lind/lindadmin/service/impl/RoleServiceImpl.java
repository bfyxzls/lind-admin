package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.BusinessException;
import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Role;
import com.lind.lindadmin.entity.RoleMenu;
import com.lind.lindadmin.entity.RolePermission;
import com.lind.lindadmin.entity.UserRole;
import com.lind.lindadmin.repository.*;
import com.lind.lindadmin.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 角色服务实现类
 */
@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final RolePermissionRepository rolePermissionRepository;
    private final RoleMenuRepository roleMenuRepository;

    @Override
    public Role findById(Long id) {
        return roleRepository.findById(id)
                .filter(r -> r.getDeleted() == 0)
                .orElseThrow(() -> new BusinessException("角色不存在"));
    }

    @Override
    public PageResult<Role> findPage(String roleName, String roleCode, Integer status, Integer pageNum, Integer pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<Role> page = roleRepository.findByConditions(
                roleName != null && !roleName.isEmpty() ? roleName : null,
                roleCode != null && !roleCode.isEmpty() ? roleCode : null,
                status,
                pageable
        );
        return PageResult.of(page);
    }

    @Override
    public List<Role> findAll() {
        return roleRepository.findByDeletedOrderBySortOrderAsc(0);
    }

    @Override
    public List<Role> findByUserId(Long userId) {
        List<UserRole> userRoles = userRoleRepository.findByUserId(userId);
        List<Long> roleIds = userRoles.stream().map(UserRole::getRoleId).collect(Collectors.toList());
        return roleRepository.findAllById(roleIds).stream()
                .filter(r -> r.getDeleted() == 0)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Role save(Role role) {
        // 检查角色编码是否存在
        if (roleRepository.existsByRoleCodeAndDeleted(role.getRoleCode(), 0)) {
            throw new BusinessException("角色编码已存在");
        }
        role.setDeleted(0);
        return roleRepository.save(role);
    }

    @Override
    @Transactional
    public Role update(Role role) {
        Role existingRole = findById(role.getId());
        
        existingRole.setRoleName(role.getRoleName());
        existingRole.setSortOrder(role.getSortOrder());
        existingRole.setStatus(role.getStatus());
        existingRole.setRemark(role.getRemark());
        
        return roleRepository.save(existingRole);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Role role = findById(id);
        if ("ROLE_ADMIN".equals(role.getRoleCode())) {
            throw new BusinessException("不能删除管理员角色");
        }
        role.setDeleted(1);
        roleRepository.save(role);
    }

    @Override
    @Transactional
    public void deleteBatch(List<Long> ids) {
        ids.forEach(this::delete);
    }

    @Override
    @Transactional
    public void assignPermissions(Long roleId, List<Long> permissionIds) {
        // 先删除原有权限
        rolePermissionRepository.deleteByRoleId(roleId);
        // 添加新权限
        for (Long permissionId : permissionIds) {
            RolePermission rolePermission = new RolePermission();
            rolePermission.setRoleId(roleId);
            rolePermission.setPermissionId(permissionId);
            rolePermissionRepository.save(rolePermission);
        }
    }

    @Override
    @Transactional
    public void assignMenus(Long roleId, List<Long> menuIds) {
        // 先删除原有菜单
        roleMenuRepository.deleteByRoleId(roleId);
        // 添加新菜单
        for (Long menuId : menuIds) {
            RoleMenu roleMenu = new RoleMenu();
            roleMenu.setRoleId(roleId);
            roleMenu.setMenuId(menuId);
            roleMenuRepository.save(roleMenu);
        }
    }
}

