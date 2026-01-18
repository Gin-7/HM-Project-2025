import { PageTitle } from '../components/common/PageTitle';
import { Health } from '../types/health'
import HealthUtils from '../utils/HealthUtils';
import {PostItem,AdItem, GlobalUserInfo, HealthData } from '../types/Types'
import { AppStorageV2 } from '@kit.ArkUI';

let userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!

// 时间范围枚举
enum TimeRange {
  WEEK = 7,
  MONTH = 30,
  HALF_YEAR = 180,
  YEAR = 365
}

interface RecordItem {
  health: Health
  expanded: boolean;
}

@Builder
export function HealthRecordBuilder() {
  HealthRecordPage()
}

@Preview
@Component
struct HealthRecordPage {
  pathStack: NavPathStack = new NavPathStack()
  @State records: RecordItem[] = [];
  @State isLoading: boolean = false;
  @State selectedRange: TimeRange = TimeRange.WEEK;
  private userId: number = userInfo.userId;

  aboutToAppear() {
    this.fetchRecords();
  }

  private async fetchRecords() {
    const days = this.selectedRange;
    this.isLoading = true;
    const res = await HealthUtils.getRcdLastN(this.userId, days)
    this.records = res!.map((item: Health) => ({ health: item, expanded: false } as RecordItem));
    this.isLoading = false;
  }

  private toggleExpand(index: number) {
    this.records = this.records.map((record, i) =>
    i === index ? { health: record.health, expanded: !record.expanded } as RecordItem : record
    );
  }

  build() {
    NavDestination() {
      PageTitle({ title: '健康记录' })

      Column() {
        // 时间范围选择按钮
        Row() {
          this.daysButton('7天', TimeRange.WEEK)
          Blank().width(12)
          this.daysButton('30天', TimeRange.MONTH)
          Blank().width(12)
          this.daysButton('半年', TimeRange.HALF_YEAR)
          Blank().width(12)
          this.daysButton('一年', TimeRange.YEAR)
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ bottom: 16 })

        // 内容区域
        if (this.isLoading) {
          LoadingProgress()
            .width(60)
            .margin({ top: 50 })
        } else if (this.records.length === 0) {
          Text('暂无健康记录')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 50 })
        } else {
          List({ space: 12 }) {
            ForEach(this.records, (record: RecordItem, index: number) => {
              ListItem() {
                Column() {
                  // 摘要行（始终显示）
                  Row() {
                    Text(record.health.recordDate)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)

                    Text(`步数: ${record.health.steps}`)
                    Text(`心率: ${record.health.heartRate} bpm`)
                    Text(record.expanded ? '收起' : '展开')
                      .fontColor('#2B69FF')
                      .fontSize(12)
                  }
                  .width('100%')
                  .padding({ top: 8, bottom: 8 })
                  .onClick(() => this.toggleExpand(index))

                  // 详情区域（条件渲染）
                  if (record.expanded) {
                    Column() {
                      GridRow({ columns: 4 }) {
                        this.renderDetailItem('血氧', `${record.health.bloodOxygen}%`)
                        this.renderDetailItem('血糖', `${record.health.bloodGlucose} mmol/L`)
                        this.renderDetailItem('体重', `${record.health.weight} kg`)
                        this.renderDetailItem('身高', `${record.health.height} cm`)
                        this.renderDetailItem('收缩压', `${record.health.systolicBp} mmHg`)
                        this.renderDetailItem('舒张压', `${record.health.diastolicBp} mmHg`)
                        this.renderDetailItem('睡眠', `${record.health.sleepDuration}h`)
                        this.renderDetailItem('深睡', `${record.health.deepSleep}h`)
                        this.renderDetailItem('浅睡', `${record.health.lightSleep}h`)
                        this.renderDetailItem('压力', `${record.health.stressLevel}`)
                        this.renderDetailItem('活力', `${record.health.vitality}`)
                      }
                      .width('100%')
                      .margin({ top: 12 })
                    }
                    .padding({ top: 12, bottom: 16 })
                    .border({
                      width: 1,
                      style: BorderStyle.Dashed,
                      color: '#ddd'
                    })
                  }
                }
                .padding(16)
                .borderRadius(12)
                .backgroundColor('#f9f9f9')
                .onClick(() => this.toggleExpand(index)) // 整个卡片可点击
              }
            })
          }
          .width('90%')
          .margin({ left: 16, right: 16 })
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ top: 10 })
      .backgroundColor('#F5F5F5')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }

  @Builder
  daysButton(title: string, range: TimeRange) {
    Button(title)
      .backgroundColor(this.selectedRange === range ? '#2B69FF' : '#E0E0E0')
      .fontColor(this.selectedRange === range ? '#FFFFFF' : '#333333')
      .fontWeight(this.selectedRange === range ? FontWeight.Medium : FontWeight.Normal)
      .borderRadius(8)
      .width(70)
      .height(40)
      .fontSize(14)
      .onClick(() => {
        if (this.selectedRange !== range) {
          this.selectedRange = range;
          this.fetchRecords();
        }
      })
  }

  @Builder
  renderDetailItem(label: string, value: string) {
    GridCol({ span: { xs: 6, sm: 4, md: 3, lg: 2 } }) {
      Column() {
        Text(label)
          .fontSize(12)
          .fontColor('#666')
          .textAlign(TextAlign.Center)
        Text(value)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding(4)
    }
  }
}