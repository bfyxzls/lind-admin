package com.lind.lindadmin.common;

import lombok.Data;
import org.springframework.data.domain.Page;

import java.io.Serializable;
import java.util.List;

/**
 * 分页结果
 */
@Data
public class PageResult<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	/**
	 * 数据列表
	 */
	private List<T> records;

	/**
	 * 总记录数
	 */
	private Long total;

	/**
	 * 当前页
	 */
	private Integer pageNum;

	/**
	 * 每页大小
	 */
	private Integer pageSize;

	/**
	 * 总页数
	 */
	private Integer pages;

	public PageResult() {
	}

	public PageResult(List<T> records, Long total, Integer pageNum, Integer pageSize) {
		this.records = records;
		this.total = total;
		this.pageNum = pageNum;
		this.pageSize = pageSize;
		this.pages = (int) Math.ceil((double) total / pageSize);
	}

	public static <T> PageResult<T> of(Page<T> page) {
		PageResult<T> result = new PageResult<>();
		result.setRecords(page.getContent());
		result.setTotal(page.getTotalElements());
		result.setPageNum(page.getNumber() + 1);
		result.setPageSize(page.getSize());
		result.setPages(page.getTotalPages());
		return result;
	}

	public static <T> PageResult<T> of(List<T> records, Long total, Integer pageNum, Integer pageSize) {
		return new PageResult<>(records, total, pageNum, pageSize);
	}

}
