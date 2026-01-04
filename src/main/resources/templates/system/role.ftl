<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>角色管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <div class="content-card">
        <!-- 搜索表单 -->
        <el-form :inline="true" :model="queryParams" class="search-form">
            <el-form-item label="角色名称">
                <el-input v-model="queryParams.roleName" placeholder="请输入角色名称" clearable style="width: 180px;"></el-input>
            </el-form-item>
            <el-form-item label="角色编码">
                <el-input v-model="queryParams.roleCode" placeholder="请输入角色编码" clearable style="width: 180px;"></el-input>
            </el-form-item>
            <el-form-item label="状态">
                <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 120px;">
                    <el-option label="启用" :value="1"></el-option>
                    <el-option label="禁用" :value="0"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <!-- 工具栏 -->
        <div class="toolbar">
            <div>
                <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增</el-button>
            </div>
        </div>

        <!-- 数据表格 -->
        <el-table :data="tableData" v-loading="loading" border>
            <el-table-column prop="id" label="ID" width="80"></el-table-column>
            <el-table-column prop="roleName" label="角色名称" width="150"></el-table-column>
            <el-table-column prop="roleCode" label="角色编码" width="150"></el-table-column>
            <el-table-column prop="sortOrder" label="排序" width="80"></el-table-column>
            <el-table-column prop="status" label="状态" width="80">
                <template slot-scope="scope">
                    <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
                        {{ scope.row.status === 1 ? '启用' : '禁用' }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="remark" label="备注" min-width="200"></el-table-column>
            <el-table-column prop="createdTime" label="创建时间" width="160">
                <template slot-scope="scope">
                    {{ formatDate(scope.row.createdTime) }}
                </template>
            </el-table-column>
            <el-table-column label="操作" width="280" fixed="right">
                <template slot-scope="scope">
                    <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
                    <el-button type="text" icon="el-icon-menu" @click="handleAssignMenus(scope.row)">分配菜单</el-button>
                    <el-button type="text" icon="el-icon-delete" style="color: #f56c6c;" @click="handleDelete(scope.row)">删除</el-button>
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

    <!-- 新增/编辑弹窗 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="500px" @close="resetForm('form')">
        <el-form ref="form" :model="form" :rules="rules" label-width="80px">
            <el-form-item label="角色名称" prop="roleName">
                <el-input v-model="form.roleName" placeholder="请输入角色名称"></el-input>
            </el-form-item>
            <el-form-item label="角色编码" prop="roleCode">
                <el-input v-model="form.roleCode" placeholder="请输入角色编码" :disabled="form.id !== undefined"></el-input>
            </el-form-item>
            <el-form-item label="排序" prop="sortOrder">
                <el-input-number v-model="form.sortOrder" :min="0" :max="999" style="width: 100%;"></el-input-number>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-radio-group v-model="form.status">
                    <el-radio :label="1">启用</el-radio>
                    <el-radio :label="0">禁用</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer">
            <el-button @click="dialogVisible = false">取 消</el-button>
            <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 分配菜单弹窗 -->
    <el-dialog title="分配菜单" :visible.sync="assignMenusVisible" width="500px">
        <div class="tree-container">
            <el-tree
                ref="menuTree"
                :data="menuTree"
                :props="{ label: 'menuName', children: 'children' }"
                show-checkbox
                node-key="id"
                :default-checked-keys="checkedMenuIds"
                :default-expand-all="true">
            </el-tree>
        </div>
        <div slot="footer">
            <el-button @click="assignMenusVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitAssignMenus">确 定</el-button>
        </div>
    </el-dialog>
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
            submitLoading: false,
            tableData: [],
            total: 0,
            queryParams: {
                roleName: '',
                roleCode: '',
                status: null,
                pageNum: 1,
                pageSize: 10
            },
            dialogVisible: false,
            dialogTitle: '新增角色',
            form: {
                roleName: '',
                roleCode: '',
                sortOrder: 0,
                status: 1,
                remark: ''
            },
            rules: {
                roleName: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
                roleCode: [
                    { required: true, message: '请输入角色编码', trigger: 'blur' },
                    { pattern: /^ROLE_[A-Z_]+$/, message: '角色编码格式：ROLE_大写字母', trigger: 'blur' }
                ]
            },
            assignMenusVisible: false,
            currentRoleId: null,
            menuTree: [],
            checkedMenuIds: []
        };
    },
    created() {
        this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true;
            try {
                const res = await axios.get('/api/role/page', { params: this.queryParams });
                if (res.code === 200) {
                    this.tableData = res.data.records;
                    this.total = res.data.total;
                }
            } catch (e) {
                console.error(e);
            }
            this.loading = false;
        },
        handleQuery() {
            this.queryParams.pageNum = 1;
            this.loadData();
        },
        resetQuery() {
            this.queryParams = { roleName: '', roleCode: '', status: null, pageNum: 1, pageSize: 10 };
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
        handleAdd() {
            this.dialogTitle = '新增角色';
            this.form = { roleName: '', roleCode: '', sortOrder: 0, status: 1, remark: '' };
            this.dialogVisible = true;
        },
        handleEdit(row) {
            this.dialogTitle = '编辑角色';
            this.form = { ...row };
            this.dialogVisible = true;
        },
        async handleSubmit() {
            this.$refs.form.validate(async valid => {
                if (valid) {
                    this.submitLoading = true;
                    try {
                        const method = this.form.id ? 'put' : 'post';
                        const res = await axios[method]('/api/role', this.form);
                        if (res.code === 200) {
                            this.$message.success(this.form.id ? '更新成功' : '新增成功');
                            this.dialogVisible = false;
                            this.loadData();
                        } else {
                            this.$message.error(res.message || '操作失败');
                        }
                    } catch (e) {}
                    this.submitLoading = false;
                }
            });
        },
        async handleDelete(row) {
            try {
                await this.confirmDelete();
                const res = await axios.delete('/api/role/' + row.id);
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    this.loadData();
                } else {
                    this.$message.error(res.message || '删除失败');
                }
            } catch (e) {}
        },
        async handleAssignMenus(row) {
            this.currentRoleId = row.id;
            try {
                // 加载菜单树
                const menuRes = await axios.get('/api/menu/tree');
                if (menuRes.code === 200) {
                    this.menuTree = menuRes.data;
                }
                // 获取角色已有菜单
                const roleRes = await axios.get('/api/role/' + row.id);
                if (roleRes.code === 200 && roleRes.data.menus) {
                    this.checkedMenuIds = roleRes.data.menus.map(m => m.id);
                } else {
                    this.checkedMenuIds = [];
                }
                this.assignMenusVisible = true;
            } catch (e) {}
        },
        async submitAssignMenus() {
            try {
                const checkedKeys = this.$refs.menuTree.getCheckedKeys();
                const halfCheckedKeys = this.$refs.menuTree.getHalfCheckedKeys();
                const menuIds = [...checkedKeys, ...halfCheckedKeys];
                const res = await axios.put('/api/role/' + this.currentRoleId + '/menus', menuIds);
                if (res.code === 200) {
                    this.$message.success('菜单分配成功');
                    this.assignMenusVisible = false;
                } else {
                    this.$message.error(res.message || '分配失败');
                }
            } catch (e) {}
        }
    }
});
</script>
</body>
</html>

