@Component
export struct ServicePage {
  build() {
    Column() {
      Text('服务内容区域')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Text('这里是健康服务页面')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F0F8FF')
  }
}