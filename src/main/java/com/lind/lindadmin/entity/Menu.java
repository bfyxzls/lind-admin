package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

/**
 * 菜单实体类
 */
@Data
@Entity
@Table(name = "menus")
@EqualsAndHashCode(callSuper = true)
public class Menu extends BaseEntity {

	@Column(name = "menu_name", nullable = false, length = 100)
	private String menuName;

	@Column(name = "menu_name_en", length = 100)
	private String menuNameEn;

	@Column(name = "parent_id")
	private Long parentId = 0L;

	/**
	 * 菜单类型（1目录 2菜单 3按钮）
	 */
	@Column(name = "menu_type")
	private Integer menuType = 1;

	@Column(name = "path", length = 200)
	private String path;

	@Column(name = "component", length = 200)
	private String component;

	@Column(name = "permission", length = 100)
	private String permission;

	@Column(name = "icon", length = 100)
	private String icon;

	@Column(name = "sort_order")
	private Integer sortOrder = 0;

	@Column(name = "visible")
	private Integer visible = 1;

	@Column(name = "status")
	private Integer status = 1;

	@Column(name = "remark", length = 500)
	private String remark;

	@Transient
	private List<Menu> children = new ArrayList<>();

}
