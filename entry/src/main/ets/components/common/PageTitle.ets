import { AppStorageV2 } from "@kit.ArkUI"

// 页面标题组件
@Preview
@Component
export struct PageTitle {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  @Prop title: string
  // title: string='标题'

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Center)
      Text('\u2039')
        .width(40)
        .height(40)
        .padding({ bottom: 4 })
        .fontSize(32)
        .fontColor('#191919')
        .onClick(() => {
          this.pathStack.pop()
        })
        .borderRadius(20)
        .textAlign(TextAlign.Center)
        .backgroundColor('#F3F3F3')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding(12)
    .margin({ bottom: 12 })
  }
}