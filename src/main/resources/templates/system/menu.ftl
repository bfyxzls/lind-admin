<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>菜单管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <div class="content-card">
        <!-- 工具栏 -->
        <div class="toolbar">
            <div>
                <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增</el-button>
                <el-button icon="el-icon-sort" @click="toggleExpandAll">{{ expandAll ? '折叠' : '展开' }}</el-button>
            </div>
        </div>

        <!-- 数据表格 -->
        <el-table 
            v-if="refreshTable"
            :data="tableData" 
            v-loading="loading" 
            row-key="id"
            :default-expand-all="expandAll"
            :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
            border>
            <el-table-column prop="menuName" label="菜单名称" min-width="200"></el-table-column>
            <el-table-column prop="icon" label="图标" width="80">
                <template slot-scope="scope">
                    <i :class="scope.row.icon" v-if="scope.row.icon"></i>
                </template>
            </el-table-column>
            <el-table-column prop="sortOrder" label="排序" width="80"></el-table-column>
            <el-table-column prop="path" label="路由地址" min-width="150"></el-table-column>
            <el-table-column prop="permission" label="权限标识" min-width="150"></el-table-column>
            <el-table-column prop="menuType" label="类型" width="80">
                <template slot-scope="scope">
                    <el-tag v-if="scope.row.menuType === 1" type="primary" size="small">目录</el-tag>
                    <el-tag v-else-if="scope.row.menuType === 2" type="success" size="small">菜单</el-tag>
                    <el-tag v-else type="warning" size="small">按钮</el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="visible" label="可见" width="80">
                <template slot-scope="scope">
                    <el-tag :type="scope.row.visible === 1 ? 'success' : 'info'" size="small">
                        {{ scope.row.visible === 1 ? '显示' : '隐藏' }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="80">
                <template slot-scope="scope">
                    <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
                        {{ scope.row.status === 1 ? '启用' : '禁用' }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="260" fixed="right">
                <template slot-scope="scope">
                    <el-button type="text" icon="el-icon-plus" @click="handleAddChild(scope.row)">新增</el-button>
                    <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
                    <el-button type="text" icon="el-icon-delete" style="color: #f56c6c;" @click="handleDelete(scope.row)">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px" @close="resetForm('form')">
        <el-form ref="form" :model="form" :rules="rules" label-width="100px">
            <el-row :gutter="20">
                <el-col :span="24">
                    <el-form-item label="上级菜单" prop="parentId">
                        <el-cascader
                            v-model="form.parentIdPath"
                            :options="menuOptions"
                            :props="{ checkStrictly: true, label: 'menuName', value: 'id', emitPath: true }"
                            clearable
                            placeholder="请选择上级菜单"
                            style="width: 100%;"
                            @change="handleParentChange">
                        </el-cascader>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="菜单类型" prop="menuType">
                        <el-radio-group v-model="form.menuType">
                            <el-radio :label="1">目录</el-radio>
                            <el-radio :label="2">菜单</el-radio>
                            <el-radio :label="3">按钮</el-radio>
                        </el-radio-group>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="菜单名称" prop="menuName">
                        <el-input v-model="form.menuName" placeholder="请输入菜单名称"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="英文名称" prop="menuNameEn">
                        <el-input v-model="form.menuNameEn" placeholder="请输入英文名称"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20" v-if="form.menuType !== 3">
                <el-col :span="12">
                    <el-form-item label="路由地址" prop="path">
                        <el-input v-model="form.path" placeholder="请输入路由地址"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="菜单图标" prop="icon">
                        <el-input v-model="form.icon" placeholder="请输入图标类名">
                            <i slot="prefix" :class="form.icon || 'el-icon-menu'"></i>
                        </el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="权限标识" prop="permission">
                        <el-input v-model="form.permission" placeholder="请输入权限标识"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="排序" prop="sortOrder">
                        <el-input-number v-model="form.sortOrder" :min="0" :max="999" style="width: 100%;"></el-input-number>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item label="是否可见" prop="visible">
                        <el-radio-group v-model="form.visible">
                            <el-radio :label="1">显示</el-radio>
                            <el-radio :label="0">隐藏</el-radio>
                        </el-radio-group>
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
        </el-form>
        <div slot="footer">
            <el-button @click="dialogVisible = false">取 消</el-button>
            <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
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
            expandAll: true,
            refreshTable: true,
            dialogVisible: false,
            dialogTitle: '新增菜单',
            menuOptions: [],
            form: {
                parentId: 0,
                parentIdPath: [],
                menuName: '',
                menuNameEn: '',
                menuType: 1,
                path: '',
                icon: '',
                permission: '',
                sortOrder: 0,
                visible: 1,
                status: 1
            },
            rules: {
                menuName: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
                menuType: [{ required: true, message: '请选择菜单类型', trigger: 'change' }]
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
                const res = await axios.get('/api/menu/tree');
                if (res.code === 200) {
                    this.tableData = res.data;
                    this.menuOptions = [{ id: 0, menuName: '顶级菜单', children: res.data }];
                }
            } catch (e) {}
            this.loading = false;
        },
        toggleExpandAll() {
            this.refreshTable = false;
            this.expandAll = !this.expandAll;
            this.$nextTick(() => {
                this.refreshTable = true;
            });
        },
        handleParentChange(value) {
            this.form.parentId = value && value.length > 0 ? value[value.length - 1] : 0;
        },
        handleAdd() {
            this.dialogTitle = '新增菜单';
            this.form = { parentId: 0, parentIdPath: [0], menuName: '', menuNameEn: '', menuType: 1, path: '', icon: '', permission: '', sortOrder: 0, visible: 1, status: 1 };
            this.dialogVisible = true;
        },
        handleAddChild(row) {
            this.dialogTitle = '新增菜单';
            this.form = { parentId: row.id, parentIdPath: this.findParentPath(row.id), menuName: '', menuNameEn: '', menuType: row.menuType === 1 ? 2 : 3, path: '', icon: '', permission: '', sortOrder: 0, visible: 1, status: 1 };
            this.dialogVisible = true;
        },
        findParentPath(id) {
            const path = [0];
            const find = (nodes, targetId, currentPath) => {
                for (const node of nodes) {
                    const newPath = [...currentPath, node.id];
                    if (node.id === targetId) {
                        return newPath;
                    }
                    if (node.children && node.children.length > 0) {
                        const result = find(node.children, targetId, newPath);
                        if (result) return result;
                    }
                }
                return null;
            };
            return find(this.tableData, id, path) || [0, id];
        },
        handleEdit(row) {
            this.dialogTitle = '编辑菜单';
            this.form = { ...row, parentIdPath: this.findParentPath(row.parentId) };
            this.dialogVisible = true;
        },
        async handleSubmit() {
            this.$refs.form.validate(async valid => {
                if (valid) {
                    this.submitLoading = true;
                    try {
                        const method = this.form.id ? 'put' : 'post';
                        const data = { ...this.form };
                        delete data.parentIdPath;
                        delete data.children;
                        const res = await axios[method]('/api/menu', data);
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
                const res = await axios.delete('/api/menu/' + row.id);
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    this.loadData();
                } else {
                    this.$message.error(res.message || '删除失败');
                }
            } catch (e) {}
        }
    }
});
</script>
</body>
</html>

