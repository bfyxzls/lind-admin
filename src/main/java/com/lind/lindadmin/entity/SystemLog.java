package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 系统日志实体类
 */
@Data
@Entity
@Table(name = "system_logs")
public class SystemLog implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "log_type", length = 50)
	private String logType;

	@Column(name = "log_level", length = 20)
	private String logLevel = "INFO";

	@Column(name = "title", length = 200)
	private String title;

	@Column(name = "content", columnDefinition = "TEXT")
	private String content;

	@Column(name = "request_method", length = 10)
	private String requestMethod;

	@Column(name = "request_url", length = 500)
	private String requestUrl;

	@Column(name = "request_ip", length = 50)
	private String requestIp;

	@Column(name = "request_params", columnDefinition = "TEXT")
	private String requestParams;

	@Column(name = "response_result", columnDefinition = "TEXT")
	private String responseResult;

	@Column(name = "exception_info", columnDefinition = "TEXT")
	private String exceptionInfo;

	@Column(name = "execute_time")
	private Long executeTime = 0L;

	@Column(name = "operator", length = 50)
	private String operator;

	@Column(name = "created_time")
	private LocalDateTime createdTime;

	@PrePersist
	public void prePersist() {
		if (createdTime == null) {
			createdTime = LocalDateTime.now();
		}
	}

}
