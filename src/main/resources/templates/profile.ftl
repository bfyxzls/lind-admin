<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>
        [v-cloak] { display: none !important; }
        body { background: #f0f2f5; }
        .profile-container { max-width: 800px; margin: 0 auto; }
        .avatar-box {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px 8px 0 0;
            color: #fff;
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            margin: 0 auto 15px;
            border: 3px solid rgba(255,255,255,0.5);
        }
        .username { font-size: 20px; font-weight: 600; }
        .tabs-box { background: #fff; border-radius: 0 0 8px 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="profile-container">
        <!-- 头像区域 -->
        <div class="avatar-box">
            <div class="avatar">
                {{ userInfo.nickname ? userInfo.nickname.charAt(0) : 'U' }}
            </div>
            <div class="username">{{ userInfo.nickname || userInfo.username }}</div>
            <div style="opacity: 0.8; margin-top: 5px;">{{ userInfo.email }}</div>
        </div>

        <!-- 标签页 -->
        <div class="tabs-box">
            <el-tabs v-model="activeTab" style="padding: 20px;">
                <!-- 基本信息 -->
                <el-tab-pane label="基本信息" name="info">
                    <el-form ref="infoForm" :model="userInfo" :rules="infoRules" label-width="80px" style="max-width: 500px;">
                        <el-form-item label="用户名">
                            <el-input v-model="userInfo.username" disabled></el-input>
                        </el-form-item>
                        <el-form-item label="昵称" prop="nickname">
                            <el-input v-model="userInfo.nickname" placeholder="请输入昵称"></el-input>
                        </el-form-item>
                        <el-form-item label="邮箱" prop="email">
                            <el-input v-model="userInfo.email" placeholder="请输入邮箱"></el-input>
                        </el-form-item>
                        <el-form-item label="手机号" prop="phone">
                            <el-input v-model="userInfo.phone" placeholder="请输入手机号"></el-input>
                        </el-form-item>
                        <el-form-item label="性别" prop="gender">
                            <el-radio-group v-model="userInfo.gender">
                                <el-radio :label="0">未知</el-radio>
                                <el-radio :label="1">男</el-radio>
                                <el-radio :label="2">女</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" :loading="infoLoading" @click="saveInfo">保存修改</el-button>
                        </el-form-item>
                    </el-form>
                </el-tab-pane>

                <!-- 修改密码 -->
                <el-tab-pane label="修改密码" name="password">
                    <el-form ref="pwdForm" :model="pwdForm" :rules="pwdRules" label-width="100px" style="max-width: 500px;">
                        <el-form-item label="原密码" prop="oldPassword">
                            <el-input v-model="pwdForm.oldPassword" type="password" placeholder="请输入原密码" show-password></el-input>
                        </el-form-item>
                        <el-form-item label="新密码" prop="newPassword">
                            <el-input v-model="pwdForm.newPassword" type="password" placeholder="请输入新密码" show-password></el-input>
                        </el-form-item>
                        <el-form-item label="确认新密码" prop="confirmPassword">
                            <el-input v-model="pwdForm.confirmPassword" type="password" placeholder="请确认新密码" show-password></el-input>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" :loading="pwdLoading" @click="changePassword">修改密码</el-button>
                            <el-button @click="resetPwdForm">重置</el-button>
                        </el-form-item>
                    </el-form>
                </el-tab-pane>
            </el-tabs>
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
        const validateConfirmPwd = (rule, value, callback) => {
            if (value !== this.pwdForm.newPassword) {
                callback(new Error('两次输入的密码不一致'));
            } else {
                callback();
            }
        };
        return {
            activeTab: 'info',
            userInfo: {
                username: '',
                nickname: '',
                email: '',
                phone: '',
                gender: 0
            },
            infoLoading: false,
            infoRules: {
                nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
                email: [{ type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }],
                phone: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }]
            },
            pwdForm: {
                oldPassword: '',
                newPassword: '',
                confirmPassword: ''
            },
            pwdLoading: false,
            pwdRules: {
                oldPassword: [{ required: true, message: '请输入原密码', trigger: 'blur' }],
                newPassword: [
                    { required: true, message: '请输入新密码', trigger: 'blur' },
                    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
                ],
                confirmPassword: [
                    { required: true, message: '请确认新密码', trigger: 'blur' },
                    { validator: validateConfirmPwd, trigger: 'blur' }
                ]
            }
        };
    },
    created() {
        this.loadUserInfo();
    },
    methods: {
        async loadUserInfo() {
            try {
                const res = await axios.get('/api/profile');
                if (res.code === 200) {
                    this.userInfo = res.data;
                }
            } catch (e) {}
        },
        async saveInfo() {
            this.$refs.infoForm.validate(async valid => {
                if (valid) {
                    this.infoLoading = true;
                    try {
                        const res = await axios.put('/api/profile', this.userInfo);
                        if (res.code === 200) {
                            this.$message.success('保存成功');
                        } else {
                            this.$message.error(res.message || '保存失败');
                        }
                    } catch (e) {}
                    this.infoLoading = false;
                }
            });
        },
        async changePassword() {
            this.$refs.pwdForm.validate(async valid => {
                if (valid) {
                    this.pwdLoading = true;
                    try {
                        const res = await axios.put('/api/profile/password', {
                            oldPassword: this.pwdForm.oldPassword,
                            newPassword: this.pwdForm.newPassword
                        });
                        if (res.code === 200) {
                            this.$message.success('密码修改成功，请重新登录');
                            setTimeout(() => {
                                window.top.location.href = '/logout';
                            }, 1500);
                        } else {
                            this.$message.error(res.message || '修改失败');
                        }
                    } catch (e) {}
                    this.pwdLoading = false;
                }
            });
        },
        resetPwdForm() {
            this.pwdForm = { oldPassword: '', newPassword: '', confirmPassword: '' };
            this.$refs.pwdForm.resetFields();
        }
    }
});
</script>
</body>
</html>

