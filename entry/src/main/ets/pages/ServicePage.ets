@Preview
@Component
export struct ServicePage {
  @State searchText: string = ''

  build() {
    Column() {
      // 搜索栏
      Row() {
        Text('⌕')
          .fontSize(18)
          .fontColor('#666666')
          .margin({ right: 12 })

        TextInput({ placeholder: '搜索健康服务' })
          .layoutWeight(1)
          .height(44)
          .fontSize(16)
          .fontColor('#333333')
          .backgroundColor('#F8F9FA')
          .padding(12)
          .borderRadius(22)
          .onChange((value: string) => {
            this.searchText = value
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')  // 改为白色背景
      .alignItems(VerticalAlign.Center)

      // 主要内容区域
      Scroll() {
        Column() {
          // 主要功能卡片 - 直接显示功能卡片，去掉欢迎标题
          Column() {
            // 个人健康看板
            this.ServiceCard(
              '个人健康看板',
              '📊',
              '全面监测您的健康数据',
              ['血氧', '血压', '血糖', '体重', '心率', '睡眠'],
              '#E3F2FD'
            )

            // 课程表
            this.ServiceCard(
              '健康课程表',
              '📅',
              '规划您的健康学习计划',
              ['运动课程', '饮食指导', '健康讲座', '康复训练'],
              '#E8F5E8'
            )
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16 })  // 添加上边距

          // 健康小贴士区域
          this.HealthTips()

          // 快速入口
          this.QuickAccess()
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')  // 整体背景改为白色
  }

  @Builder
  ServiceCard(title: string, icon: string, description: string, features: string[], bgColor: string) {
    Column() {
      // 卡片头部
      Row() {
        Text(icon)
          .fontSize(24)
          .margin({ right: 12 })

        Column() {
          Text(title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Text(description)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 功能特性标签
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(features, (feature: string) => {
          Text(feature)
            .fontSize(12)
            .fontColor('#007DFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#E6F2FF')
            .borderRadius(12)
            .margin({ right: 8, bottom: 8 })
        })
      }
      .width('100%')

      // 进入按钮
      Button('进入', { type: ButtonType.Capsule })
        .width(80)
        .height(32)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#007DFF')
        .margin({ top: 16 })
        .alignSelf(ItemAlign.End)
        .onClick(() => {
          console.info(`进入${title}`)
        })
    }
    .width('100%')
    .padding(20)
    .backgroundColor(bgColor)
    .borderRadius(16)
    .margin({ bottom: 16 })
  }

  @Builder
  HealthTips() {
    Column() {
      Row() {
        Text('💡')
          .fontSize(18)
          .margin({ right: 8 })
        Text('今日健康小贴士')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Column() {
        Text('• 每天保持7-8小时充足睡眠')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })
        Text('• 建议每天步行6000步以上')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })
        Text('• 多吃蔬菜水果，少油少盐')
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F8F9FA')  // 改为浅灰色背景
      .borderRadius(12)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 20, bottom: 16 })
  }

  @Builder
  QuickAccess() {
    Column() {
      Text('快捷功能')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ bottom: 12 })
        .width('100%')

      Row() {
        this.QuickItem('紧急联系', '📞', '#FFE4E4')
        this.QuickItem('健康记录', '📝', '#E6F2FF')
        this.QuickItem('用药提醒', '💊', '#FFF0E6')
        this.QuickItem('运动计划', '🏃', '#E8F5E8')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 30 })
  }

  @Builder
  QuickItem(title: string, icon: string, bgColor: string) {
    Column() {
      Text(icon)
        .fontSize(20)
        .margin({ bottom: 8 })
      Text(title)
        .fontSize(12)
        .fontColor('#333333')
    }
    .width(70)
    .height(70)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(bgColor)
    .borderRadius(12)
    .onClick(() => {
      console.info(`点击了${title}`)
    })
  }
}