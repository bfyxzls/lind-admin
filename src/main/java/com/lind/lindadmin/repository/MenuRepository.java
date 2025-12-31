package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.Menu;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

/**
 * 菜单Repository
 */
@Repository
public interface MenuRepository extends JpaRepository<Menu, Long> {

	/**
	 * 查询所有未删除的菜单
	 */
	List<Menu> findByDeletedOrderBySortOrderAsc(Integer deleted);

	/**
	 * 根据父ID查询菜单
	 */
	List<Menu> findByParentIdAndDeletedOrderBySortOrderAsc(Long parentId, Integer deleted);

	/**
	 * 根据菜单类型查询
	 */
	List<Menu> findByMenuTypeAndDeletedOrderBySortOrderAsc(Integer menuType, Integer deleted);

	/**
	 * 分页查询菜单
	 */
	@Query("SELECT m FROM Menu m WHERE m.deleted = 0 " + "AND (:menuName IS NULL OR m.menuName LIKE %:menuName%) "
			+ "AND (:status IS NULL OR m.status = :status) " + "ORDER BY m.sortOrder ASC")
	Page<Menu> findByConditions(@Param("menuName") String menuName, @Param("status") Integer status, Pageable pageable);

	/**
	 * 根据角色ID集合查询菜单
	 */
	@Query("SELECT DISTINCT m FROM Menu m JOIN RoleMenu rm ON rm.menuId = m.id WHERE rm.roleId IN :roleIds AND m.deleted = 0 AND m.status = 1 AND m.visible = 1 ORDER BY m.sortOrder ASC")
	List<Menu> findByRoleIds(@Param("roleIds") Set<Long> roleIds);

	/**
	 * 根据角色ID集合查询所有菜单（包括按钮）
	 */
	@Query("SELECT DISTINCT m FROM Menu m JOIN RoleMenu rm ON rm.menuId = m.id WHERE rm.roleId IN :roleIds AND m.deleted = 0 AND m.status = 1 ORDER BY m.sortOrder ASC")
	List<Menu> findAllByRoleIds(@Param("roleIds") Set<Long> roleIds);

}
