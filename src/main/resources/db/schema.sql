-- ====================================
-- Lind后台管理系统数据库初始化脚本
-- 数据库: lind_admin
-- 编码: utf8mb4
-- 排序规则: utf8mb4_general_ci
-- ====================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `lind_admin` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE `lind_admin`;

-- ====================================
-- 1. 用户表（users）
-- ====================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(200) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) DEFAULT '' COMMENT '昵称',
    `email` VARCHAR(100) DEFAULT '' COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT '' COMMENT '手机号',
    `avatar` VARCHAR(500) DEFAULT '' COMMENT '头像地址',
    `gender` TINYINT DEFAULT 0 COMMENT '性别（0未知 1男 2女）',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `login_ip` VARCHAR(50) DEFAULT '' COMMENT '最后登录IP',
    `login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_status` (`status`),
    KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户表';

-- ====================================
-- 2. 角色表（roles）
-- ====================================
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    `role_name` VARCHAR(50) NOT NULL COMMENT '角色名称',
    `role_code` VARCHAR(50) NOT NULL COMMENT '角色编码',
    `sort_order` INT DEFAULT 0 COMMENT '显示顺序',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色表';

-- ====================================
-- 3. 权限表（permissions）
-- ====================================
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '权限ID',
    `permission_name` VARCHAR(100) NOT NULL COMMENT '权限名称',
    `permission_code` VARCHAR(100) NOT NULL COMMENT '权限编码',
    `permission_type` TINYINT DEFAULT 1 COMMENT '权限类型（1菜单 2按钮 3接口）',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父权限ID',
    `sort_order` INT DEFAULT 0 COMMENT '显示顺序',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_permission_code` (`permission_code`),
    KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='权限表';

-- ====================================
-- 4. 菜单表（menus）
-- ====================================
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
    `menu_name` VARCHAR(100) NOT NULL COMMENT '菜单名称',
    `menu_name_en` VARCHAR(100) DEFAULT '' COMMENT '菜单英文名称',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单ID',
    `menu_type` TINYINT DEFAULT 1 COMMENT '菜单类型（1目录 2菜单 3按钮）',
    `path` VARCHAR(200) DEFAULT '' COMMENT '路由地址',
    `component` VARCHAR(200) DEFAULT '' COMMENT '组件路径',
    `permission` VARCHAR(100) DEFAULT '' COMMENT '权限标识',
    `icon` VARCHAR(100) DEFAULT '' COMMENT '菜单图标',
    `sort_order` INT DEFAULT 0 COMMENT '显示顺序',
    `visible` TINYINT DEFAULT 1 COMMENT '是否显示（0隐藏 1显示）',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单表';

-- ====================================
-- 5. 用户角色关联表（user_roles）
-- ====================================
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户角色关联表';

-- ====================================
-- 6. 角色权限关联表（role_permissions）
-- ====================================
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `permission_id` BIGINT NOT NULL COMMENT '权限ID',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
    KEY `idx_role_id` (`role_id`),
    KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色权限关联表';

-- ====================================
-- 7. 角色菜单关联表（role_menus）
-- ====================================
DROP TABLE IF EXISTS `role_menus`;
CREATE TABLE `role_menus` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `menu_id` BIGINT NOT NULL COMMENT '菜单ID',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
    KEY `idx_role_id` (`role_id`),
    KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色菜单关联表';

-- ====================================
-- 8. 数据字典类型表（dict_types）
-- ====================================
DROP TABLE IF EXISTS `dict_types`;
CREATE TABLE `dict_types` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '字典类型ID',
    `dict_name` VARCHAR(100) NOT NULL COMMENT '字典名称',
    `dict_type` VARCHAR(100) NOT NULL COMMENT '字典类型',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_dict_type` (`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据字典类型表';

-- ====================================
-- 9. 数据字典数据表（dict_data）
-- ====================================
DROP TABLE IF EXISTS `dict_data`;
CREATE TABLE `dict_data` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '字典数据ID',
    `dict_type` VARCHAR(100) NOT NULL COMMENT '字典类型',
    `dict_label` VARCHAR(100) NOT NULL COMMENT '字典标签',
    `dict_value` VARCHAR(100) NOT NULL COMMENT '字典值',
    `css_class` VARCHAR(100) DEFAULT '' COMMENT '样式属性',
    `list_class` VARCHAR(100) DEFAULT '' COMMENT '表格回显样式',
    `sort_order` INT DEFAULT 0 COMMENT '显示顺序',
    `status` TINYINT DEFAULT 1 COMMENT '状态（0禁用 1启用）',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认（0否 1是）',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    `created_by` VARCHAR(50) DEFAULT '' COMMENT '创建者',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_by` VARCHAR(50) DEFAULT '' COMMENT '更新者',
    `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT DEFAULT 0 COMMENT '删除标志（0正常 1删除）',
    PRIMARY KEY (`id`),
    KEY `idx_dict_type` (`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据字典数据表';

-- ====================================
-- 10. 系统日志表（system_logs）
-- ====================================
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `log_type` VARCHAR(50) DEFAULT '' COMMENT '日志类型',
    `log_level` VARCHAR(20) DEFAULT 'INFO' COMMENT '日志级别（DEBUG,INFO,WARN,ERROR）',
    `title` VARCHAR(200) DEFAULT '' COMMENT '日志标题',
    `content` TEXT COMMENT '日志内容',
    `request_method` VARCHAR(10) DEFAULT '' COMMENT '请求方式',
    `request_url` VARCHAR(500) DEFAULT '' COMMENT '请求URL',
    `request_ip` VARCHAR(50) DEFAULT '' COMMENT '请求IP',
    `request_params` TEXT COMMENT '请求参数',
    `response_result` TEXT COMMENT '响应结果',
    `exception_info` TEXT COMMENT '异常信息',
    `execute_time` BIGINT DEFAULT 0 COMMENT '执行时间（毫秒）',
    `operator` VARCHAR(50) DEFAULT '' COMMENT '操作人',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_log_type` (`log_type`),
    KEY `idx_created_time` (`created_time`),
    KEY `idx_operator` (`operator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统日志表';

-- ====================================
-- 11. 操作日志表（operation_logs）
-- ====================================
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '操作日志ID',
    `module` VARCHAR(100) DEFAULT '' COMMENT '操作模块',
    `business_type` TINYINT DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除 4查询 5导出 6导入）',
    `title` VARCHAR(200) DEFAULT '' COMMENT '操作标题',
    `request_method` VARCHAR(10) DEFAULT '' COMMENT '请求方式',
    `method` VARCHAR(200) DEFAULT '' COMMENT '方法名称',
    `request_url` VARCHAR(500) DEFAULT '' COMMENT '请求URL',
    `request_ip` VARCHAR(50) DEFAULT '' COMMENT '请求IP',
    `request_location` VARCHAR(200) DEFAULT '' COMMENT '操作地点',
    `request_params` TEXT COMMENT '请求参数',
    `response_result` TEXT COMMENT '返回参数',
    `status` TINYINT DEFAULT 1 COMMENT '操作状态（0失败 1成功）',
    `error_msg` TEXT COMMENT '错误消息',
    `execute_time` BIGINT DEFAULT 0 COMMENT '执行时间（毫秒）',
    `operator` VARCHAR(50) DEFAULT '' COMMENT '操作人员',
    `operator_id` BIGINT DEFAULT NULL COMMENT '操作人员ID',
    `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    PRIMARY KEY (`id`),
    KEY `idx_module` (`module`),
    KEY `idx_business_type` (`business_type`),
    KEY `idx_status` (`status`),
    KEY `idx_created_time` (`created_time`),
    KEY `idx_operator` (`operator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志表';

-- ====================================
-- 12. 登录日志表（login_logs）
-- ====================================
DROP TABLE IF EXISTS `login_logs`;
CREATE TABLE `login_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '登录日志ID',
    `username` VARCHAR(50) DEFAULT '' COMMENT '用户账号',
    `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
    `login_ip` VARCHAR(50) DEFAULT '' COMMENT '登录IP地址',
    `login_location` VARCHAR(200) DEFAULT '' COMMENT '登录地点',
    `browser` VARCHAR(100) DEFAULT '' COMMENT '浏览器类型',
    `os` VARCHAR(100) DEFAULT '' COMMENT '操作系统',
    `status` TINYINT DEFAULT 1 COMMENT '登录状态（0失败 1成功）',
    `msg` VARCHAR(500) DEFAULT '' COMMENT '提示消息',
    `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
    PRIMARY KEY (`id`),
    KEY `idx_username` (`username`),
    KEY `idx_status` (`status`),
    KEY `idx_login_time` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='登录日志表';

