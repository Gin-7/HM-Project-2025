// components/CanteenCard.ets
import { Canteen, CanteenParams } from '../types/canteen';
import { AppStorageV2 } from '@kit.ArkUI';

@Preview
@Component
export struct CanteenCard {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  @Prop canteen: Canteen;

  build() {
    Column() {
      Row() {
        Text('🏫')
          .fontSize(20)
          .margin({ right: 8 })

        Column() {
          Text(this.canteen.canteenName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
            .width('100%')
            .textAlign(TextAlign.Start)

          if (this.canteen.campus) {
            Text(`校区：${this.canteen.campus}`)
              .fontSize(12)
              .fontColor('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 4 })
          }

          if (this.canteen.businessHours) {
            Text(`营业时间：${this.canteen.businessHours}`)
              .fontSize(12)
              .fontColor('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 4 })
          }

          if (this.canteen.location) {
            Text(`位置：${this.canteen.location}`)
              .fontSize(12)
              .fontColor('#666')
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 4 })
          }
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: 8, bottom: 8 })
    }
    .width('100%')
    .margin({ top: 8, bottom: 8})
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => {
      const params: CanteenParams = { canteen: this.canteen }
      this.pathStack.pushPathByName('CanteenDetail', params, false);
    })
  }
}