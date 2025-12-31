package com.lind.lindadmin.controller;

import com.lind.lindadmin.common.PageResult;
import com.lind.lindadmin.common.Result;
import com.lind.lindadmin.entity.DictData;
import com.lind.lindadmin.entity.DictType;
import com.lind.lindadmin.service.DictService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 数据字典Controller
 */
@RestController
@RequestMapping("/api/dict")
@RequiredArgsConstructor
public class DictController {

	private final DictService dictService;

	// ==================== 字典类型 ====================

	/**
	 * 分页查询字典类型
	 */
	@GetMapping("/type/page")
	@PreAuthorize("hasAuthority('system:dict:list')")
	public Result<PageResult<DictType>> typePage(@RequestParam(required = false) String dictName,
			@RequestParam(required = false) String dictType, @RequestParam(required = false) Integer status,
			@RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
		return Result.success(dictService.findTypePage(dictName, dictType, status, pageNum, pageSize));
	}

	/**
	 * 查询所有字典类型
	 */
	@GetMapping("/type/list")
	@PreAuthorize("hasAuthority('system:dict:list')")
	public Result<List<DictType>> typeList() {
		return Result.success(dictService.findAllTypes());
	}

	/**
	 * 根据ID查询字典类型
	 */
	@GetMapping("/type/{id}")
	@PreAuthorize("hasAuthority('system:dict:list')")
	public Result<DictType> getType(@PathVariable Long id) {
		return Result.success(dictService.findTypeById(id));
	}

	/**
	 * 新增字典类型
	 */
	@PostMapping("/type")
	@PreAuthorize("hasAuthority('system:dict:add')")
	public Result<DictType> saveType(@RequestBody DictType dictType) {
		return Result.success(dictService.saveType(dictType));
	}

	/**
	 * 更新字典类型
	 */
	@PutMapping("/type")
	@PreAuthorize("hasAuthority('system:dict:edit')")
	public Result<DictType> updateType(@RequestBody DictType dictType) {
		return Result.success(dictService.updateType(dictType));
	}

	/**
	 * 删除字典类型
	 */
	@DeleteMapping("/type/{id}")
	@PreAuthorize("hasAuthority('system:dict:delete')")
	public Result<Void> deleteType(@PathVariable Long id) {
		dictService.deleteType(id);
		return Result.success();
	}

	// ==================== 字典数据 ====================

	/**
	 * 分页查询字典数据
	 */
	@GetMapping("/data/page")
	@PreAuthorize("hasAuthority('system:dict:list')")
	public Result<PageResult<DictData>> dataPage(@RequestParam(required = false) String dictType,
			@RequestParam(required = false) String dictLabel, @RequestParam(required = false) Integer status,
			@RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
		return Result.success(dictService.findDataPage(dictType, dictLabel, status, pageNum, pageSize));
	}

	/**
	 * 根据字典类型查询字典数据
	 */
	@GetMapping("/data/type/{dictType}")
	public Result<List<DictData>> dataByType(@PathVariable String dictType) {
		return Result.success(dictService.findDataByType(dictType));
	}

	/**
	 * 根据ID查询字典数据
	 */
	@GetMapping("/data/{id}")
	@PreAuthorize("hasAuthority('system:dict:list')")
	public Result<DictData> getData(@PathVariable Long id) {
		return Result.success(dictService.findDataById(id));
	}

	/**
	 * 新增字典数据
	 */
	@PostMapping("/data")
	@PreAuthorize("hasAuthority('system:dict:add')")
	public Result<DictData> saveData(@RequestBody DictData dictData) {
		return Result.success(dictService.saveData(dictData));
	}

	/**
	 * 更新字典数据
	 */
	@PutMapping("/data")
	@PreAuthorize("hasAuthority('system:dict:edit')")
	public Result<DictData> updateData(@RequestBody DictData dictData) {
		return Result.success(dictService.updateData(dictData));
	}

	/**
	 * 删除字典数据
	 */
	@DeleteMapping("/data/{id}")
	@PreAuthorize("hasAuthority('system:dict:delete')")
	public Result<Void> deleteData(@PathVariable Long id) {
		dictService.deleteData(id);
		return Result.success();
	}

	/**
	 * 批量删除字典数据
	 */
	@DeleteMapping("/data/batch")
	@PreAuthorize("hasAuthority('system:dict:delete')")
	public Result<Void> deleteDataBatch(@RequestBody List<Long> ids) {
		dictService.deleteDataBatch(ids);
		return Result.success();
	}

}
