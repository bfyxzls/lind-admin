package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.Menu;

import java.util.List;
import java.util.Set;

/**
 * 菜单服务接口
 */
public interface MenuService {

	/**
	 * 根据ID查找菜单
	 */
	Menu findById(Long id);

	/**
	 * 分页查询菜单
	 */
	PageResult<Menu> findPage(String menuName, Integer status, Integer pageNum, Integer pageSize);

	/**
	 * 查询所有菜单
	 */
	List<Menu> findAll();

	/**
	 * 查询树形菜单
	 */
	List<Menu> findTree();

	/**
	 * 根据角色ID集合查询菜单树
	 */
	List<Menu> findTreeByRoleIds(Set<Long> roleIds);

	/**
	 * 根据用户ID查询菜单树
	 */
	List<Menu> findTreeByUserId(Long userId);

	/**
	 * 保存菜单
	 */
	Menu save(Menu menu);

	/**
	 * 更新菜单
	 */
	Menu update(Menu menu);

	/**
	 * 删除菜单（逻辑删除）
	 */
	void delete(Long id);

	/**
	 * 批量删除菜单
	 */
	void deleteBatch(List<Long> ids);

}
