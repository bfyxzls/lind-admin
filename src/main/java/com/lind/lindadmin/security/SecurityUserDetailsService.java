package com.lind.lindadmin.security;

import com.lind.lindadmin.entity.Permission;
import com.lind.lindadmin.entity.Role;
import com.lind.lindadmin.entity.User;
import com.lind.lindadmin.repository.UserRepository;
import com.lind.lindadmin.service.PermissionService;
import com.lind.lindadmin.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Security用户详情服务
 */
@Service
@RequiredArgsConstructor
public class SecurityUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;
    private final RoleService roleService;
    private final PermissionService permissionService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("用户不存在: " + username));

        // 获取用户角色
        List<Role> roles = roleService.findByUserId(user.getId());
        Set<Long> roleIds = roles.stream().map(Role::getId).collect(Collectors.toSet());

        // 获取角色权限
        Set<Permission> permissions = permissionService.findByRoleIds(roleIds);

        // 构建权限集合
        Set<String> permissionCodes = new HashSet<>();
        // 添加角色编码
        roles.forEach(role -> permissionCodes.add(role.getRoleCode()));
        // 添加权限编码
        permissions.forEach(permission -> permissionCodes.add(permission.getPermissionCode()));

        return new SecurityUserDetails(user, permissionCodes);
    }
}

