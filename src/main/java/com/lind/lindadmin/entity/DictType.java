package com.lind.lindadmin.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 数据字典类型实体类
 */
@Data
@Entity
@Table(name = "dict_types")
@EqualsAndHashCode(callSuper = true)
public class DictType extends BaseEntity {

    @Column(name = "dict_name", nullable = false, length = 100)
    private String dictName;

    @Column(name = "dict_type", nullable = false, unique = true, length = 100)
    private String dictType;

    @Column(name = "status")
    private Integer status = 1;

    @Column(name = "remark", length = 500)
    private String remark;
}

