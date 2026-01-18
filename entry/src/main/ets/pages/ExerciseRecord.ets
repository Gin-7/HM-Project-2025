// pages/ExerciseRecord.ets
import { axiosAPI } from '../utils/BaseRequest';
import prompt from '@ohos.promptAction';
import { AppStorageV2 } from '@kit.ArkUI';
import { Exercise } from '../types/exercise'

interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

@Builder
export function ExerciseRecordBuilder() {
  ExerciseRecord()
}

@Preview
@Component
struct ExerciseRecord {
  pathStack: NavPathStack = new NavPathStack()

  @State records: Exercise[] = []
  @State isLoading: boolean = false

  // 运动类型显示名称映射
  private exerciseTypeNames: Record<string, string> = {
    'RUNNING': '跑步',
    'WALKING': '步行',
    'SWIMMING': '游泳',
    'CYCLING': '骑行',
    'OTHER': '其他'
  }

  // 强度等级显示名称映射
  private intensityLevelNames: Record<string, string> = {
    'LOW': '低强度',
    'MODERATE': '中等强度',
    'HIGH': '高强度'
  }

  // 获取强度颜色
  private getIntensityColor(level: string): string {
    const colors: Record<string, string> = {
      'LOW': '#52C41A',
      'MODERATE': '#FAAD14',
      'HIGH': '#F5222D'
    }
    return colors[level] || '#666666'
  }

  // 获取图标
  private getExerciseIcon(type: string): string {
    const icons: Record<string, string> = {
      'RUNNING': '🏃',
      'WALKING': '🚶',
      'SWIMMING': '🏊',
      'CYCLING': '🚴',
      'OTHER': '🏅'
    }
    return icons[type] || '🏅'
  }

  aboutToAppear() {
    this.loadRecords()
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部导航栏
        Row() {
          Text('←')
            .fontSize(20)
            .fontColor('#007DFF')
            .onClick(() => {
              this.pathStack.pop()
            })

          Text('运动记录')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ left: 12 })
            .layoutWeight(1)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .alignItems(VerticalAlign.Center)
        .zIndex(1)

        // 记录列表区域
        Column() {
          if (this.isLoading && this.records.length === 0) {
            // 加载中
            Column() {
              LoadingProgress()
                .width(40)
                .height(40)
                .color('#007DFF')

              Text('加载中...')
                .fontSize(14)
                .fontColor('#999999')
                .margin({ top: 12 })
            }
            .width('100%')
            .height(400)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else if (this.records.length === 0) {
            // 空状态
            Column() {
              Text('暂无运动记录')
                .fontSize(16)
                .fontColor('#666666')
                .margin({ bottom: 8 })

              Text('点击下方按钮添加第一条记录')
                .fontSize(14)
                .fontColor('#999999')
            }
            .width('100%')
            .height(400)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 记录列表
            Scroll() {
              Column() {
                ForEach(this.records, (record: Exercise) => {
                  this.buildRecordItem(record)
                })
              }
              .width('100%')
              .padding({ top: 8, bottom: 80 }) // 为底部按钮留出空间
            }
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Off)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')

        // 底部固定添加按钮
        Column() {
          Button('+ 添加运动记录', { type: ButtonType.Normal })
            .width('100%')
            .height(56)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor('#007DFF')
            .borderRadius(0)
            .onClick(() => {
              // 跳转到创建页面 - 使用 pathStack
              this.pathStack.pushPathByName('CreateExerciseRecord', null, false)
            })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .shadow({
          radius: 8,
          color: '#1A000000',
          offsetX: 0,
          offsetY: -2
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .onResult(() => {
      this.loadRecords()
    })
    .hideTitleBar(true)
  }

  @Builder
  buildRecordItem(record: Exercise) {
    Column() {
      Row() {
        // 左侧：图标
        Column() {
          Text(this.getExerciseIcon(record.exerciseType))
            .fontSize(24)
        }
        .width(48)
        .height(48)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#F0F8FF')
        .borderRadius(24)

        // 中间：信息
        Column() {
          Row() {
            Text(this.exerciseTypeNames[record.exerciseType] || record.exerciseType)
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            if (record.caloriesBurned) {
              Text(`${record.caloriesBurned} kcal`)
                .fontSize(14)
                .fontColor('#FF6B6B')
                .fontWeight(FontWeight.Medium)
            }
          }
          .width('100%')
          .margin({ bottom: 4 })

          Row() {
            Text(`${record.durationMinutes}分钟`)
              .fontSize(14)
              .fontColor('#666666')

            Blank()

            Text(this.intensityLevelNames[record.intensityLevel!] || record.intensityLevel)
              .fontSize(12)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor(this.getIntensityColor(record.intensityLevel!))
              .borderRadius(4)
          }
          .width('100%')

          Text(record.recordDate)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
            .width('100%')
        }
        .margin({ left: 12 })
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .margin({ bottom: 8, left: 12, right: 12 })
    .borderRadius(12)
    .shadow({
      radius: 2,
      color: '#0A000000',
      offsetX: 0,
      offsetY: 1
    })
  }

  // 加载记录
  private async loadRecords() {
    this.isLoading = true

    try {
      const userId = 1 // TODO: 从AppStorage获取
      const response: ApiResponse<Exercise[]> = await axiosAPI.get(`api/exercise/last-n-days?userId=${userId}&days=${7}`)

      if (response.code === 200 && response.data) {
        // 按日期倒序排列（最新的在前面）
        this.records = response.data.sort((a, b) =>
        new Date(b.recordDate).getTime() - new Date(a.recordDate).getTime()
        )
      } else {
        prompt.showToast({
          message: response.msg || '加载失败',
          duration: 2000
        })
      }
    } catch (error) {
      console.error('加载异常:', error)
    } finally {
      this.isLoading = false
    }
  }
}