package com.lind.lindadmin.repository;

import com.lind.lindadmin.entity.DictData;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 数据字典数据Repository
 */
@Repository
public interface DictDataRepository extends JpaRepository<DictData, Long> {

    /**
     * 根据字典类型查询字典数据
     */
    List<DictData> findByDictTypeAndDeletedOrderBySortOrderAsc(String dictType, Integer deleted);

    /**
     * 分页查询字典数据
     */
    @Query("SELECT d FROM DictData d WHERE d.deleted = 0 " +
            "AND (:dictType IS NULL OR d.dictType = :dictType) " +
            "AND (:dictLabel IS NULL OR d.dictLabel LIKE %:dictLabel%) " +
            "AND (:status IS NULL OR d.status = :status) " +
            "ORDER BY d.sortOrder ASC")
    Page<DictData> findByConditions(
            @Param("dictType") String dictType,
            @Param("dictLabel") String dictLabel,
            @Param("status") Integer status,
            Pageable pageable
    );

    /**
     * 根据字典类型删除数据
     */
    void deleteByDictType(String dictType);
}

