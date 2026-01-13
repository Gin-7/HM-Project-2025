// pages/SettingsPage.ets

@Builder
export function SettingsBuilder() {
  SettingsPage()
}

@Preview
@Component
export struct SettingsPage {
  pathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Column() {
        // 标题
        Stack({alignContent: Alignment.Start}) {
          Text("设置")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Center)
          Text('←')
            .fontSize(20)
            .fontColor('#007DFF')
            .onClick(() => {
              this.pathStack.pop()
            })
        }.width('100%').backgroundColor(Color.White).padding(16).margin({bottom: 16})

        Column({ space: 16 }) {
          // 个人资料
          this.SettingItem('个人资料', '👤', () => {
            this.pathStack.pushPathByName('EditProfile', null, false);
          })

          // 其他设置项可后续添加...
          this.SettingItem('通知设置', '🔔', () => {})
          this.SettingItem('关于', 'ℹ️', () => {})
        }
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }

  @Builder
  SettingItem(title: string, icon: string, onClick: () => void) {
    Row() {
      Text(icon).fontSize(20).width(40)
      Text(title)
        .fontSize(16)
        .fontColor('#333333')
        .layoutWeight(1)
        .margin({ left: 12 })
      Text('>')
        .fontSize(16)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .onClick(onClick)
  }
}