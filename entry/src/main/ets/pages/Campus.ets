// pages/Campus.ets
import {CanteenPage} from './Canteen'
import canteenUtils from '../utils/CanteenUtils'
import MockUtils from '../utils/MockUtils'
import { Canteen } from '../types/canteen';

interface tabClass {
  text: string
  icon: ResourceStr
}

@Builder
export function CampusBuilder() {
  Campus()
}

@Preview
@Component
struct Campus {
  pathStack: NavPathStack = new NavPathStack()

  private tabsController: TabsController = new TabsController()
  @State currentIndex: number = 0

  tabData: tabClass[] = [
    {text: '食堂', icon: $r('app.media.startIcon')},
    {text: '场馆', icon: $r('app.media.startIcon')}
  ]

  build() {
    NavDestination() {
      Column() {
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
          ForEach(this.tabData, (item: tabClass, index: number) => {
            TabContent() {
              if (index === 0) CanteenPage()
              else if (index === 1) {
                // CanteenPage()
              }
            }
            .tabBar(this.TabBuilder(index, item))
          })
        }
        .width('100%')
        .layoutWeight(1)
        .barMode(BarMode.Fixed) // 固定模式，平均分配宽度
        .onChange((index: number) => {
          this.currentIndex = index
          console.info(`切换到标签页: ${index}`)
        })
      }
      .width('100%')
      .height('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .onResult(() => {
    })
    .title("我的校园")
  }

  // TabBuilder (需更换图片)
  @Builder
  TabBuilder(index: number, item: tabClass) {
    Column() {
      // Image(item.icon)
      //   .width(this.currentIndex === index ? 28 : 24)
      Text(item.text)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#666666')
        .padding(12)
        .backgroundColor(this.currentIndex === index ? '#E6F2FF' : '#FFFFFF')
        .borderRadius(20)
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
  }
}

