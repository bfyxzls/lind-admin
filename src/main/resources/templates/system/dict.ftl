<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>字典管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>[v-cloak] { display: none !important; } body { background: #f0f2f5; }</style>
</head>
<body>
<div id="app" v-cloak>
    <el-row :gutter="20">
        <!-- 字典类型列表 -->
        <el-col :span="10">
            <div class="content-card">
                <div class="toolbar">
                    <h3 style="margin: 0; font-size: 16px;">字典类型</h3>
                    <el-button type="primary" size="small" icon="el-icon-plus" @click="handleAddType">新增</el-button>
                </div>
                <el-table :data="typeList" v-loading="typeLoading" @row-click="handleTypeClick" 
                          highlight-current-row :current-row-key="currentType ? currentType.id : null" border size="small">
                    <el-table-column prop="dictName" label="字典名称" min-width="100"></el-table-column>
                    <el-table-column prop="dictType" label="字典类型" min-width="120"></el-table-column>
                    <el-table-column prop="status" label="状态" width="70">
                        <template slot-scope="scope">
                            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="mini">
                                {{ scope.row.status === 1 ? '启用' : '禁用' }}
                            </el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column label="操作" width="120">
                        <template slot-scope="scope">
                            <el-button type="text" size="mini" @click.stop="handleEditType(scope.row)">编辑</el-button>
                            <el-button type="text" size="mini" style="color: #f56c6c;" @click.stop="handleDeleteType(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </el-col>

        <!-- 字典数据列表 -->
        <el-col :span="14">
            <div class="content-card">
                <div class="toolbar">
                    <h3 style="margin: 0; font-size: 16px;">
                        字典数据
                        <span v-if="currentType" style="color: #409eff; font-weight: normal;">
                            （{{ currentType.dictName }}）
                        </span>
                    </h3>
                    <el-button type="primary" size="small" icon="el-icon-plus" :disabled="!currentType" @click="handleAddData">新增</el-button>
                </div>
                <el-table :data="dataList" v-loading="dataLoading" border size="small">
                    <el-table-column prop="dictLabel" label="标签" min-width="100"></el-table-column>
                    <el-table-column prop="dictValue" label="值" width="80"></el-table-column>
                    <el-table-column prop="listClass" label="样式" width="80">
                        <template slot-scope="scope">
                            <el-tag v-if="scope.row.listClass" :type="scope.row.listClass" size="mini">
                                {{ scope.row.listClass }}
                            </el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="sortOrder" label="排序" width="60"></el-table-column>
                    <el-table-column prop="status" label="状态" width="70">
                        <template slot-scope="scope">
                            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="mini">
                                {{ scope.row.status === 1 ? '启用' : '禁用' }}
                            </el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="isDefault" label="默认" width="60">
                        <template slot-scope="scope">
                            <el-tag v-if="scope.row.isDefault === 1" type="success" size="mini">是</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column label="操作" width="120">
                        <template slot-scope="scope">
                            <el-button type="text" size="mini" @click="handleEditData(scope.row)">编辑</el-button>
                            <el-button type="text" size="mini" style="color: #f56c6c;" @click="handleDeleteData(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </el-col>
    </el-row>

    <!-- 字典类型弹窗 -->
    <el-dialog :title="typeDialogTitle" :visible.sync="typeDialogVisible" width="500px">
        <el-form ref="typeForm" :model="typeForm" :rules="typeRules" label-width="80px">
            <el-form-item label="字典名称" prop="dictName">
                <el-input v-model="typeForm.dictName" placeholder="请输入字典名称"></el-input>
            </el-form-item>
            <el-form-item label="字典类型" prop="dictType">
                <el-input v-model="typeForm.dictType" placeholder="请输入字典类型" :disabled="typeForm.id !== undefined"></el-input>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-radio-group v-model="typeForm.status">
                    <el-radio :label="1">启用</el-radio>
                    <el-radio :label="0">禁用</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input v-model="typeForm.remark" type="textarea" :rows="2"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer">
            <el-button @click="typeDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitTypeForm">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 字典数据弹窗 -->
    <el-dialog :title="dataDialogTitle" :visible.sync="dataDialogVisible" width="500px">
        <el-form ref="dataForm" :model="dataForm" :rules="dataRules" label-width="80px">
            <el-form-item label="字典标签" prop="dictLabel">
                <el-input v-model="dataForm.dictLabel" placeholder="请输入字典标签"></el-input>
            </el-form-item>
            <el-form-item label="字典值" prop="dictValue">
                <el-input v-model="dataForm.dictValue" placeholder="请输入字典值"></el-input>
            </el-form-item>
            <el-form-item label="回显样式" prop="listClass">
                <el-select v-model="dataForm.listClass" placeholder="请选择样式" style="width: 100%;">
                    <el-option label="默认" value=""></el-option>
                    <el-option label="primary" value="primary"></el-option>
                    <el-option label="success" value="success"></el-option>
                    <el-option label="warning" value="warning"></el-option>
                    <el-option label="danger" value="danger"></el-option>
                    <el-option label="info" value="info"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="排序" prop="sortOrder">
                <el-input-number v-model="dataForm.sortOrder" :min="0" :max="999" style="width: 100%;"></el-input-number>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-radio-group v-model="dataForm.status">
                    <el-radio :label="1">启用</el-radio>
                    <el-radio :label="0">禁用</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="是否默认" prop="isDefault">
                <el-radio-group v-model="dataForm.isDefault">
                    <el-radio :label="1">是</el-radio>
                    <el-radio :label="0">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input v-model="dataForm.remark" type="textarea" :rows="2"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer">
            <el-button @click="dataDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="submitDataForm">确 定</el-button>
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
            typeLoading: false,
            dataLoading: false,
            typeList: [],
            dataList: [],
            currentType: null,
            typeDialogVisible: false,
            typeDialogTitle: '新增字典类型',
            typeForm: { dictName: '', dictType: '', status: 1, remark: '' },
            typeRules: {
                dictName: [{ required: true, message: '请输入字典名称', trigger: 'blur' }],
                dictType: [{ required: true, message: '请输入字典类型', trigger: 'blur' }]
            },
            dataDialogVisible: false,
            dataDialogTitle: '新增字典数据',
            dataForm: { dictType: '', dictLabel: '', dictValue: '', listClass: '', sortOrder: 0, status: 1, isDefault: 0, remark: '' },
            dataRules: {
                dictLabel: [{ required: true, message: '请输入字典标签', trigger: 'blur' }],
                dictValue: [{ required: true, message: '请输入字典值', trigger: 'blur' }]
            }
        };
    },
    created() {
        this.loadTypes();
    },
    methods: {
        async loadTypes() {
            this.typeLoading = true;
            try {
                const res = await axios.get('/api/dict/type/list');
                if (res.code === 200) {
                    this.typeList = res.data;
                }
            } catch (e) {}
            this.typeLoading = false;
        },
        async loadData() {
            if (!this.currentType) return;
            this.dataLoading = true;
            try {
                const res = await axios.get('/api/dict/data/type/' + this.currentType.dictType);
                if (res.code === 200) {
                    this.dataList = res.data;
                }
            } catch (e) {}
            this.dataLoading = false;
        },
        handleTypeClick(row) {
            this.currentType = row;
            this.loadData();
        },
        handleAddType() {
            this.typeDialogTitle = '新增字典类型';
            this.typeForm = { dictName: '', dictType: '', status: 1, remark: '' };
            this.typeDialogVisible = true;
        },
        handleEditType(row) {
            this.typeDialogTitle = '编辑字典类型';
            this.typeForm = { ...row };
            this.typeDialogVisible = true;
        },
        async submitTypeForm() {
            this.$refs.typeForm.validate(async valid => {
                if (valid) {
                    try {
                        const method = this.typeForm.id ? 'put' : 'post';
                        const res = await axios[method]('/api/dict/type', this.typeForm);
                        if (res.code === 200) {
                            this.$message.success('操作成功');
                            this.typeDialogVisible = false;
                            this.loadTypes();
                        } else {
                            this.$message.error(res.message);
                        }
                    } catch (e) {}
                }
            });
        },
        async handleDeleteType(row) {
            try {
                await this.confirmDelete();
                const res = await axios.delete('/api/dict/type/' + row.id);
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    if (this.currentType && this.currentType.id === row.id) {
                        this.currentType = null;
                        this.dataList = [];
                    }
                    this.loadTypes();
                } else {
                    this.$message.error(res.message);
                }
            } catch (e) {}
        },
        handleAddData() {
            this.dataDialogTitle = '新增字典数据';
            this.dataForm = { dictType: this.currentType.dictType, dictLabel: '', dictValue: '', listClass: '', sortOrder: 0, status: 1, isDefault: 0, remark: '' };
            this.dataDialogVisible = true;
        },
        handleEditData(row) {
            this.dataDialogTitle = '编辑字典数据';
            this.dataForm = { ...row };
            this.dataDialogVisible = true;
        },
        async submitDataForm() {
            this.$refs.dataForm.validate(async valid => {
                if (valid) {
                    try {
                        const method = this.dataForm.id ? 'put' : 'post';
                        const res = await axios[method]('/api/dict/data', this.dataForm);
                        if (res.code === 200) {
                            this.$message.success('操作成功');
                            this.dataDialogVisible = false;
                            this.loadData();
                        } else {
                            this.$message.error(res.message);
                        }
                    } catch (e) {}
                }
            });
        },
        async handleDeleteData(row) {
            try {
                await this.confirmDelete();
                const res = await axios.delete('/api/dict/data/' + row.id);
                if (res.code === 200) {
                    this.$message.success('删除成功');
                    this.loadData();
                } else {
                    this.$message.error(res.message);
                }
            } catch (e) {}
        }
    }
});
</script>
</body>
</html>

