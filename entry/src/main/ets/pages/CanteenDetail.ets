// pages/CanteenDetail.ets
import CanteenUtils from '../utils/CanteenUtils';
import type { Canteen, CanteenParams } from '../types/canteen';
import router from '@ohos.router';
import { AppStorageV2 } from '@kit.ArkUI';
import MockUtils from '../utils/MockUtils';
import { PageTitle } from '../components/common/PageTitle'

@Builder
export function CanteenDetailBuilder() {
  CanteenDetail()
}

@Preview
@Component
struct CanteenDetail {
  @State pathStack: NavPathStack = new NavPathStack()

  @State canteen: Canteen | null = null
  canteenId: number = 1;

  private async deleteCanteen() {
    if (this.canteenId) {
      const success = await CanteenUtils.deleteCanteen(this.canteenId);
      if (success) {
        this.pathStack.pop()
      }
    }
  }

  private async updateCanteen() {
    this.canteen = await CanteenUtils.getCanteenById(this.canteenId)
  }

  build() {
    NavDestination() {
      Column() {
        PageTitle({ title: this.canteen?.canteenName })

        if (this.canteen) {
          Column() {
            Text(this.canteen.canteenName)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20 })

            if (this.canteen.campus) {
              Text(`校区：${this.canteen.campus}`).fontSize(16).margin({ top: 8 })
            }
            if (this.canteen.location) {
              Text(`位置：${this.canteen.location}`).fontSize(16).margin({ top: 4 })
            }
            if (this.canteen.businessHours) {
              Text(`营业时间：${this.canteen.businessHours}`).fontSize(16).margin({ top: 4 })
            }
            if (this.canteen.description) {
              Text(this.canteen.description).fontSize(16).margin({ top: 12 })
            }

            // 操作按钮
            Row() {
              Button('编辑')
                .layoutWeight(1)
                .onClick(() => {
                  const params: CanteenParams = { canteen: this.canteen! }
                  this.pathStack.pushPathByName('EditCanteen', params, false)
                })
              Blank().width(16)

              Button('删除')
                .layoutWeight(1)
                .backgroundColor('#FF6B6B')
                .fontColor(Color.White)
                .onClick(() => this.deleteCanteen())
            }
            .width('100%')
            .margin({ top: 30 })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(16)
        } else {
          Text('加载中...')
            .fontColor('#999')
            .margin({ top: 50 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .onReady((context: NavDestinationContext) => {
      const params: CanteenParams = context.pathInfo.param as CanteenParams;
      this.canteen = params?.canteen;
      this.canteenId = this.canteen.id;
      this.pathStack = context.pathStack
    })
    .onResult(() => {
      this.updateCanteen()
    })
    .hideTitleBar(true)
  }
}