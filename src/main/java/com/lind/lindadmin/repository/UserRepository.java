package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 用户Repository
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

	/**
	 * 根据用户名查找用户
	 */
	Optional<User> findByUsernameAndDeleted(String username, Integer deleted);

	/**
	 * 根据用户名查找用户
	 */
	default Optional<User> findByUsername(String username) {
		return findByUsernameAndDeleted(username, 0);
	}

	/**
	 * 检查用户名是否存在
	 */
	boolean existsByUsernameAndDeleted(String username, Integer deleted);

	/**
	 * 检查手机号是否存在
	 */
	boolean existsByPhoneAndDeleted(String phone, Integer deleted);

	/**
	 * 检查邮箱是否存在
	 */
	boolean existsByEmailAndDeleted(String email, Integer deleted);

	/**
	 * 分页查询用户
	 */
	@Query("SELECT u FROM User u WHERE u.deleted = 0 " + "AND (:username IS NULL OR u.username LIKE %:username%) "
			+ "AND (:nickname IS NULL OR u.nickname LIKE %:nickname%) " + "AND (:status IS NULL OR u.status = :status)")
	Page<User> findByConditions(@Param("username") String username, @Param("nickname") String nickname,
			@Param("status") Integer status, Pageable pageable);

	/**
	 * 查询所有未删除的用户
	 */
	Page<User> findByDeleted(Integer deleted, Pageable pageable);

}
