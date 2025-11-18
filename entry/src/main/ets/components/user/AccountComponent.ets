// components/user/AccountComponent.ets
@Component
export struct AccountComponent {
  @State userName: string = "张三"
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
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}