// components/common/AdSwiper.ets
import {AdItem} from '../../types/Types'
@Component
export struct AdSwiper {
  @Link currentAdIndex: number
  private swiperController: SwiperController = new SwiperController()
  private adTimer: number = 0

  private adList: Array<AdItem> = [
    { id: 1, title: "健康资讯", bgColor: "#E3F2FD", content: "最新健康知识分享" },
    { id: 2, title: "活动推广", bgColor: "#E8F5E8", content: "健康挑战赛火热进行中" },
    { id: 3, title: "新品推荐", bgColor: "#FFF3E0", content: "智能手环新品上市" },
    { id: 4, title: "健康提醒", bgColor: "#FCE4EC", content: "记得按时测量血压" }
  ]

  aboutToAppear() {
    this.startAutoScroll()
  }

  aboutToDisappear() {
    if (this.adTimer) {
      clearInterval(this.adTimer)
    }
  }

  private startAutoScroll() {
    this.adTimer = setInterval(() => {
      this.currentAdIndex = (this.currentAdIndex + 1) % this.adList.length
      this.swiperController.showNext()
    }, 3000)
  }

  build() {
    Swiper(this.swiperController) {
      ForEach(this.adList, (item: AdItem) => {
        Column() {
          Row() {
            Column() {
              Text(item.title)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
              Text(item.content)
                .fontSize(14)
                .fontColor('#666666')
                .margin({ top: 4 })
            }
            .layoutWeight(1)
          }
          .width('100%')
          .padding(16)

          Row() {
            ForEach(this.adList, (adItem: AdItem, index: number) => {
              Circle({ width: 8, height: 8 })
                .fill(index === this.currentAdIndex ? '#007DFF' : '#CCCCCC')
                .margin({ left: 4, right: 4 })
            })
          }
          .width('100%')
          .height(20)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 8 })
        }
        .width('100%')
        .height(100)
        .backgroundColor(item.bgColor)
        .borderRadius(12)
        .padding({ top: 8, bottom: 4 })
        .margin({ left: 16, right: 16, top: 8, bottom: 8 })
        .onClick(() => {
          console.info(`点击了广告: ${item.title}`)
        })
      })
    }
    .autoPlay(true)
    .interval(3000)
    .indicator(false)
    .loop(true)
    .duration(500)
    .width('100%')
    .height(120)
    .onChange((index: number) => {
      this.currentAdIndex = index
    })
  }
}