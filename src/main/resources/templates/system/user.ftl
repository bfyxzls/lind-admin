<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <div class="content-card">
        <!-- 搜索表单 -->
        <el-form :inline="true" :model="queryParams" class="search-form">
            <el-form-item label="用户名">
                <el-input v-model="queryParams.username" placeholder="请输入用户名" clearable style="width: 180px;"></el-input>
            </el-form-item>
            <el-form-item label="昵称">
                <el-input v-model="queryParams.nickname" placeholder="请输入昵称" clearable style="width: 180px;"></el-input>
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
                <el-button type="danger" icon="el-icon-delete" :disabled="selectedIds.length === 0" @click="handleBatchDelete">批量删除</el-button>
            </div>
        </div>

        <!-- 数据表格 -->
        <el-table :data="tableData" v-loading="loading" @selection-change="handleSelectionChange" border>
            <el-table-column type="selection" width="50"></el-table-column>
            <el-table-column prop="id" label="ID" width="80"></el-table-column>
            <el-table-column prop="username" label="用户名" width="120"></el-table-column>
            <el-table-column prop="nickname" label="昵称" width="120"></el-table-column>
            <el-table-column prop="email" label="邮箱" min-width="180"></el-table-column>
            <el-table-column prop="phone" label="手机号" width="130"></el-table-column>
            <el-table-column prop="status" label="状态" width="80">
                <template slot-scope="scope">
                    <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
                        {{ scope.row.status === 1 ? '启用' : '禁用' }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="createdTime" label="创建时间" width="160">
                <template slot-scope="scope">
                    {{ formatDate(scope.row.createdTime) }}
                </template>
            </el-table-column>
            <el-table-column label="操作" width="320" fixed="right">
                <template slot-scope="scope">
                    <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
                    <el-button type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)">重置密码</el-button>
                    <el-button type="text" icon="el-icon-s-custom" @click="handleAssignRoles(scope.row)">分配角色</el-button>
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
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="600px" @close="resetForm('form')">
        <el-form ref="form" :model="form" :rules="rules" label-width="80px">
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="用户名" prop="username">
                        <el-input v-model="form.username" placeholder="请输入用户名" :disabled="form.id !== undefined"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="昵称" prop="nickname">
                        <el-input v-model="form.nickname" placeholder="请输入昵称"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20" v-if="!form.id">
                <el-col :span="12">
                    <el-form-item label="密码" prop="password">
                        <el-input v-model="form.password" type="password" placeholder="请输入密码" show-password></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="手机号" prop="phone">
                        <el-input v-model="form.phone" placeholder="请输入手机号"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="邮箱" prop="email">
                        <el-input v-model="form.email" placeholder="请输入邮箱"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="性别" prop="gender">
                        <el-select v-model="form.gender" placeholder="请选择性别" style="width: 100%;">
                            <el-option label="未知" :value="0"></el-option>
                            <el-option label="男" :value="1"></el-option>
                            <el-option label="女" :value="2"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="状态" prop="status">
                        <el-radio-group v-model="form.status">
                            <el-radio :label="1">启用</el-radio>
                            <el-radio :label="0">禁用</el-radio>
                        </el-radio-group>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-form-item label="备注" prop="remark">
                <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer">
            <el-button @click="dialogVisible = false">取 消</el-button>
            <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 重置密码弹窗 -->
    <el-dialog title="重置密码" :visible.sync="resetPwdVisible" width="400px">
        <el-form ref="resetPwdForm" :model="resetPwdForm" :rules="resetPwdRules" label-width="80px">
            <el-form-item label="用户名">
                <el-input :value="resetPwdForm.username" disabled></el-input>
            </el-form-item>
            <el-form-item label="新密码" prop="password">
                <el-input v-model="resetPwdForm.password" type="password" placeholder="请输入新密码" show-password></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer">
            <el-button @click="resetPwdVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitResetPwd">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 分配角色弹窗 -->
    <el-dialog title="分配角色" :visible.sync="assignRolesVisible" width="500px">
        <el-checkbox-group v-model="selectedRoles">
            <el-checkbox v-for="role in allRoles" :key="role.id" :label="role.id" style="display: block; margin-bottom: 10px;">
                {{ role.roleName }} ({{ role.roleCode }})
            </el-checkbox>
        </el-checkbox-group>
        <div slot="footer">
            <el-button @click="assignRolesVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitAssignRoles">确 定</el-button>
        </div>
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
            submitLoading: false,
            tableData: [],
            total: 0,
            selectedIds: [],
            queryParams: {
                username: '',
                nickname: '',
                status: null,
                pageNum: 1,
                pageSize: 10
            },
            dialogVisible: false,
            dialogTitle: '新增用户',
            form: {
                username: '',
                password: '',
                nickname: '',
                email: '',
                phone: '',
                gender: 0,
                status: 1,
                remark: ''
            },
            rules: {
                username: [
                    { required: true, message: '请输入用户名', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在2到20个字符', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '请输入密码', trigger: 'blur' },
                    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
                ],
                nickname: [
                    { required: true, message: '请输入昵称', trigger: 'blur' }
                ],
                email: [
                    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
                ],
                phone: [
                    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
                ]
            },
            resetPwdVisible: false,
            resetPwdForm: {
                id: null,
                username: '',
                password: ''
            },
            resetPwdRules: {
                password: [
                    { required: true, message: '请输入新密码', trigger: 'blur' },
                    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
                ]
            },
            assignRolesVisible: false,
            currentUserId: null,
            allRoles: [],
            selectedRoles: []
        };
    },
    created() {
        this.loadData();
    },
    methods: {
        async loadData() {
            this.loading = true;
            try {
                const res = await axios.get('/api/user/page', { params: this.queryParams });
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
            this.queryParams = { username: '', nickname: '', status: null, pageNum: 1, pageSize: 10 };
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
        handleSelectionChange(selection) {
            this.selectedIds = selection.map(item => item.id);
        },
        handleAdd() {
            this.dialogTitle = '新增用户';
            this.form = { username: '', password: '', nickname: '', email: '', phone: '', gender: 0, status: 1, remark: '' };
            this.dialogVisible = true;
        },
        handleEdit(row) {
            this.dialogTitle = '编辑用户';
            this.form = { ...row };
            this.dialogVisible = true;
        },
        async handleSubmit() {
            this.$refs.form.validate(async valid => {
                if (valid) {
                    this.submitLoading = true;
                    try {
                        const url = this.form.id ? '/api/user' : '/api/user';
                        const method = this.form.id ? 'put' : 'post';
                        const res = await axios[method](url, this.form);
                        if (res.code === 200) {
                            this.$message.success(this.form.id ? '更新成功' : '新增成功');
                            this.dialogVisible = false;
                            this.loadData();
                        } else {
                            this.$message.error(res.message || '操作失败');
                        }
                    } catch (e) {
                        console.error(e);
                    }
                    this.submitLoading = false;
                }
            });
        },
        async handleDelete(row) {
            try {
                await this.confirmDelete();
                const res = await axios.delete('/api/user/' + row.id);
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    this.loadData();
                } else {
                    this.$message.error(res.message || '删除失败');
                }
            } catch (e) {}
        },
        async handleBatchDelete() {
            try {
                await this.confirmDelete('确定要删除选中的' + this.selectedIds.length + '条记录吗？');
                const res = await axios.delete('/api/user/batch', { data: this.selectedIds });
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    this.loadData();
                } else {
                    this.$message.error(res.message || '删除失败');
                }
            } catch (e) {}
        },
        handleResetPwd(row) {
            this.resetPwdForm = { id: row.id, username: row.username, password: '' };
            this.resetPwdVisible = true;
        },
        async submitResetPwd() {
            this.$refs.resetPwdForm.validate(async valid => {
                if (valid) {
                    try {
                        const res = await axios.put('/api/user/' + this.resetPwdForm.id + '/resetPassword', { password: this.resetPwdForm.password });
                        if (res.code === 200) {
                            this.$message.success('密码重置成功');
                            this.resetPwdVisible = false;
                        } else {
                            this.$message.error(res.message || '重置失败');
                        }
                    } catch (e) {}
                }
            });
        },
        async handleAssignRoles(row) {
            this.currentUserId = row.id;
            try {
                // 加载所有角色
                const roleRes = await axios.get('/api/role/list');
                if (roleRes.code === 200) {
                    this.allRoles = roleRes.data;
                }
                // 获取用户当前角色
                const userRolesRes = await axios.get('/api/user/' + row.id + '/roles');
                if (userRolesRes.code === 200 && userRolesRes.data) {
                    this.selectedRoles = userRolesRes.data.map(r => r.id);
                } else {
                    this.selectedRoles = [];
                }
                this.assignRolesVisible = true;
            } catch (e) {
                console.error(e);
            }
        },
        async submitAssignRoles() {
            try {
                const res = await axios.put('/api/user/' + this.currentUserId + '/roles', this.selectedRoles);
                if (res.code === 200) {
                    this.$message.success('角色分配成功');
                    this.assignRolesVisible = false;
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

