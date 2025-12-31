-- ====================================
-- Lind后台管理系统初始化数据
-- ====================================

USE `lind_admin`;

-- ====================================
-- 初始化用户数据（密码为BCrypt加密后的123456）
-- ====================================
INSERT INTO `users` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `gender`, `status`, `remark`, `created_by`) VALUES
(1, 'admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '超级管理员', 'admin@lind.com', '13800138000', 1, 1, '系统管理员', 'system'),
(2, 'test', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '测试用户', 'test@lind.com', '13800138001', 1, 1, '测试账号', 'admin');

-- ====================================
-- 初始化角色数据
-- ====================================
INSERT INTO `roles` (`id`, `role_name`, `role_code`, `sort_order`, `status`, `remark`, `created_by`) VALUES
(1, '超级管理员', 'ROLE_ADMIN', 1, 1, '拥有所有权限', 'system'),
(2, '普通用户', 'ROLE_USER', 2, 1, '普通用户角色', 'system'),
(3, '访客', 'ROLE_GUEST', 3, 1, '只有查看权限', 'system');

-- ====================================
-- 初始化权限数据
-- ====================================
INSERT INTO `permissions` (`id`, `permission_name`, `permission_code`, `permission_type`, `parent_id`, `sort_order`, `status`, `remark`, `created_by`) VALUES
-- 系统管理
(1, '系统管理', 'system:manage', 1, 0, 1, 1, '系统管理模块', 'system'),
-- 用户管理
(10, '用户管理', 'system:user:manage', 1, 1, 1, 1, '用户管理菜单', 'system'),
(11, '用户查询', 'system:user:list', 2, 10, 1, 1, '用户列表查询', 'system'),
(12, '用户新增', 'system:user:add', 2, 10, 2, 1, '新增用户', 'system'),
(13, '用户修改', 'system:user:edit', 2, 10, 3, 1, '修改用户', 'system'),
(14, '用户删除', 'system:user:delete', 2, 10, 4, 1, '删除用户', 'system'),
-- 角色管理
(20, '角色管理', 'system:role:manage', 1, 1, 2, 1, '角色管理菜单', 'system'),
(21, '角色查询', 'system:role:list', 2, 20, 1, 1, '角色列表查询', 'system'),
(22, '角色新增', 'system:role:add', 2, 20, 2, 1, '新增角色', 'system'),
(23, '角色修改', 'system:role:edit', 2, 20, 3, 1, '修改角色', 'system'),
(24, '角色删除', 'system:role:delete', 2, 20, 4, 1, '删除角色', 'system'),
-- 菜单管理
(30, '菜单管理', 'system:menu:manage', 1, 1, 3, 1, '菜单管理菜单', 'system'),
(31, '菜单查询', 'system:menu:list', 2, 30, 1, 1, '菜单列表查询', 'system'),
(32, '菜单新增', 'system:menu:add', 2, 30, 2, 1, '新增菜单', 'system'),
(33, '菜单修改', 'system:menu:edit', 2, 30, 3, 1, '修改菜单', 'system'),
(34, '菜单删除', 'system:menu:delete', 2, 30, 4, 1, '删除菜单', 'system'),
-- 字典管理
(40, '字典管理', 'system:dict:manage', 1, 1, 4, 1, '字典管理菜单', 'system'),
(41, '字典查询', 'system:dict:list', 2, 40, 1, 1, '字典列表查询', 'system'),
(42, '字典新增', 'system:dict:add', 2, 40, 2, 1, '新增字典', 'system'),
(43, '字典修改', 'system:dict:edit', 2, 40, 3, 1, '修改字典', 'system'),
(44, '字典删除', 'system:dict:delete', 2, 40, 4, 1, '删除字典', 'system'),
-- 日志管理
(50, '日志管理', 'system:log:manage', 1, 1, 5, 1, '日志管理菜单', 'system'),
(51, '操作日志', 'system:log:operation', 2, 50, 1, 1, '操作日志查询', 'system'),
(52, '登录日志', 'system:log:login', 2, 50, 2, 1, '登录日志查询', 'system'),
(53, '系统日志', 'system:log:system', 2, 50, 3, 1, '系统日志查询', 'system');

-- ====================================
-- 初始化菜单数据
-- ====================================
INSERT INTO `menus` (`id`, `menu_name`, `menu_name_en`, `parent_id`, `menu_type`, `path`, `component`, `permission`, `icon`, `sort_order`, `visible`, `status`, `created_by`) VALUES
-- 系统管理
(1, '系统管理', 'System', 0, 1, '/system', '', '', 'el-icon-setting', 1, 1, 1, 'system'),
(10, '用户管理', 'Users', 1, 2, '/system/user', 'system/user/index', 'system:user:manage', 'el-icon-user', 1, 1, 1, 'system'),
(11, '用户查询', 'Query', 10, 3, '', '', 'system:user:list', '', 1, 1, 1, 'system'),
(12, '用户新增', 'Add', 10, 3, '', '', 'system:user:add', '', 2, 1, 1, 'system'),
(13, '用户修改', 'Edit', 10, 3, '', '', 'system:user:edit', '', 3, 1, 1, 'system'),
(14, '用户删除', 'Delete', 10, 3, '', '', 'system:user:delete', '', 4, 1, 1, 'system'),
(20, '角色管理', 'Roles', 1, 2, '/system/role', 'system/role/index', 'system:role:manage', 'el-icon-s-custom', 2, 1, 1, 'system'),
(21, '角色查询', 'Query', 20, 3, '', '', 'system:role:list', '', 1, 1, 1, 'system'),
(22, '角色新增', 'Add', 20, 3, '', '', 'system:role:add', '', 2, 1, 1, 'system'),
(23, '角色修改', 'Edit', 20, 3, '', '', 'system:role:edit', '', 3, 1, 1, 'system'),
(24, '角色删除', 'Delete', 20, 3, '', '', 'system:role:delete', '', 4, 1, 1, 'system'),
(30, '菜单管理', 'Menus', 1, 2, '/system/menu', 'system/menu/index', 'system:menu:manage', 'el-icon-menu', 3, 1, 1, 'system'),
(31, '菜单查询', 'Query', 30, 3, '', '', 'system:menu:list', '', 1, 1, 1, 'system'),
(32, '菜单新增', 'Add', 30, 3, '', '', 'system:menu:add', '', 2, 1, 1, 'system'),
(33, '菜单修改', 'Edit', 30, 3, '', '', 'system:menu:edit', '', 3, 1, 1, 'system'),
(34, '菜单删除', 'Delete', 30, 3, '', '', 'system:menu:delete', '', 4, 1, 1, 'system'),
(40, '字典管理', 'Dictionary', 1, 2, '/system/dict', 'system/dict/index', 'system:dict:manage', 'el-icon-document', 4, 1, 1, 'system'),
(41, '字典查询', 'Query', 40, 3, '', '', 'system:dict:list', '', 1, 1, 1, 'system'),
(42, '字典新增', 'Add', 40, 3, '', '', 'system:dict:add', '', 2, 1, 1, 'system'),
(43, '字典修改', 'Edit', 40, 3, '', '', 'system:dict:edit', '', 3, 1, 1, 'system'),
(44, '字典删除', 'Delete', 40, 3, '', '', 'system:dict:delete', '', 4, 1, 1, 'system'),
-- 日志管理
(50, '日志管理', 'Logs', 1, 1, '/system/log', '', 'system:log:manage', 'el-icon-document-copy', 5, 1, 1, 'system'),
(51, '操作日志', 'Operation Logs', 50, 2, '/system/log/operation', 'system/log/operation', 'system:log:operation', '', 1, 1, 1, 'system'),
(52, '登录日志', 'Login Logs', 50, 2, '/system/log/login', 'system/log/login', 'system:log:login', '', 2, 1, 1, 'system'),
(53, '系统日志', 'System Logs', 50, 2, '/system/log/system', 'system/log/system', 'system:log:system', '', 3, 1, 1, 'system'),
-- 首页
(100, '首页', 'Dashboard', 0, 2, '/dashboard', 'dashboard/index', '', 'el-icon-s-home', 0, 1, 1, 'system');

-- ====================================
-- 初始化用户角色关联
-- ====================================
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1),  -- admin -> 超级管理员
(2, 2);  -- test -> 普通用户

