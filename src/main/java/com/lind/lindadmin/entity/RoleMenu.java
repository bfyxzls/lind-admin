package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 角色菜单关联实体类
 */
@Data
@Entity
@Table(name = "role_menus")
public class RoleMenu implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "role_id", nullable = false)
	private Long roleId;

	@Column(name = "menu_id", nullable = false)
	private Long menuId;

	@Column(name = "created_time")
	private LocalDateTime createdTime;

	@PrePersist
	public void prePersist() {
		if (createdTime == null) {
			createdTime = LocalDateTime.now();
		}
	}

}
