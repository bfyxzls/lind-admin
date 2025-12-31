package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 权限实体类
 */
@Data
@Entity
@Table(name = "permissions")
@EqualsAndHashCode(callSuper = true)
public class Permission extends BaseEntity {

    @Column(name = "permission_name", nullable = false, length = 100)
    private String permissionName;

    @Column(name = "permission_code", nullable = false, unique = true, length = 100)
    private String permissionCode;

    /**
     * 权限类型（1菜单 2按钮 3接口）
     */
    @Column(name = "permission_type")
    private Integer permissionType = 1;

    @Column(name = "parent_id")
    private Long parentId = 0L;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(name = "status")
    private Integer status = 1;

    @Column(name = "remark", length = 500)
    private String remark;
}

