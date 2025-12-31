package com.lind.lindadmin.service;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.entity.DictData;
import com.lind.lindadmin.entity.DictType;

import java.util.List;

/**
 * 数据字典服务接口
 */
public interface DictService {

	// ==================== 字典类型 ====================

	/**
	 * 根据ID查找字典类型
	 */
	DictType findTypeById(Long id);

	/**
	 * 根据字典类型编码查找
	 */
	DictType findTypeByCode(String dictType);

	/**
	 * 分页查询字典类型
	 */
	PageResult<DictType> findTypePage(String dictName, String dictType, Integer status, Integer pageNum,
			Integer pageSize);

	/**
	 * 查询所有字典类型
	 */
	List<DictType> findAllTypes();

	/**
	 * 保存字典类型
	 */
	DictType saveType(DictType dictType);

	/**
	 * 更新字典类型
	 */
	DictType updateType(DictType dictType);

	/**
	 * 删除字典类型（逻辑删除）
	 */
	void deleteType(Long id);

	// ==================== 字典数据 ====================

	/**
	 * 根据ID查找字典数据
	 */
	DictData findDataById(Long id);

	/**
	 * 根据字典类型查询字典数据
	 */
	List<DictData> findDataByType(String dictType);

	/**
	 * 分页查询字典数据
	 */
	PageResult<DictData> findDataPage(String dictType, String dictLabel, Integer status, Integer pageNum,
			Integer pageSize);

	/**
	 * 保存字典数据
	 */
	DictData saveData(DictData dictData);

	/**
	 * 更新字典数据
	 */
	DictData updateData(DictData dictData);

	/**
	 * 删除字典数据（逻辑删除）
	 */
	void deleteData(Long id);

	/**
	 * 批量删除字典数据
	 */
	void deleteDataBatch(List<Long> ids);

}
