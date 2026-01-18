import { AppStorageV2 } from "@kit.ArkUI"

@Preview
@Component
export struct ServicePage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  @State searchText: string = ''

  build() {
    Column() {
      // 搜索栏 TODO 🔍放右边
      Row() {
        Text('🔍')
          .fontSize(18)
          .fontColor('#999999')
          .margin({ right: 10 })

        TextInput({ placeholder: '搜索健康服务' })
          .layoutWeight(1)
          .height(42)
          .fontSize(15)
          .fontColor('#111111')
          .backgroundColor('#F2F4F6')
          .padding({ left: 14, right: 14 })
          .borderRadius(20)
          .shadow({
            color: 'rgba(0,0,0,0.06)',
            radius: 6,
            offsetX: 0,
            offsetY: 2
          })
          .onChange((value: string) => this.searchText = value)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)

      // 内容区域
      Scroll() {
        Column() {
          Column() {
            this.ServiceCard(
              '个人健康看板',
              '📊',
              '全面监测您的健康数据',
              ['血氧', '血压', '血糖', '体重', '心率', '睡眠'],
              'Health'    // 路由
            )
            this.ServiceCard(
              '健康课程表',
              '📅',
              '规划您的健康学习计划',
              ['运动课程', '饮食指导', '健康讲座', '康复训练'],
              'Course'
            )
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16 })

          this.QuickAccess()
          this.HealthTips()
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F9FAFB')
  }

  @Builder
  ServiceCard(title: string, icon: string, description: string, features: string[], routeName: string) {
    Column() {
      Row() {
        Text(icon).fontSize(24).margin({ right: 12 })
        Column() {
          Text(title).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#111111')
          Text(description).fontSize(14).fontColor('#555555').margin({ top: 4 })
        }.layoutWeight(1)
      }
      .width('100%')
      .margin({ bottom: 16 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(features, (feature: string) => {
          Text(feature)
            .fontSize(12)
            .fontColor('#007DFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('rgba(0,125,255,0.08)')
            .borderRadius(12)
            .margin({ right: 8, bottom: 8 })
        })
      }
      .width('100%')

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
          this.pathStack.pushPathByName(routeName, null, false)
        })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({
      color: 'rgba(0,0,0,0.08)',  // 阴影颜色
      radius: 12,                  // 模糊半径
      offsetX: 0,                  // X 方向偏移
      offsetY: 4                   // Y 方向偏移
    })
    .margin({ bottom: 20 })
    .onClick(() => console.info(`点击卡片 ${title}`))
  }

  @Builder
  HealthTips() {
    Column() {
      Row() {
        Text('💡').fontSize(18).margin({ right: 8 })
        Text('今日健康小贴士').fontSize(16).fontWeight(FontWeight.Bold).fontColor('#111111')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Column() {
        Text('• 每天保持7-8小时充足睡眠').fontSize(14).fontColor('#555555').margin({ bottom: 8 })
        Text('• 建议每天步行6000步以上').fontSize(14).fontColor('#555555').margin({ bottom: 8 })
        Text('• 多吃蔬菜水果，少油少盐').fontSize(14).fontColor('#555555')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F2F4F6')
      .borderRadius(16)
      .shadow({
        color: 'rgba(0,0,0,0.08)',  // 阴影颜色
        radius: 12,                  // 模糊半径
        offsetX: 0,                  // X 方向偏移
        offsetY: 4                   // Y 方向偏移
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 20, bottom: 16 })
  }

  @Builder
  QuickAccess() {
    Column() {
      Text('快捷功能').fontSize(16).fontWeight(FontWeight.Bold).fontColor('#111111').margin({ bottom: 12 }).width('100%')
      Row() {
        this.QuickItem('我的校园', '🏫', 'Campus')
        // this.QuickItem('健康记录', '📝')
        this.QuickItem('运动记录', '📝', 'ExerciseRecord')
        this.QuickItem('运动计划', '🏃', 'ExercisePlan')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 30 })
  }

  @Builder
  QuickItem(title: string, icon: string, route?: string) {
    Column() {
      Text(icon).fontSize(20).margin({ bottom: 8 })
      Text(title).fontSize(12).fontColor('#111111')
    }
    .width(70)
    .height(70)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({
      color: 'rgba(0,0,0,0.08)',  // 阴影颜色
      radius: 12,                  // 模糊半径
      offsetX: 0,                  // X方向偏移
      offsetY: 4                   // Y方向偏移
    })
    .onClick(() => {
      console.info(`点击了 ${title}`)
      this.pathStack.pushPathByName(route!, null, false)
    })
  }
}
