package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.Role;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 角色Repository
 */
@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

	/**
	 * 根据角色编码查找角色
	 */
	Optional<Role> findByRoleCodeAndDeleted(String roleCode, Integer deleted);

	/**
	 * 检查角色编码是否存在
	 */
	boolean existsByRoleCodeAndDeleted(String roleCode, Integer deleted);

	/**
	 * 查询所有未删除的角色
	 */
	List<Role> findByDeletedOrderBySortOrderAsc(Integer deleted);

	/**
	 * 分页查询角色
	 */
	@Query("SELECT r FROM Role r WHERE r.deleted = 0 " + "AND (:roleName IS NULL OR r.roleName LIKE %:roleName%) "
			+ "AND (:roleCode IS NULL OR r.roleCode LIKE %:roleCode%) " + "AND (:status IS NULL OR r.status = :status) "
			+ "ORDER BY r.sortOrder ASC")
	Page<Role> findByConditions(@Param("roleName") String roleName, @Param("roleCode") String roleCode,
			@Param("status") Integer status, Pageable pageable);

	/**
	 * 分页查询未删除的角色
	 */
	Page<Role> findByDeleted(Integer deleted, Pageable pageable);

	/**
	 * 根据用户ID查询角色
	 */
	@Query("SELECT r FROM Role r JOIN r.menus m JOIN UserRole ur ON ur.roleId = r.id WHERE ur.userId = :userId AND r.deleted = 0")
	List<Role> findByUserId(@Param("userId") Long userId);

}