-- ====================================
-- 初始化角色权限关联（超级管理员拥有所有权限）
-- ====================================
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1), (1, 10), (1, 11), (1, 12), (1, 13), (1, 14),
(1, 20), (1, 21), (1, 22), (1, 23), (1, 24),
(1, 30), (1, 31), (1, 32), (1, 33), (1, 34),
(1, 40), (1, 41), (1, 42), (1, 43), (1, 44),
(1, 50), (1, 51), (1, 52), (1, 53),
-- 普通用户权限
(2, 11), (2, 21), (2, 31), (2, 41), (2, 51), (2, 52), (2, 53),
-- 访客权限
(3, 11);

-- ====================================
-- 初始化角色菜单关联（超级管理员拥有所有菜单）
-- ====================================
INSERT INTO `role_menus` (`role_id`, `menu_id`) VALUES
(1, 1), (1, 10), (1, 11), (1, 12), (1, 13), (1, 14),
(1, 20), (1, 21), (1, 22), (1, 23), (1, 24),
(1, 30), (1, 31), (1, 32), (1, 33), (1, 34),
(1, 40), (1, 41), (1, 42), (1, 43), (1, 44),
(1, 50), (1, 51), (1, 52), (1, 53), (1, 100),
-- 普通用户菜单
(2, 1), (2, 10), (2, 11), (2, 20), (2, 21), (2, 40), (2, 41), (2, 50), (2, 51), (2, 52), (2, 53), (2, 100),
-- 访客菜单
(3, 10), (3, 11), (3, 100);

