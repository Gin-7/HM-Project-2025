import { AccountComponent } from '../components/user/AccountComponent'
import {AdSwiper} from '../components/common/AdSwiper'
import {PostCard} from '../components/common/PostCard'
import {PostItem,AdItem, GlobalUserInfo, HealthData } from '../types/Types'
import {CreatePostPage} from '../components/common/CreatePostPage'
import {ServicePage} from './ServicePage'
import { AppStorageV2 } from '@kit.ArkUI'

let userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo(-1, ''))!

interface stateItem {
  label: string,
  value: number,
  target?: number,
  color?: string
}

@Builder
export function HealthBuilder() {
  Health()
}

@Preview
@Component
struct Health {
  pathStack: NavPathStack = new NavPathStack()

  // 模拟健康数据
  healthData: HealthData = {
    userID: userInfo.userID,
    userName: userInfo.userName,

    height: 178,
    weight: 132,
    age: 21,
    heartRate: 72,
    bloodOxygen: 98,        // 血氧
    bloodPressure: 125,     // 血压
    bloodGlucose: 5.2,      // 血糖
    sleepDuration: 9,

    calories: 1800,
    steps: 8500,
    exerciseDuration: 45    // min
  }

  states: stateItem[] = [
    { label: '卡路里', value: this.healthData.calories, target: this.healthData.calories + 2000, color: '#FF6B6B' },
    { label: '步数', value: this.healthData.steps, target: this.healthData.steps + 8000, color: '#FF6B6B' },
    { label: '运动时长', value: this.healthData.exerciseDuration, target: this.healthData.exerciseDuration + 60, color: '#FF6B6B' }
  ]

  body: stateItem[] = [
    { label: "体重(kg)", value: this.healthData.weight },
    { label: "身高(cm)", value: this.healthData.height },
    { label: "心率(次/分)", value: this.healthData.heartRate },
    { label: "血氧(%)", value: this.healthData.bloodOxygen },
    { label: "血压", value: this.healthData.bloodPressure },
    { label: "血糖(mmol/L)", value: this.healthData.bloodGlucose },
    { label: "睡眠(小时)", value: this.healthData.sleepDuration }
  ]

  build() {
    NavDestination() {
      Column() {
        // 标题
        Stack({alignContent: Alignment.Start}) {
          Text("个人健康看板")
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
        }.width('100%').backgroundColor(Color.White).padding(16)

        // 第一部分：运动数据（进度条+数字）
        Column() {
          ForEach(this.states, (item: stateItem, index: number) => {
            Row() {
              Text(item.label)
                .width('25%')
                .fontSize(16)
                .fontColor('#333')
                .textAlign(TextAlign.Start)

              Progress({value: item.value, total: item.target, type: ProgressType.Linear})
                .width('50%')
                .style({ strokeWidth: 12 })

              // 数值：当前/目标
              Text(`${item.value}`)   // Text(`${item.value}/${item.target}`)
                .fontSize(14)
                .fontColor('#666')
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.End)
                .width('25%')
            }
            .width('100%')
            .padding({ top: 8, bottom: 8 })
            .alignItems(VerticalAlign.Center)
          })
        }
        .width('90%')
        .margin({top: 16})
        .padding(12)
        .backgroundColor('#ffffffff')
        .borderRadius(24)


        // 第二部分：生理指标（卡片网格）
        Column() {
          Text("生理指标").fontSize(18).fontWeight(FontWeight.Bold).width('100%');
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
            ForEach(this.body, (item: stateItem) => {
              // 指标卡片
              Column({ space: 5 }) {
                Text(item.label).fontSize(14).fontColor("#999").margin({ bottom: 4 });
                Text(`${item.value}`).fontSize(16).fontWeight(FontWeight.Bold);
              }.width('46%').margin(4).padding({ top: 8, bottom: 8 }).backgroundColor("#FFFFFF").borderRadius(8)
            })
          }
          .margin({ top: 8 })
        }
        .width('90%')
        .margin({ top: 16 })
        .padding({ top: 16, bottom: 16, left: 8, right: 8 })
        .backgroundColor('#ffffffff')
        .borderRadius(24)
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

}
