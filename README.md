## 工程目录
```
├───entry/src/main/ets
│  ├──api
│  │  ├──types.ts                               // 各种接口
│  │  └──user.ts                                // 用户相关 api
│  ├──components
│  │  ├──common
│  │  │  ├──AdSwiper.ets
│  │  │  ├──CreatePostPage.ets
│  │  │  ├──PostCard.ets
│  │  │  └──TrainingPlan.ets                    // 训练计划
│  │  └──user
│  │     └──AccountComponent.ets
│  ├──entryability
│  │  └──EntryAbility.ets
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets
│  ├──pages
│  │  ├──Course.ets                             // 课表页
│  │  ├──FriendList.ets                         // 好友列表
│  │  ├──Health.ets                             // 健康看板页
│  │  ├──index.ets                              // 起始页
│  │  ├──Login.ets                              // 登录、注册页
│  │  ├──Main.ets                               // 主页面
│  │  └──ServicePage.ets                        // 功能页面
│  ├──types
│  │  └──Types.ets
│  └──utils
│     ├──BaseRequest.ets                        // axios 请求
│     ├──CommonUtils.ets                        // 公共工具
│     ├──Logger.ets                             // 日志工具
│     └──LoginUtils.ets                         // 登录、注册工具
└──entry/src/main/resources
```
### 11.30
- 个人健康看板、课程表、好友列表、训练计划

### 11.29
- 服务页面框架

### 11.25
- 项目根目录 ohpm install @ohos/axios
- 登录注册基础功能 (utils/BaseRequest.ets: debug=true, 未测试请求后端)
### 11.23
- 登录页面 demo
### 11.18
- 添加路由配置，可在模拟器运行