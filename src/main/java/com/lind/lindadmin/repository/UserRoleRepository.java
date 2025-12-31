package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 用户角色关联Repository
 */
@Repository
public interface UserRoleRepository extends JpaRepository<UserRole, Long> {

    /**
     * 根据用户ID查询
     */
    List<UserRole> findByUserId(Long userId);

    /**
     * 根据角色ID查询
     */
    List<UserRole> findByRoleId(Long roleId);

    /**
     * 根据用户ID删除
     */
    void deleteByUserId(Long userId);

    /**
     * 根据角色ID删除
     */
    void deleteByRoleId(Long roleId);
}

