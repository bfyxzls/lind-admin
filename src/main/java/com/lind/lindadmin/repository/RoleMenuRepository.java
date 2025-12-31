package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.RoleMenu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 角色菜单关联Repository
 */
@Repository
public interface RoleMenuRepository extends JpaRepository<RoleMenu, Long> {

	/**
	 * 根据角色ID查询
	 */
	List<RoleMenu> findByRoleId(Long roleId);

	/**
	 * 根据菜单ID查询
	 */
	List<RoleMenu> findByMenuId(Long menuId);

	/**
	 * 根据角色ID删除
	 */
	void deleteByRoleId(Long roleId);

	/**
	 * 根据菜单ID删除
	 */
	void deleteByMenuId(Long menuId);

}
