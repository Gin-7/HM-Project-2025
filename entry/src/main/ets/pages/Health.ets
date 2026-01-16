import { AccountComponent } from '../components/user/AccountComponent'
import {AdSwiper} from '../components/common/AdSwiper'
import {PostCard} from '../components/common/PostCard'
import {PostItem,AdItem, GlobalUserInfo, HealthData } from '../types/Types'
import {CreatePostPage} from '../components/common/CreatePostPage'
import {ServicePage} from './ServicePage'
import { AppStorageV2 } from '@kit.ArkUI'
import { HealthRes, StepsRes } from '../api/types'
import HealthUtils from '../utils/HealthUtils'
import AIUtils from '../utils/AIUtils'
import MockUtils from '../utils/MockUtils'


let userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!

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
  today: Date = new Date();
  dayOfWeek: number = this.today.getDay();

  healthRcd: HealthRes | null = null;
  weeklySteps: StepsRes[] | null = null;
  mock: Boolean = false;
  @State states: stateItem[] = [];
  @State body: stateItem[] = [];

  @State showWeeklySteps: boolean = false;
  toggleShowWeeklySteps = () => {
    this.showWeeklySteps = !this.showWeeklySteps;
  }

  @State aiSuggestion: string = '';
  @State isAiLoading: boolean = false;
  @State showAiResult: boolean = false;


  private async fetchLatestHealthRecord() {
    this.healthRcd = await HealthUtils.getRcdLatest(userInfo.userId);
  }
  private async fetchStepsLastWeek() {
    this.weeklySteps = await HealthUtils.getSteps(userInfo.userId);
  }

  private async fetchAiSuggestion() {
    if (!this.healthRcd) return;
    this.isAiLoading = true;
    this.aiSuggestion = '正在分析您的健康数据...';
    this.showAiResult = true;
    this.aiSuggestion = await AIUtils.getAISuggestion(this.healthRcd);
    this.isAiLoading = false;
  }

  async aboutToAppear() {
    await this.fetchLatestHealthRecord();
    if (this.healthRcd == null) {
      this.mock = true
      this.healthRcd = MockUtils.mockHealthRecord()
    }
    await this.fetchStepsLastWeek();
    if (this.weeklySteps == null) {
      this.mock = true
      this.weeklySteps = MockUtils.mockWeeklySteps()
    }
    this.states = [
      { label: '步数', value: this.healthRcd.steps, target: this.healthRcd.steps + 8000, color: '#FF6B6B' },
      { label: '睡眠时长', value: this.healthRcd.sleepDuration, target: this.healthRcd.sleepDuration + 1, color: '#FF6B6B' }
    ]
    this.body = [
      { label: "体重(kg)", value: this.healthRcd.weight },
      { label: "身高(cm)", value: this.healthRcd.height },
      { label: "心率(次/分)", value: this.healthRcd.heartRate },
      { label: "血氧(%)", value: this.healthRcd.bloodOxygen },
      { label: "血糖(mmol/L)", value: this.healthRcd.bloodGlucose },
      { label: "睡眠(小时)", value: this.healthRcd.sleepDuration },
      { label: "深度睡眠(小时)", value: this.healthRcd.deepSleep },
      { label: "浅度睡眠(小时)", value: this.healthRcd.lightSleep },
      { label: "收缩压 (mmHg)", value: this.healthRcd.systolicBp },
      { label: "舒张压 (mmHg)", value: this.healthRcd.diastolicBp },
      { label: "压力水平 (0-100)", value: this.healthRcd.stressLevel },
      { label: "活力值 (0-100)", value: this.healthRcd.vitality },
    ]
  }


  build() {
    NavDestination() {
      // 标题
      Stack({ alignContent: Alignment.Start }) {
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

      Scroll() {
        Column() {
          // 第一部分：运动数据（进度条+数字）
          Column() {
            ForEach(this.states, (item: stateItem, index: number) => {
              Row() {
                Text(item.label)
                  .width('25%')
                  .fontSize(16)
                  .fontColor('#333')
                  .textAlign(TextAlign.Start)

                Progress({ value: item.value, total: item.target, type: ProgressType.Linear })
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

            if (this.showWeeklySteps) {
              Row() {
                ForEach(this.weeklySteps, (item: StepsRes, index: number) => {
                  Column() {
                    Text(item.date)
                      .width('75%')
                      .fontSize(10)
                      .fontColor('#333')
                      .textAlign(TextAlign.Center)

                    Progress({ value: item.steps, total: item.steps + 8000, type: ProgressType.Ring })
                      .width('80%')
                      .style({ strokeWidth: 6 })
                      .margin({ top: 2, bottom: 2 })

                    Text(`${item.steps}步`)
                      .fontSize(10)
                      .fontColor('#666')
                      .fontWeight(FontWeight.Bold)
                      .textAlign(TextAlign.Center)
                  }
                  .layoutWeight(1) // 均分父容器宽度
                  .alignItems(HorizontalAlign.Center)
                })
              }
              .width('100%')
              .margin({ top: 4, bottom: 4 })
              .padding(4)
              .backgroundColor('#ffffffff')
              .borderRadius(24)
            }

            Text(this.showWeeklySteps ? '收起' : '过去一周')
              .fontSize(12)
              .fontColor('#6e6e6e')
              .width('100%')
              .textAlign(TextAlign.End)
              .margin({ right: 4 })
              .onClick(() => this.toggleShowWeeklySteps())
          }
          .width('90%')
          .margin({ top: 16 })
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
                }
                .width('46%')
                .margin(4)
                .padding({ top: 8, bottom: 8 })
                .backgroundColor("#FFFFFF")
                .borderRadius(8)
              })
            }
            .margin({ top: 8 })
          }
          .width('90%')
          .margin({ top: 16 })
          .padding({ top: 16, bottom: 16, left: 8, right: 8 })
          .backgroundColor('#ffffffff')
          .borderRadius(24)

          // 第三部分：ai
          Column() {
            Button('💡 获取 AI 健康建议')
              .width('80%')
              .height(40)
              .fontSize(16)
              .fontColor('#FFFFFF')
              .backgroundColor('#007DFF')
              .borderRadius(20)
              .onClick(() => {
                this.fetchAiSuggestion();
              })

            if (this.showAiResult) {
              Divider().margin(16)
              Column() {
                if (this.isAiLoading) {
                  LoadingProgress()
                    .width(30)
                    .height(30)
                    .color('#007DFF')
                }
                Text(this.aiSuggestion)
                  .fontSize(15)
                  .fontColor('#333')
                  .textAlign(TextAlign.Center)
                  .padding(16)
                  .backgroundColor('#F9F9FF')
                  .borderRadius(12)
                  .width('100%')
              }
              .width('90%')
              .margin({ top: 8, bottom: 8 })
            }
          }
          .width('100%')
          .margin({ top: 24, bottom: 24 })
          .padding({ bottom: 24 })
        }
        .width('100%')
        .backgroundColor('#F5F5F5')
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .height('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }

}
