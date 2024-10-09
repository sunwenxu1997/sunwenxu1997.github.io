# 个人作品展示

这是一个开源的个人展示项目（主 `vue3 + tailwindcss` ），里面记录了自己遇到和总结的有意思的小玩意。经过不断优化和迭代，页面变得更加简约和美观，可以用于对外展示或者添加到简历当中🎉。

作品目录主要是通过遍历`works`文件目录，将二级目录下所有功能添加到路由当中。假如你习惯在 `codepen` 等在线平台编写代码，也可以通过在 [src/setting](https://github.com/sunwenxu1997/sunwenxu1997.github.io/blob/main/src/settings.js) 中配置外部路由 `externalRoutes` ，帮你更好的展示👍。

如果更帮助到大家，也欢迎在 [issues](https://github.com/sunwenxu1997/sunwenxu1997.github.io/issues) 提出修改意见🙏。

<center><img src="https://sunwenxu1997.github.io/images/readme_1.png"  width="800"></center>
<center><img src="https://sunwenxu1997.github.io/images/readme_2.gif"  width="800"></center>

### 移动端适配
基于`tailwindcss`实现的移动端适配，所以不用担心在手机上的展示问题。

<center><img src="https://iili.io/Jq64QqJ.gif"  width="800"></center>

### 作品搜索
你可以在作品栏中通过`长按鼠标左键`实现内容的搜索，即便这是一个可以悬浮移动的搜索框，maybe 还有一点点小小的bug！🍕
<center><img src="https://sunwenxu1997.github.io/images/readme_4.jpg"  height="400"></center>

## 结构目录

    |-- tailwind.config.js        // tailwind配置文件
    |-- vite.config.js            // vite配置文件            
    |-- public                    // 静态文件  
    |-- src
        |-- settings.js           // 设置项，其中包含externalRoutes用于配置非项目外的链接，一般为codepen在线代码
        |-- assets
        |-- components            // 组件
        |-- router
        |-- stores
        |-- utils                
        |-- views
            |-- About.vue         // 关于
            |-- Home.vue          // 首页
            |-- Works.vue         // 作品
            |-- works             // 作品目录，可自定义分类
                |-- cssHtml
                |-- gsap
                |-- other
                |-- svg
                |-- three

### 作品配置
其中 `router/works.js` 为作品目录的配置
| 字段 | 描述 |
| --- | --- |
| path | 功能代码地址 |
| name | 标题（项目内文件无需配置，自动匹配当前文件名） |
| code | github代码地址（项目内文件无需配置，自动匹配当前文件路径） |
| link | 掘金文章地址 |
| cover | 封面图 |
| info | 内容信息描述 |
| sort | 排序数值越大越靠前 |
| date | 日期（年月日） |

<center><img src="https://sunwenxu1997.github.io/images/readme_3.jpg"  height="400"></center>

## 项目启动

```sh
npm install
```

### 运行

```sh
npm run dev
```

### 部署

```sh
npm run build
```
