package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.DictType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 数据字典类型Repository
 */
@Repository
public interface DictTypeRepository extends JpaRepository<DictType, Long> {

	/**
	 * 根据字典类型查找
	 */
	Optional<DictType> findByDictTypeAndDeleted(String dictType, Integer deleted);

	/**
	 * 检查字典类型是否存在
	 */
	boolean existsByDictTypeAndDeleted(String dictType, Integer deleted);

	/**
	 * 查询所有未删除的字典类型
	 */
	List<DictType> findByDeletedOrderByIdAsc(Integer deleted);

	/**
	 * 分页查询字典类型
	 */
	@Query("SELECT d FROM DictType d WHERE d.deleted = 0 " + "AND (:dictName IS NULL OR d.dictName LIKE %:dictName%) "
			+ "AND (:dictType IS NULL OR d.dictType LIKE %:dictType%) " + "AND (:status IS NULL OR d.status = :status)")
	Page<DictType> findByConditions(@Param("dictName") String dictName, @Param("dictType") String dictType,
			@Param("status") Integer status, Pageable pageable);

}
