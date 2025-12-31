package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 操作日志实体类
 */
@Data
@Entity
@Table(name = "operation_logs")
public class OperationLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "module", length = 100)
    private String module;

    /**
     * 业务类型（0其它 1新增 2修改 3删除 4查询 5导出 6导入）
     */
    @Column(name = "business_type")
    private Integer businessType = 0;

    @Column(name = "title", length = 200)
    private String title;

    @Column(name = "request_method", length = 10)
    private String requestMethod;

    @Column(name = "method", length = 200)
    private String method;

    @Column(name = "request_url", length = 500)
    private String requestUrl;

    @Column(name = "request_ip", length = 50)
    private String requestIp;

    @Column(name = "request_location", length = 200)
    private String requestLocation;

    @Column(name = "request_params", columnDefinition = "TEXT")
    private String requestParams;

    @Column(name = "response_result", columnDefinition = "TEXT")
    private String responseResult;

    @Column(name = "status")
    private Integer status = 1;

    @Column(name = "error_msg", columnDefinition = "TEXT")
    private String errorMsg;

    @Column(name = "execute_time")
    private Long executeTime = 0L;

    @Column(name = "operator", length = 50)
    private String operator;

    @Column(name = "operator_id")
    private Long operatorId;

    @Column(name = "created_time")
    private LocalDateTime createdTime;

    @PrePersist
    public void prePersist() {
        if (createdTime == null) {
            createdTime = LocalDateTime.now();
        }
    }
}

