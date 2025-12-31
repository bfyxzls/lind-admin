<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - Lind后台管理系统</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="/static/css/common.css">
    <style>
        [v-cloak] { display: none !important; }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="login-container">
        <div class="login-box">
            <h2 class="login-title">
                <i class="el-icon-s-platform" style="margin-right: 10px;"></i>
                Lind后台管理系统
            </h2>
            <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
                <el-form-item prop="username">
                    <el-input
                        v-model="loginForm.username"
                        prefix-icon="el-icon-user"
                        placeholder="请输入用户名"
                        autocomplete="off">
                    </el-input>
                </el-form-item>
                <el-form-item prop="password">
                    <el-input
                        v-model="loginForm.password"
                        prefix-icon="el-icon-lock"
                        type="password"
                        placeholder="请输入密码"
                        autocomplete="off"
                        @keyup.enter.native="handleLogin"
                        show-password>
                    </el-input>
                </el-form-item>
                <div class="login-options">
                    <el-checkbox v-model="loginForm.rememberMe">记住我</el-checkbox>
                </div>
                <el-form-item>
                    <el-button type="primary" :loading="loading" @click="handleLogin">
                        {{ loading ? '登录中...' : '登 录' }}
                    </el-button>
                </el-form-item>
            </el-form>
            <div v-if="errorMsg" style="color: #f56c6c; text-align: center; margin-top: 10px;">
                {{ errorMsg }}
            </div>
        </div>
    </div>
</div>

<script src="https://unpkg.com/vue@2/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
new Vue({
    el: '#app',
    data() {
        return {
            loginForm: {
                username: '',
                password: '',
                rememberMe: false
            },
            loginRules: {
                username: [
                    { required: true, message: '请输入用户名', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '请输入密码', trigger: 'blur' },
                    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
                ]
            },
            loading: false,
            errorMsg: '${error!""}'
        };
    },
    methods: {
        handleLogin() {
            this.$refs.loginForm.validate(valid => {
                if (valid) {
                    this.loading = true;
                    this.errorMsg = '';
                    
                    // 创建表单数据
                    const formData = new FormData();
                    formData.append('username', this.loginForm.username);
                    formData.append('password', this.loginForm.password);
                    if (this.loginForm.rememberMe) {
                        formData.append('rememberMe', 'on');
                    }
                    
                    // 提交表单
                    fetch('/login', {
                        method: 'POST',
                        body: formData
                    }).then(response => {
                        if (response.redirected) {
                            window.location.href = response.url;
                        } else {
                            return response.json();
                        }
                    }).then(data => {
                        if (data && data.code === 200) {
                            window.location.href = '/';
                        } else if (data) {
                            this.errorMsg = data.message || '登录失败';
                        }
                    }).catch(err => {
                        this.errorMsg = '登录失败，请稍后重试';
                    }).finally(() => {
                        this.loading = false;
                    });
                }
            });
        }
    }
});
</script>
</body>
</html>

