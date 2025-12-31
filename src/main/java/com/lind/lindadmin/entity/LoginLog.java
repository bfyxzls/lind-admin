package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 登录日志实体类
 */
@Data
@Entity
@Table(name = "login_logs")
public class LoginLog implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "username", length = 50)
	private String username;

	@Column(name = "user_id")
	private Long userId;

	@Column(name = "login_ip", length = 50)
	private String loginIp;

	@Column(name = "login_location", length = 200)
	private String loginLocation;

	@Column(name = "browser", length = 100)
	private String browser;

	@Column(name = "os", length = 100)
	private String os;

	@Column(name = "status")
	private Integer status = 1;

	@Column(name = "msg", length = 500)
	private String msg;

	@Column(name = "login_time")
	private LocalDateTime loginTime;

	@PrePersist
	public void prePersist() {
		if (loginTime == null) {
			loginTime = LocalDateTime.now();
		}
	}

}
