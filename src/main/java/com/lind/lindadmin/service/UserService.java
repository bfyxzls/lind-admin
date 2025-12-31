package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.User;

import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 根据用户名查找用户
     */
    User findByUsername(String username);

    /**
     * 根据ID查找用户
     */
    User findById(Long id);

    /**
     * 分页查询用户
     */
    PageResult<User> findPage(String username, String nickname, Integer status, Integer pageNum, Integer pageSize);

    /**
     * 查询所有用户
     */
    List<User> findAll();

    /**
     * 保存用户
     */
    User save(User user);

    /**
     * 更新用户
     */
    User update(User user);

    /**
     * 删除用户（逻辑删除）
     */
    void delete(Long id);

    /**
     * 批量删除用户
     */
    void deleteBatch(List<Long> ids);

    /**
     * 修改密码
     */
    void changePassword(Long id, String oldPassword, String newPassword);

    /**
     * 重置密码
     */
    void resetPassword(Long id, String newPassword);

    /**
     * 分配角色
     */
    void assignRoles(Long userId, List<Long> roleIds);

    /**
     * 更新登录信息
     */
    void updateLoginInfo(Long userId, String ip);
}