-- ====================================
-- 初始化数据字典类型
-- ====================================
INSERT INTO `dict_types` (`id`, `dict_name`, `dict_type`, `status`, `remark`, `created_by`) VALUES
(1, '用户性别', 'sys_user_gender', 1, '用户性别列表', 'system'),
(2, '系统状态', 'sys_status', 1, '系统通用状态', 'system'),
(3, '是否', 'sys_yes_no', 1, '是否选择', 'system'),
(4, '菜单类型', 'sys_menu_type', 1, '菜单类型列表', 'system'),
(5, '操作类型', 'sys_oper_type', 1, '操作类型列表', 'system'),
(6, '登录状态', 'sys_login_status', 1, '登录状态列表', 'system'),
(7, '权限类型', 'sys_permission_type', 1, '权限类型列表', 'system');

-- ====================================
-- 初始化数据字典数据
-- ====================================
INSERT INTO `dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `sort_order`, `status`, `is_default`, `created_by`) VALUES
-- 用户性别
('sys_user_gender', '未知', '0', '', '', 1, 1, 1, 'system'),
('sys_user_gender', '男', '1', '', 'primary', 2, 1, 0, 'system'),
('sys_user_gender', '女', '2', '', 'danger', 3, 1, 0, 'system'),
-- 系统状态
('sys_status', '禁用', '0', '', 'danger', 1, 1, 0, 'system'),
('sys_status', '启用', '1', '', 'success', 2, 1, 1, 'system'),
-- 是否
('sys_yes_no', '否', '0', '', 'danger', 1, 1, 0, 'system'),
('sys_yes_no', '是', '1', '', 'success', 2, 1, 1, 'system'),
-- 菜单类型
('sys_menu_type', '目录', '1', '', 'primary', 1, 1, 0, 'system'),
('sys_menu_type', '菜单', '2', '', 'success', 2, 1, 1, 'system'),
('sys_menu_type', '按钮', '3', '', 'warning', 3, 1, 0, 'system'),
-- 操作类型
('sys_oper_type', '其它', '0', '', 'info', 1, 1, 0, 'system'),
('sys_oper_type', '新增', '1', '', 'success', 2, 1, 0, 'system'),
('sys_oper_type', '修改', '2', '', 'primary', 3, 1, 0, 'system'),
('sys_oper_type', '删除', '3', '', 'danger', 4, 1, 0, 'system'),
('sys_oper_type', '查询', '4', '', 'info', 5, 1, 1, 'system'),
('sys_oper_type', '导出', '5', '', 'warning', 6, 1, 0, 'system'),
('sys_oper_type', '导入', '6', '', 'warning', 7, 1, 0, 'system'),
-- 登录状态
('sys_login_status', '失败', '0', '', 'danger', 1, 1, 0, 'system'),
('sys_login_status', '成功', '1', '', 'success', 2, 1, 1, 'system'),
-- 权限类型
('sys_permission_type', '菜单', '1', '', 'primary', 1, 1, 1, 'system'),
('sys_permission_type', '按钮', '2', '', 'success', 2, 1, 0, 'system'),
('sys_permission_type', '接口', '3', '', 'warning', 3, 1, 0, 'system');

