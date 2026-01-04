<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>仪表盘</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>
        [v-cloak] { display: none !important; }
        body { background: #f0f2f5; }
    </style>
</head>
<body>
<div id="app" v-cloak class="dashboard-container">
    <!-- 统计卡片 -->
    <el-row :gutter="20" style="margin-bottom: 20px;">
        <el-col :span="6">
            <div class="stat-card">
                <div class="stat-icon users">
                    <i class="el-icon-user"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">用户总数</div>
                    <div class="stat-value">{{ stats.userCount }}</div>
                </div>
            </div>
        </el-col>
        <el-col :span="6">
            <div class="stat-card">
                <div class="stat-icon roles">
                    <i class="el-icon-s-custom"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">角色总数</div>
                    <div class="stat-value">{{ stats.roleCount }}</div>
                </div>
            </div>
        </el-col>
        <el-col :span="6">
            <div class="stat-card">
                <div class="stat-icon menus">
                    <i class="el-icon-menu"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">菜单总数</div>
                    <div class="stat-value">{{ stats.menuCount }}</div>
                </div>
            </div>
        </el-col>
        <el-col :span="6">
            <div class="stat-card">
                <div class="stat-icon logs">
                    <i class="el-icon-document"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-title">今日登录</div>
                    <div class="stat-value">{{ stats.todayLoginCount }}</div>
                </div>
            </div>
        </el-col>
    </el-row>

    <!-- 快捷入口和最近操作 -->
    <el-row :gutter="20">
        <el-col :span="12">
            <div class="content-card">
                <h3 style="margin-bottom: 20px; color: #333;">
                    <i class="el-icon-s-grid" style="margin-right: 8px;"></i>快捷入口
                </h3>
                <el-row :gutter="15">
                    <el-col :span="6" v-for="(item, index) in shortcuts" :key="index">
                        <div class="shortcut-item" @click="goTo(item.path)">
                            <div class="shortcut-icon" :style="{ background: item.color }">
                                <i :class="item.icon"></i>
                            </div>
                            <div class="shortcut-name">{{ item.name }}</div>
                        </div>
                    </el-col>
                </el-row>
            </div>
        </el-col>
        <el-col :span="12">
            <div class="content-card">
                <h3 style="margin-bottom: 20px; color: #333;">
                    <i class="el-icon-time" style="margin-right: 8px;"></i>最近登录
                </h3>
                <el-table :data="recentLogins" size="small" style="width: 100%">
                    <el-table-column prop="username" label="用户" width="100"></el-table-column>
                    <el-table-column prop="loginIp" label="IP地址" width="130"></el-table-column>
                    <el-table-column prop="loginTime" label="登录时间">
                        <template slot-scope="scope">
                            {{ formatDate(scope.row.loginTime) }}
                        </template>
                    </el-table-column>
                    <el-table-column prop="status" label="状态" width="80">
                        <template slot-scope="scope">
                            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="mini">
                                {{ scope.row.status === 1 ? '成功' : '失败' }}
                            </el-tag>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </el-col>
    </el-row>

    <!-- 系统信息 -->
    <el-row style="margin-top: 20px;">
        <el-col :span="24">
            <div class="content-card">
                <h3 style="margin-bottom: 20px; color: #333;">
                    <i class="el-icon-info" style="margin-right: 8px;"></i>系统信息
                </h3>
                <el-descriptions :column="3" border>
                    <el-descriptions-item label="系统名称">Lind后台管理系统</el-descriptions-item>
                    <el-descriptions-item label="系统版本">v1.0.0</el-descriptions-item>
                    <el-descriptions-item label="技术栈">Spring Boot + JPA + Freemarker + Vue.js</el-descriptions-item>
                    <el-descriptions-item label="运行环境">Java 17</el-descriptions-item>
                    <el-descriptions-item label="数据库">MySQL 8.0</el-descriptions-item>
                    <el-descriptions-item label="缓存">Redis</el-descriptions-item>
                </el-descriptions>
            </div>
        </el-col>
    </el-row>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2.7.16/dist/vue.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/index.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="/static/js/common.js"></script>
<script>
new Vue({
    el: '#app',
    mixins: [CommonMixin],
    data() {
        return {
            stats: {
                userCount: 0,
                roleCount: 0,
                menuCount: 0,
                todayLoginCount: 0
            },
            shortcuts: [
                { name: '用户管理', icon: 'el-icon-user', path: '/system/user', color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
                { name: '角色管理', icon: 'el-icon-s-custom', path: '/system/role', color: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)' },
                { name: '菜单管理', icon: 'el-icon-menu', path: '/system/menu', color: 'linear-gradient(135deg, #ee0979 0%, #ff6a00 100%)' },
                { name: '字典管理', icon: 'el-icon-document', path: '/system/dict', color: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' }
            ],
            recentLogins: []
        };
    },
    created() {
        this.loadStats();
        this.loadRecentLogins();
    },
    methods: {
        async loadStats() {
            try {
                // 加载用户数量
                const userRes = await axios.get('/api/user/page', { params: { pageNum: 1, pageSize: 1 } });
                if (userRes.code === 200) {
                    this.stats.userCount = userRes.data.total;
                }
            } catch (e) {
                console.error(e);
            }

            try {
                // 加载角色数量
                const roleRes = await axios.get('/api/role/page', { params: { pageNum: 1, pageSize: 1 } });
                if (roleRes.code === 200) {
                    this.stats.roleCount = roleRes.data.total;
                }
            } catch (e) {
                console.error(e);
            }

            try {
                // 加载菜单数量
                const menuRes = await axios.get('/api/menu/list');
                if (menuRes.code === 200) {
                    this.stats.menuCount = menuRes.data.length;
                }
            } catch (e) {
                console.error(e);
            }
        },
        async loadRecentLogins() {
            try {
                const res = await axios.get('/api/log/login/page', { 
                    params: { pageNum: 1, pageSize: 5 } 
                });
                if (res.code === 200) {
                    this.recentLogins = res.data.records;
                    // 计算今日登录数（简化处理）
                    this.stats.todayLoginCount = res.data.records.filter(log => {
                        const loginDate = new Date(log.loginTime);
                        const today = new Date();
                        return loginDate.toDateString() === today.toDateString() && log.status === 1;
                    }).length;
                }
            } catch (e) {
                console.error(e);
            }
        },
        goTo(path) {
            if (window.parent !== window) {
                window.parent.postMessage({ type: 'navigate', path: path }, '*');
            } else {
                window.location.href = path;
            }
        }
    }
});
</script>
<style>
.shortcut-item {
    text-align: center;
    padding: 15px;
    cursor: pointer;
    border-radius: 8px;
    transition: all 0.3s;
}
.shortcut-item:hover {
    background: #f5f5f5;
}
.shortcut-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
    color: #fff;
    font-size: 22px;
}
.shortcut-name {
    font-size: 14px;
    color: #666;
}
</style>
</body>
</html>

