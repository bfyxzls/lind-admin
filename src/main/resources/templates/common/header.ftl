<#-- 公共头部 -->
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${title!'Lind后台管理系统'}</title>
    <#-- Element UI CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
    <#-- 自定义CSS -->
    <link rel="stylesheet" href="/static/css/common.css">
    <#-- 页面自定义CSS -->
    <#if pageCss??>
    <link rel="stylesheet" href="${pageCss}">
    </#if>
    <style>
        [v-cloak] {
            display: none !important;
        }
    </style>
</head>
<body>

