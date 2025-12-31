/**
 * 公共JS
 */

// Axios配置
axios.defaults.timeout = 30000;
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

// 请求拦截器
axios.interceptors.request.use(
    config => {
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

// 响应拦截器
axios.interceptors.response.use(
    response => {
        const res = response.data;
        if (res.code === 401) {
            // 未登录，跳转到登录页
            window.location.href = '/login';
            return Promise.reject(new Error(res.message || '未登录'));
        }
        if (res.code === 403) {
            Vue.prototype.$message.error('权限不足');
            return Promise.reject(new Error(res.message || '权限不足'));
        }
        return res;
    },
    error => {
        if (error.response) {
            if (error.response.status === 401) {
                window.location.href = '/login';
            } else if (error.response.status === 403) {
                Vue.prototype.$message.error('权限不足');
            } else {
                Vue.prototype.$message.error(error.response.data.message || '请求失败');
            }
        } else {
            Vue.prototype.$message.error('网络错误');
        }
        return Promise.reject(error);
    }
);

/**
 * 工具函数
 */
const Utils = {
    /**
     * 格式化日期
     */
    formatDate(date, format = 'yyyy-MM-dd HH:mm:ss') {
        if (!date) return '';
        if (typeof date === 'string') {
            date = new Date(date);
        }
        const o = {
            'M+': date.getMonth() + 1,
            'd+': date.getDate(),
            'H+': date.getHours(),
            'm+': date.getMinutes(),
            's+': date.getSeconds(),
            'q+': Math.floor((date.getMonth() + 3) / 3),
            'S': date.getMilliseconds()
        };
        if (/(y+)/.test(format)) {
            format = format.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length));
        }
        for (const k in o) {
            if (new RegExp('(' + k + ')').test(format)) {
                format = format.replace(RegExp.$1, RegExp.$1.length === 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length));
            }
        }
        return format;
    },

    /**
     * 构建树形结构
     */
    buildTree(data, options = {}) {
        const { idKey = 'id', parentKey = 'parentId', childrenKey = 'children', rootValue = 0 } = options;
        const result = [];
        const map = {};

        data.forEach(item => {
            map[item[idKey]] = { ...item, [childrenKey]: [] };
        });

        data.forEach(item => {
            const parent = map[item[parentKey]];
            if (parent) {
                parent[childrenKey].push(map[item[idKey]]);
            } else if (item[parentKey] === rootValue || item[parentKey] === null) {
                result.push(map[item[idKey]]);
            }
        });

        return result;
    },

    /**
     * 获取树节点的所有ID
     */
    getTreeIds(tree, idKey = 'id', childrenKey = 'children') {
        const ids = [];
        const traverse = (nodes) => {
            nodes.forEach(node => {
                ids.push(node[idKey]);
                if (node[childrenKey] && node[childrenKey].length > 0) {
                    traverse(node[childrenKey]);
                }
            });
        };
        traverse(tree);
        return ids;
    },

    /**
     * 深拷贝
     */
    deepClone(obj) {
        if (obj === null || typeof obj !== 'object') return obj;
        if (obj instanceof Date) return new Date(obj);
        if (obj instanceof Array) {
            return obj.map(item => Utils.deepClone(item));
        }
        if (obj instanceof Object) {
            const copy = {};
            Object.keys(obj).forEach(key => {
                copy[key] = Utils.deepClone(obj[key]);
            });
            return copy;
        }
        return obj;
    }
};

/**
 * 字典工具
 */
const DictUtils = {
    cache: {},

    /**
     * 加载字典数据
     */
    async loadDict(dictType) {
        if (this.cache[dictType]) {
            return this.cache[dictType];
        }
        try {
            const res = await axios.get(`/api/dict/data/type/${dictType}`);
            if (res.code === 200) {
                this.cache[dictType] = res.data;
                return res.data;
            }
        } catch (e) {
            console.error('加载字典失败:', e);
        }
        return [];
    },

    /**
     * 获取字典标签
     */
    getLabel(dictType, value) {
        const items = this.cache[dictType] || [];
        const item = items.find(i => i.dictValue == value);
        return item ? item.dictLabel : value;
    },

    /**
     * 获取字典样式
     */
    getListClass(dictType, value) {
        const items = this.cache[dictType] || [];
        const item = items.find(i => i.dictValue == value);
        return item ? item.listClass : '';
    }
};

/**
 * 混入公共方法
 */
const CommonMixin = {
    methods: {
        formatDate: Utils.formatDate,
        buildTree: Utils.buildTree,
        deepClone: Utils.deepClone,

        /**
         * 重置表单
         */
        resetForm(formName) {
            if (this.$refs[formName]) {
                this.$refs[formName].resetFields();
            }
        },

        /**
         * 确认删除
         */
        confirmDelete(message = '确定要删除吗？') {
            return this.$confirm(message, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            });
        }
    }
};

