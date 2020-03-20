

# thinkjs-iview-admin
thinkjs-iview-admin 是一个轻量级的快速开发后台管理系统架构, 以Thinkjs作为中间层, Vuejs作为前端模块化开发, iview-admin作为前端UI, 实现了前后端分离。

在此基础上融合了一个小程序商城，目前商城的后台管理还未完善，本人会尽快更新，并在开发过程中不断完善和补充后台管理框架！

## 后端项目：back-end

- sql文件导入到本地数据库即可

```bush
//安装依赖：
npm install
```

```bush
//启动程序：
npm start
```


## 前端项目：front-end

#### [演示界面和截图](./front-end/README.md)

#### 功能点：

- 登录/登出
- 系统管理
    - 用户管理
    - 菜单管理
    - 角色管理
    - 字典管理
    - 代码生成器
- 多语言切换
- 个人中心
- 锁屏
- 全屏
- 错误页面
- DEMO页面
    - 。。。。就不一一列举了
    

```bush
超级管理员帐号为admin 111111，后台所有帐号的默认密码都为111111
```

```bush
// 安装依赖：
npm install
```


```bush
//启动开发环境：
npm run dev
```


```bush
//打包正式环境：
npm run build
```

## 代码生成器的使用方法

- 创建表的时候最好填写表的描述和各个字段的描述。
- id（主键）,create_date（创建时间）,update_date（修改时间）,del_flag（软删除标记）  四个字段缺一不可。
- 在代码生成器中选择表名，然后配置，点击“生成代码”即可！




## 小程序商城项目：wechat-mall

#### [截图](./wechat-mall/README.md)

#### 功能列表：

- 首页
- 分类首页、分类商品、新品首发、人气推荐商品页面
- 商品详情页面，包含加入购物车、收藏商品、商品评论功能
- 搜索功能
- 专题功能
- 品牌功能
- 完整的购物流程，商品的加入、编辑、删除、批量选择，收货地址的选择，下单支付
- 会员中心（订单、收藏、足迹、收货地址、意见反馈） ....


## 开发计划

- 上传图片和富文本编辑器直传七牛云（已完成）
- 完善小程序后台 （进行中...）
- 集成ueditor的node.js版本


## 参考Links

- [thinkjs](https://github.com/thinkjs/thinkjs)
- [iView](https://github.com/iview/iview)
- [iView-admin](https://github.com/iview/iview-admin)
- [Vue](https://github.com/vuejs/vue)
- [Webpack](https://github.com/webpack/webpack)