## 工程目录
```
├───entry/src/main/ets
│  ├──api
│  │  ├──ai.ts                                  // ai 接口
│  │  ├──canteen.ts                             // 食堂接口
│  │  ├──health.ts                              // 健康记录接口
│  │  ├──types.ts                               // 各种接口
│  │  └──user.ts                                // 用户相关 api
│  ├──components
│  │  ├──common
│  │  │  ├──AdSwiper.ets
│  │  │  ├──CreatePostPage.ets
│  │  │  ├──PageTitle.ets                       // 页面标题组件
│  │  │  ├──PostCard.ets
│  │  │  └──TrainingPlan.ets                    // 训练计划
│  │  ├──user
│  │  │  └──AccountComponent.ets
│  │  └──CanteenCard.ets                        // 食堂组件
│  ├──entryability
│  │  └──EntryAbility.ets
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets
│  ├──pages
│  │  ├──AddCanteen.ets                         // 添加食堂页面
│  │  ├──Campus.ets                             // 我的校园页（包括食堂和场馆预约）
│  │  ├──Canteen.ets                            // 食堂页
│  │  ├──CanteenDetail.ets                      // 食堂详情页
│  │  ├──Course.ets                             // 课表页
│  │  ├──EditCanteen.ets                        // 编辑食堂页面
│  │  ├──EditProfile.ets                        // 编辑个人资料
│  │  ├──FriendList.ets                         // 好友列表
│  │  ├──Health.ets                             // 健康看板页
│  │  ├──index.ets                              // 起始页
│  │  ├──Login.ets                              // 登录、注册页
│  │  ├──Main.ets                               // 主页面
│  │  ├──Settings.ets                           // 设置
│  │  └──ServicePage.ets                        // 功能页面
│  ├──types
│  │  ├──canteen.ets                            // 食堂 interface
│  │  └──Types.ets
│  └──utils
│     ├──AIUtils.ets                            // AI 工具
│     ├──BaseRequest.ets                        // axios 请求
│     ├──CanteenUtils.ets                       // 食堂工具
│     ├──CommonUtils.ets                        // 公共工具
│     ├──HealthUtils.ets                        // 健康记录工具
│     ├──Logger.ets                             // 日志工具
│     ├──LoginUtils.ets                         // 登录、注册工具
│     ├──MockUtils.ets                          // 模拟数据工具
│     └──UserInfoUtils.ets                      // 个人资料工具
└──entry/src/main/resources
```
### 1.17
- AI 相关
- 食堂

### 1.16
- 健康看板

### 1.13
- 更新个人资料

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