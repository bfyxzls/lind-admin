<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录日志</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <div class="content-card">
        <!-- 搜索表单 -->
        <el-form :inline="true" :model="queryParams" class="search-form">
            <el-form-item label="用户名">
                <el-input v-model="queryParams.username" placeholder="请输入用户名" clearable style="width: 150px;"></el-input>
            </el-form-item>
            <el-form-item label="IP地址">
                <el-input v-model="queryParams.loginIp" placeholder="请输入IP地址" clearable style="width: 150px;"></el-input>
            </el-form-item>
            <el-form-item label="状态">
                <el-select v-model="queryParams.status" placeholder="请选择" clearable style="width: 100px;">
                    <el-option label="成功" :value="1"></el-option>
                    <el-option label="失败" :value="0"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <!-- 数据表格 -->
        <el-table :data="tableData" v-loading="loading" border>
            <el-table-column prop="id" label="日志ID" width="80"></el-table-column>
            <el-table-column prop="username" label="用户名" width="120"></el-table-column>
            <el-table-column prop="loginIp" label="IP地址" width="130"></el-table-column>
            <el-table-column prop="loginLocation" label="登录地点" min-width="150"></el-table-column>
            <el-table-column prop="browser" label="浏览器" min-width="200">
                <template slot-scope="scope">
                    <span style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: block;">
                        {{ scope.row.browser }}
                    </span>
                </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="80">
                <template slot-scope="scope">
                    <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
                        {{ scope.row.status === 1 ? '成功' : '失败' }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="msg" label="消息" min-width="120"></el-table-column>
            <el-table-column prop="loginTime" label="登录时间" width="160">
                <template slot-scope="scope">
                    {{ formatDate(scope.row.loginTime) }}
                </template>
            </el-table-column>
        </el-table>

        <!-- 分页 -->
        <div class="pagination-container">
            <el-pagination
                background
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="queryParams.pageNum"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="queryParams.pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total">
            </el-pagination>
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
    mixins: [CommonMixin],
    data() {
        return {
            loading: false,
            tableData: [],
            total: 0,
            queryParams: {
                username: '',
                loginIp: '',
                status: null,
                pageNum: 1,
                pageSize: 10
            }
        };
    },
    created() {
        this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true;
            try {
                const res = await axios.get('/api/log/login/page', { params: this.queryParams });
                if (res.code === 200) {
                    this.tableData = res.data.records;
                    this.total = res.data.total;
                }
            } catch (e) {}
            this.loading = false;
        },
        handleQuery() {
            this.queryParams.pageNum = 1;
            this.loadData();
        },
        resetQuery() {
            this.queryParams = { username: '', loginIp: '', status: null, pageNum: 1, pageSize: 10 };
            this.loadData();
        },
        handleSizeChange(size) {
            this.queryParams.pageSize = size;
            this.loadData();
        },
        handleCurrentChange(page) {
            this.queryParams.pageNum = page;
            this.loadData();
        }
    }
});
</script>
</body>
</html>

