<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lind后台管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>
        [v-cloak] { display: none !important; }
        .el-menu--dark { background-color: #1a1c2e; }
        .el-menu--dark .el-menu-item,
        .el-menu--dark .el-submenu__title { background-color: transparent; }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="main-container">
        <!-- 顶部导航 -->
        <header class="header">
            <div class="header-left">
                <span class="system-title">
                    <i class="el-icon-s-platform"></i> Lind后台管理系统
                </span>
            </div>
            <div class="header-right">
                <el-dropdown @command="handleCommand">
                    <div class="user-info">
                        <div class="user-avatar">
                            {{ userInfo.nickname ? userInfo.nickname.charAt(0) : 'U' }}
                        </div>
                        <span class="user-name">{{ userInfo.nickname || userInfo.username }}</span>
                        <i class="el-icon-arrow-down" style="margin-left: 5px;"></i>
                    </div>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item command="profile" icon="el-icon-user">个人中心</el-dropdown-item>
                        <el-dropdown-item command="logout" icon="el-icon-switch-button" divided>退出登录</el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </header>

        <!-- 主内容区 -->
        <div class="main-content">
            <!-- 侧边栏 -->
            <aside class="sidebar" :class="{ collapsed: isCollapsed }">
                <el-menu
                        :default-active="activeMenu"
                        :collapse="isCollapsed"
                        :unique-opened="true"
                        background-color="#1a1c2e"
                        text-color="rgba(255,255,255,0.7)"
                        active-text-color="#fff"
                        @select="handleMenuSelect">
                    <template v-for="menu in menus">
                        <!-- 有子菜单 -->
                        <el-submenu v-if="hasVisibleChildren(menu)"
                                    :index="'menu-' + menu.id"
                                    :key="menu.id">
                            <template slot="title">
                                <i :class="menu.icon || 'el-icon-menu'"></i>
                                <span>{{ menu.menuName }}</span>
                            </template>
                            <template v-for="child in menu.children">
                                <!-- 二级子菜单 -->
                                <el-submenu v-if="hasVisibleChildren(child)"
                                            :index="'menu-' + child.id"
                                            :key="child.id">
                                    <template slot="title">
                                        <i :class="child.icon || 'el-icon-document'"></i>
                                        <span>{{ child.menuName }}</span>
                                    </template>
                                    <el-menu-item v-for="subChild in child.children"
                                                  v-if="subChild.menuType === 2"
                                                  :index="subChild.path"
                                                  :key="subChild.id">
                                        <i :class="subChild.icon || 'el-icon-document'"></i>
                                        <span slot="title">{{ subChild.menuName }}</span>
                                    </el-menu-item>
                                </el-submenu>
                                <!-- 二级菜单项 -->
                                <el-menu-item v-else-if="child.menuType === 2"
                                              :index="child.path"
                                              :key="child.id">
                                    <i :class="child.icon || 'el-icon-document'"></i>
                                    <span slot="title">{{ child.menuName }}</span>
                                </el-menu-item>
                            </template>
                        </el-submenu>
                        <!-- 无子菜单 -->
                        <el-menu-item v-else-if="menu.menuType === 2"
                                      :index="menu.path"
                                      :key="menu.id">
                            <i :class="menu.icon || 'el-icon-menu'"></i>
                            <span slot="title">{{ menu.menuName }}</span>
                        </el-menu-item>
                    </template>
                </el-menu>
            </aside>

            <!-- 工作区 -->
            <main class="workspace">
                <!-- 面包屑 -->
                <div class="breadcrumb-container">
                    <i class="el-icon-s-fold"
                       style="cursor: pointer; font-size: 18px; margin-right: 15px;"
                       @click="isCollapsed = !isCollapsed"></i>
                    <el-breadcrumb separator="/">
                        <el-breadcrumb-item>首页</el-breadcrumb-item>
                        <el-breadcrumb-item v-for="item in breadcrumbs" :key="item">{{ item }}</el-breadcrumb-item>
                    </el-breadcrumb>
                </div>

                <!-- 页面内容 -->
                <div class="page-content">
                    <iframe
                            :src="iframeSrc"
                            frameborder="0"
                            style="width: 100%; height: 100%; border: none;">
                    </iframe>
                </div>
            </main>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2.7.16/dist/vue.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/index.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
    new Vue({
        el: '#app',
        data() {
            return {
                userInfo: {
                    username: '${user.username!""}',
                    nickname: '${user.nickname!""}'
                },
                menus: [],
                activeMenu: '/dashboard',
                breadcrumbs: ['仪表盘'],
                isCollapsed: false,
                iframeSrc: '/dashboard'
            };
        },
        created() {
            this.loadMenus();
            // 监听来自iframe的导航消息
            window.addEventListener('message', this.handleIframeMessage);
        },
        beforeDestroy() {
            window.removeEventListener('message', this.handleIframeMessage);
        },
        methods: {
            loadMenus() {
                // 从服务端获取菜单数据（已在模板中渲染）
                const menuData = [
                    <#if menus?? && menus?size gt 0>
                    <#list menus as menu>
                    {
                        id: ${menu.id},
                        menuName: '${menu.menuName}',
                        menuNameEn: '${menu.menuNameEn!""}',
                        path: '${menu.path!""}',
                        icon: '${menu.icon!"el-icon-menu"}',
                        menuType: ${menu.menuType!1},
                        children: [
                            <#if menu.children?? && menu.children?size gt 0>
                            <#list menu.children as child>
                            {
                                id: ${child.id},
                                menuName: '${child.menuName}',
                                path: '${child.path!""}',
                                icon: '${child.icon!""}',
                                menuType: ${child.menuType!2},
                                children: [
                                    <#if child.children?? && child.children?size gt 0>
                                    <#list child.children as subChild>
                                    {
                                        id: ${subChild.id},
                                        menuName: '${subChild.menuName}',
                                        path: '${subChild.path!""}',
                                        icon: '${subChild.icon!""}',
                                        menuType: ${subChild.menuType!2}
                                    }<#if subChild_has_next>,</#if>
                                    </#list>
                                    </#if>
                                ]
                            }<#if child_has_next>,</#if>
                            </#list>
                            </#if>
                        ]
                    }<#if menu_has_next>,</#if>
                    </#list>
                    </#if>
                ];
                this.menus = menuData;
            },
            hasVisibleChildren(menu) {
                if (!menu.children || menu.children.length === 0) {
                    return false;
                }
                // 检查是否有可见的子菜单（menuType为1或2）
                return menu.children.some(child => child.menuType === 1 || child.menuType === 2);
            },
            handleMenuSelect(path) {
                if (path && path.startsWith('/')) {
                    this.activeMenu = path;
                    this.iframeSrc = path;
                    this.updateBreadcrumbs(path);
                }
            },
            updateBreadcrumbs(path) {
                const breadcrumbs = [];
                const findMenu = (menus, targetPath, parentNames) => {
                    for (const menu of menus) {
                        if (menu.path === targetPath) {
                            breadcrumbs.push(...parentNames, menu.menuName);
                            return true;
                        }
                        if (menu.children && menu.children.length > 0) {
                            if (findMenu(menu.children, targetPath, [...parentNames, menu.menuName])) {
                                return true;
                            }
                        }
                    }
                    return false;
                };
                findMenu(this.menus, path, []);
                this.breadcrumbs = breadcrumbs.length > 0 ? breadcrumbs : ['首页'];
            },
            handleCommand(command) {
                if (command === 'logout') {
                    this.$confirm('确定要退出登录吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(() => {
                        window.location.href = '/logout';
                    }).catch(() => {});
                } else if (command === 'profile') {
                    this.iframeSrc = '/profile';
                    this.activeMenu = '';
                    this.breadcrumbs = ['个人中心'];
                }
            },
            handleIframeMessage(event) {
                // 处理来自iframe（如dashboard快捷入口）的导航消息
                if (event.data && event.data.type === 'navigate' && event.data.path) {
                    const path = event.data.path;
                    this.activeMenu = path;
                    this.iframeSrc = path;
                    this.updateBreadcrumbs(path);
                }
            }
        }
    });
</script>
</body>
</html>

