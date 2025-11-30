// FriendList.ets
import router from '@ohos.router';

@Entry
@Component
struct FriendList {
  @State searchText: string = ''
  @State showSearchPage: boolean = false
  @State friends: FriendItem[] = [
    { id: 1, name: '张三', account: 'zhangsan', avatar: '', status: '在线', lastActive: '刚刚' },
    { id: 2, name: '李四', account: 'lisi', avatar: '', status: '在线', lastActive: '2分钟前' },
    { id: 3, name: '王五', account: 'wangwu', avatar: '', status: '离线', lastActive: '1小时前' },
    { id: 4, name: '赵六', account: 'zhaoliu', avatar: '', status: '在线', lastActive: '5分钟前' }
  ]
  @State searchResults: FriendItem[] = []

  build() {
    Column() {
      // 根据状态显示不同的页面
      if (this.showSearchPage) {
        // 搜索页面 - 完全独立的页面
        this.SearchPage()
      } else {
        // 好友列表页面
        this.FriendListPage()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  FriendListPage() {
    Column() {
      // 顶部导航栏 - 只在好友列表页面显示
      Row() {
        Text('←')
          .fontSize(20)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back()
          })

        Text('我的好友')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 12 })

        // 搜索按钮
        Text('搜索')
          .fontSize(14)
          .fontColor('#007DFF')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor('#E6F2FF')
          .borderRadius(16)
          .margin({ left: 12 })
          .onClick(() => {
            this.showSearchPage = true
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)

      // 好友列表
      if (this.friends.length > 0) {
        Scroll() {
          Column() {
            ForEach(this.friends, (friend: FriendItem) => {
              this.FriendItem(friend)
            })
          }
          .width('100%')
          .padding({ bottom: 20 })
        }
        .layoutWeight(1)
      } else {
        // 空状态
        Column() {
          Text('👥')
            .fontSize(48)
            .margin({ bottom: 16 })
          Text('还没有好友')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ bottom: 8 })
          Text('快去添加好友吧')
            .fontSize(14)
            .fontColor('#CCCCCC')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
      }
    }
  }

  @Builder
  SearchPage() {
    Column() {
      // 搜索页面独立的导航栏
      Row() {
        Text('←')
          .fontSize(20)
          .fontColor('#007DFF')
          .onClick(() => {
            this.showSearchPage = false
            this.searchText = ''
            this.searchResults = []
          })

        Text('搜索好友')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 12 })
          .layoutWeight(1)

        // 搜索页面也可以有额外的操作按钮
        Text('取消')
          .fontSize(14)
          .fontColor('#007DFF')
          .onClick(() => {
            this.showSearchPage = false
            this.searchText = ''
            this.searchResults = []
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)

      // 搜索栏
      Row() {
        Text('🔍')
          .fontSize(18)
          .fontColor('#666666')
          .margin({ right: 12 })

        TextInput({ placeholder: '输入好友账号或昵称', text: this.searchText })
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .fontColor('#333333')
          .backgroundColor('#F8F9FA')
          .padding(12)
          .borderRadius(22)
          .onChange((value: string) => {
            this.searchText = value
            this.handleSearch(value)
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)

      // 搜索结果
      Scroll() {
        Column() {
          if (this.searchText.length === 0) {
            // 搜索提示
            this.SearchTips()
          } else if (this.searchResults.length === 0) {
            // 无结果
            this.EmptyResult()
          } else {
            // 搜索结果
            ForEach(this.searchResults, (user: FriendItem) => {
              this.SearchResultItem(user)
            })
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .padding({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  FriendItem(friend: FriendItem) {
    Row() {
      // 头像
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 50, height: 50 })
          .fill('#E6F2FF')
        Text(friend.name.substring(0, 1))
          .fontSize(18)
          .fontColor('#007DFF')
          .fontWeight(FontWeight.Bold)
      }
      .width(50)
      .height(50)

      // 好友信息
      Column() {
        Text(friend.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Text(`账号: ${friend.account}`)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      // 状态和操作
      Column() {
        // 状态
        Row() {
          Circle({ width: 8, height: 8 })
            .fill(friend.status === '在线' ? '#52C41A' : '#CCCCCC')
            .margin({ right: 4 })
          Text(friend.status)
            .fontSize(12)
            .fontColor(friend.status === '在线' ? '#52C41A' : '#999999')
        }

        Text(friend.lastActive)
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
    .onClick(() => {
      this.viewFriendProfile(friend)
    })
  }

  @Builder
  SearchTips() {
    Column() {
      Text('搜索提示')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ bottom: 16 })
        .width('100%')
        .padding({ left: 16, right: 16 })

      Column() {
        Text('• 输入好友的账号或昵称进行搜索')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })
        Text('• 账号通常是手机号或自定义ID')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })
        Text('• 支持模糊搜索，输入部分信息即可')
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16 })
    }
    .width('100%')
    .margin({ top: 20 })
  }

  @Builder
  EmptyResult() {
    Column() {
      Text('🔍')
        .fontSize(48)
        .margin({ bottom: 16 })
      Text('未找到相关用户')
        .fontSize(16)
        .fontColor('#999999')
        .margin({ bottom: 8 })
      Text('请检查账号或昵称是否正确')
        .fontSize(14)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .margin({ top: 100 })
  }

  @Builder
  SearchResultItem(user: FriendItem) {
    Row() {
      // 头像
      Stack({ alignContent: Alignment.Center }) {
        Circle({ width: 50, height: 50 })
          .fill('#E6F2FF')
        Text(user.name.substring(0, 1))
          .fontSize(18)
          .fontColor('#007DFF')
          .fontWeight(FontWeight.Bold)
      }
      .width(50)
      .height(50)

      // 用户信息
      Column() {
        Text(user.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Text(`账号: ${user.account}`)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      // 添加按钮
      Button('添加', { type: ButtonType.Capsule })
        .width(60)
        .height(30)
        .fontSize(12)
        .fontColor('#FFFFFF')
        .backgroundColor('#007DFF')
        .onClick(() => {
          this.addFriend(user)
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
  }

  // 搜索处理
  private handleSearch(keyword: string) {
    if (keyword.trim() === '') {
      this.searchResults = []
      return
    }

    // 模拟搜索逻辑 - 实际项目中这里调用API
    const mockUsers: FriendItem[] = [
      { id: 5, name: '测试用户1', account: 'test1', avatar: '', status: '在线', lastActive: '刚刚' },
      { id: 6, name: '测试用户2', account: 'test2', avatar: '', status: '离线', lastActive: '1天前' }
    ]

    // 简单过滤逻辑
    this.searchResults = mockUsers.filter(user =>
    user.name.includes(keyword) || user.account.includes(keyword)
    )
  }

  // 添加好友
  private addFriend(user: FriendItem) {
    console.info(`添加好友: ${user.name}`)
    // 这里调用添加好友的API
    // 添加成功后更新好友列表
    this.friends = [...this.friends, user]
    this.showSearchPage = false
    this.searchText = ''
    this.searchResults = []
  }

  // 查看好友资料
  private viewFriendProfile(friend: FriendItem) {
    console.info(`查看好友资料: ${friend.name}`)
    // 这里可以跳转到好友资料页面
  }
}

// 好友项接口
interface FriendItem {
  id: number
  name: string
  account: string
  avatar: string
  status: string
  lastActive: string
}