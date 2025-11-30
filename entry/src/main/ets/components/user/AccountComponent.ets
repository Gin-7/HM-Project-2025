// components/user/AccountComponent.ets
import { GlobalUserInfo } from "../../types/Types"
import { AppStorageV2 } from "@kit.ArkUI"

@Preview
@Component
export struct AccountComponent {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!

  @State userName: string = this.userInfo.userName
  @State collegeName: string = "计算机学院"
  @State healthScore: number = 85

  build() {
    Column() {
      Column() {
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Circle({ width: 80, height: 80 })
              .fill('#E6F2FF')
            Text(this.userName.substring(0, 1))
              .fontSize(24)
              .fontColor('#007DFF')
              .fontWeight(FontWeight.Bold)
          }
          .width(80)
          .height(80)

          Column() {
            Text(this.userName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            Text(this.collegeName)
              .fontSize(16)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .margin({ left: 16 })
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 20 })

        Text(`健康评分: ${this.healthScore}`)
          .fontSize(16)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(12)
          .backgroundColor('#F8F9FA')
          .borderRadius(8)
      }
      .width('90%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin(16)

      // 功能菜单区域
      Column() {
        // 消息
        this.MenuItem('消息', '💬')
        // 我的好友
        this.MenuItem('我的好友', '👥', 'Friend')
        // 我的帖子
        this.MenuItem('我的帖子', '📝')
        // 我的小组
        this.MenuItem('我的小组', '👥')
      }
      .width('90%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  MenuItem(title: string, icon: string, route?: string) {
    Row() {
      // 图标
      Text(icon)
        .fontSize(20)
        .width(40)

      // 标题
      Text(title)
        .fontSize(16)
        .fontColor('#333333')
        .layoutWeight(1)
        .margin({ left: 12 })

      // 右侧箭头
      Text('>')
        .fontSize(16)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .onClick(() => {
      console.info(`点击了: ${title}`)
      this.pathStack.pushPathByName(route!, null, false)
    })
  }
}