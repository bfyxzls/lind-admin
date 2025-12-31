package com.lind.lindadmin.service.impl;

import com.lind.lindadmin.common.BusinessException;
import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.User;
import com.lind.lindadmin.entity.UserRole;
import com.lind.lindadmin.repository.UserRepository;
import com.lind.lindadmin.repository.UserRoleRepository;
import com.lind.lindadmin.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户服务实现类
 */
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
                .filter(u -> u.getDeleted() == 0)
                .orElseThrow(() -> new BusinessException("用户不存在"));
    }

    @Override
    public PageResult<User> findPage(String username, String nickname, Integer status, Integer pageNum, Integer pageSize) {
        Pageable pageable = PageRequest.of(pageNum - 1, pageSize);
        Page<User> page = userRepository.findByConditions(
                username != null && !username.isEmpty() ? username : null,
                nickname != null && !nickname.isEmpty() ? nickname : null,
                status,
                pageable
        );
        return PageResult.of(page);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findByDeleted(0, Pageable.unpaged()).getContent();
    }

    @Override
    @Transactional
    public User save(User user) {
        // 检查用户名是否存在
        if (userRepository.existsByUsernameAndDeleted(user.getUsername(), 0)) {
            throw new BusinessException("用户名已存在");
        }
        // 加密密码
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setDeleted(0);
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public User update(User user) {
        User existingUser = findById(user.getId());
        
        // 更新基本信息
        existingUser.setNickname(user.getNickname());
        existingUser.setEmail(user.getEmail());
        existingUser.setPhone(user.getPhone());
        existingUser.setAvatar(user.getAvatar());
        existingUser.setGender(user.getGender());
        existingUser.setStatus(user.getStatus());
        existingUser.setRemark(user.getRemark());
        
        return userRepository.save(existingUser);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        User user = findById(id);
        if ("admin".equals(user.getUsername())) {
            throw new BusinessException("不能删除管理员账户");
        }
        user.setDeleted(1);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void deleteBatch(List<Long> ids) {
        ids.forEach(this::delete);
    }

    @Override
    @Transactional
    public void changePassword(Long id, String oldPassword, String newPassword) {
        User user = findById(id);
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new BusinessException("原密码不正确");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void resetPassword(Long id, String newPassword) {
        User user = findById(id);
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void assignRoles(Long userId, List<Long> roleIds) {
        // 先删除原有角色
        userRoleRepository.deleteByUserId(userId);
        // 添加新角色
        for (Long roleId : roleIds) {
            UserRole userRole = new UserRole();
            userRole.setUserId(userId);
            userRole.setRoleId(roleId);
            userRoleRepository.save(userRole);
        }
    }

    @Override
    @Transactional
    public void updateLoginInfo(Long userId, String ip) {
        User user = findById(userId);
        user.setLoginIp(ip);
        user.setLoginTime(LocalDateTime.now());
        userRepository.save(user);
    }
}

