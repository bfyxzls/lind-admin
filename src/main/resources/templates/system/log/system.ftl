<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统日志</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <div class="content-card">
        <!-- 搜索表单 -->
        <el-form :inline="true" :model="queryParams" class="search-form">
            <el-form-item label="日志类型">
                <el-input v-model="queryParams.logType" placeholder="请输入日志类型" clearable style="width: 150px;"></el-input>
            </el-form-item>
            <el-form-item label="日志级别">
                <el-select v-model="queryParams.logLevel" placeholder="请选择" clearable style="width: 120px;">
                    <el-option label="DEBUG" value="DEBUG"></el-option>
                    <el-option label="INFO" value="INFO"></el-option>
                    <el-option label="WARN" value="WARN"></el-option>
                    <el-option label="ERROR" value="ERROR"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="操作人">
                <el-input v-model="queryParams.operator" placeholder="请输入操作人" clearable style="width: 150px;"></el-input>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <!-- 数据表格 -->
        <el-table :data="tableData" v-loading="loading" border>
            <el-table-column prop="id" label="日志ID" width="80"></el-table-column>
            <el-table-column prop="logType" label="日志类型" width="100"></el-table-column>
            <el-table-column prop="logLevel" label="级别" width="80">
                <template slot-scope="scope">
                    <el-tag :type="getLevelType(scope.row.logLevel)" size="mini">
                        {{ scope.row.logLevel }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="title" label="标题" min-width="150"></el-table-column>
            <el-table-column prop="requestMethod" label="请求方式" width="90"></el-table-column>
            <el-table-column prop="requestUrl" label="请求URL" min-width="200"></el-table-column>
            <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
            <el-table-column prop="requestIp" label="IP地址" width="130"></el-table-column>
            <el-table-column prop="executeTime" label="耗时" width="80">
                <template slot-scope="scope">
                    {{ scope.row.executeTime }}ms
                </template>
            </el-table-column>
            <el-table-column prop="createdTime" label="记录时间" width="160">
                <template slot-scope="scope">
                    {{ formatDate(scope.row.createdTime) }}
                </template>
            </el-table-column>
            <el-table-column label="操作" width="80" fixed="right">
                <template slot-scope="scope">
                    <el-button type="text" @click="handleView(scope.row)">详情</el-button>
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

    <!-- 详情弹窗 -->
    <el-dialog title="系统日志详情" :visible.sync="detailVisible" width="700px">
        <el-descriptions :column="2" border>
            <el-descriptions-item label="日志ID">{{ detail.id }}</el-descriptions-item>
            <el-descriptions-item label="日志类型">{{ detail.logType }}</el-descriptions-item>
            <el-descriptions-item label="日志级别">
                <el-tag :type="getLevelType(detail.logLevel)" size="mini">{{ detail.logLevel }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="操作人">{{ detail.operator }}</el-descriptions-item>
            <el-descriptions-item label="标题" :span="2">{{ detail.title }}</el-descriptions-item>
            <el-descriptions-item label="请求方式">{{ detail.requestMethod }}</el-descriptions-item>
            <el-descriptions-item label="IP地址">{{ detail.requestIp }}</el-descriptions-item>
            <el-descriptions-item label="请求URL" :span="2">{{ detail.requestUrl }}</el-descriptions-item>
            <el-descriptions-item label="执行时间">{{ detail.executeTime }}ms</el-descriptions-item>
            <el-descriptions-item label="记录时间">{{ formatDate(detail.createdTime) }}</el-descriptions-item>
            <el-descriptions-item label="日志内容" :span="2" v-if="detail.content">
                <pre style="margin: 0; white-space: pre-wrap; word-break: break-all; max-height: 200px; overflow-y: auto;">{{ detail.content }}</pre>
            </el-descriptions-item>
            <el-descriptions-item label="请求参数" :span="2" v-if="detail.requestParams">
                <pre style="margin: 0; white-space: pre-wrap; word-break: break-all;">{{ detail.requestParams }}</pre>
            </el-descriptions-item>
            <el-descriptions-item label="异常信息" :span="2" v-if="detail.exceptionInfo">
                <pre style="margin: 0; color: #f56c6c; white-space: pre-wrap; word-break: break-all; max-height: 200px; overflow-y: auto;">{{ detail.exceptionInfo }}</pre>
            </el-descriptions-item>
        </el-descriptions>
    </el-dialog>
</div>

<script src="https://unpkg.com/vue@2/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
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
                logType: '',
                logLevel: '',
                operator: '',
                pageNum: 1,
                pageSize: 10
            },
            detailVisible: false,
            detail: {}
        };
    },
    created() {
        this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true;
            try {
                const res = await axios.get('/api/log/system/page', { params: this.queryParams });
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
            this.queryParams = { logType: '', logLevel: '', operator: '', pageNum: 1, pageSize: 10 };
            this.loadData();
        },
        handleSizeChange(size) {
            this.queryParams.pageSize = size;
            this.loadData();
        },
        handleCurrentChange(page) {
            this.queryParams.pageNum = page;
            this.loadData();
        },
        handleView(row) {
            this.detail = row;
            this.detailVisible = true;
        },
        getLevelType(level) {
            const map = { 'DEBUG': 'info', 'INFO': 'success', 'WARN': 'warning', 'ERROR': 'danger' };
            return map[level] || 'info';
        }
    }
});
</script>
</body>
</html>

