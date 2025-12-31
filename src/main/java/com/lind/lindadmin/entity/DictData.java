package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 数据字典数据实体类
 */
@Data
@Entity
@Table(name = "dict_data")
@EqualsAndHashCode(callSuper = true)
public class DictData extends BaseEntity {

	@Column(name = "dict_type", nullable = false, length = 100)
	private String dictType;

	@Column(name = "dict_label", nullable = false, length = 100)
	private String dictLabel;

	@Column(name = "dict_value", nullable = false, length = 100)
	private String dictValue;

	@Column(name = "css_class", length = 100)
	private String cssClass;

	@Column(name = "list_class", length = 100)
	private String listClass;

	@Column(name = "sort_order")
	private Integer sortOrder = 0;

	@Column(name = "status")
	private Integer status = 1;

	@Column(name = "is_default")
	private Integer isDefault = 0;

	@Column(name = "remark", length = 500)
	private String remark;

}
