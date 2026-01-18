// pages/CreateExercisePlan.ets
import { axiosAPI } from '../utils/BaseRequest';
import prompt from '@ohos.promptAction';
import { AppStorageV2 } from '@kit.ArkUI';

// 运动计划数据接口
interface ExercisePlanData {
  userId: number
  startDate: string
  endDate: string
  startTime?: string
  endTime?: string
  eventContent?: string
  weeklyPlanId?: number
  remark?: string
  completionStatus?: number
}

interface ApiResponse<T> {
  code: number
  message: string
  data?: T
}

interface ExercisePlanResponse {
  id: number
  userId: number
  startDate: string
  endDate: string
  startTime?: string
  endTime?: string
  eventContent?: string
  weeklyPlanId?: number
  remark?: string
  completionStatus: number
  createdAt: string
  updatedAt: string
}

@Builder
export function CreateExercisePlanBuilder() {
  CreateExercisePlan()
}

@Preview
@Component
struct CreateExercisePlan {
  pathStack: NavPathStack = new NavPathStack()

  // 表单数据
  @State startDate: string = this.getTodayDate()
  @State endDate: string = this.getTodayDate()
  @State startTime: string = '09:00:00'
  @State endTime: string = '10:00:00'
  @State eventContent: string = ''
  @State remark: string = ''
  @State completionStatus: number = 0
  @State isLoading: boolean = false

  // 事件类型选项
  private eventTypes: string[] = ['跑步', '游泳', '骑行', '健身', '瑜伽', '其他运动']

  // 时间选项（小时）
  private hours: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
  // 时间选项（分钟）
  private minutes: number[] = [0, 15, 30, 45]

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

          Text('创建运动计划')
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

        Scroll() {
          Column() {
            // 表单卡片
            Column() {
              // 标题
              Text('制定您的运动计划')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ bottom: 24 })
                .width('100%')
                .textAlign(TextAlign.Center)

              // 1. 事件内容
              Column() {
                Text('运动类型')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                Row() {
                  ForEach(this.eventTypes, (type: string) => {
                    Column() {
                      Text(type)
                        .fontSize(14)
                        .fontColor(this.eventContent === type ? '#FFFFFF' : '#333333')
                        .padding(8)
                    }
                    .margin({ right: 8 })
                    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                    .backgroundColor(this.eventContent === type ? '#007DFF' : '#F5F5F5')
                    .borderRadius(8)
                    .onClick(() => {
                      this.eventContent = type
                    })
                  })
                }
                .width('100%')
                .margin({ bottom: 8 })

                // 自定义输入
                TextInput({
                  placeholder: '或输入其他运动内容',
                  text: this.eventContent
                })
                  .width('100%')
                  .height(48)
                  .fontSize(16)
                  .fontColor('#333333')
                  .backgroundColor('#F8F9FA')
                  .padding({ left: 16, right: 16 })
                  .borderRadius(8)
                  .onChange((value: string) => {
                    this.eventContent = value
                  })
              }
              .width('100%')
              .margin({ bottom: 24 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 24 })

              // 2. 日期选择
              Column() {
                Text('计划日期')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                // 开始日期
                Row() {
                  Text('开始日期')
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ right: 12 })
                    .width(80)

                  TextInput({
                    placeholder: '选择开始日期',
                    text: this.startDate
                  })
                    .layoutWeight(1)
                    .height(44)
                    .fontSize(16)
                    .fontColor('#333333')
                    .backgroundColor('#F8F9FA')
                    .padding({ left: 12, right: 12 })
                    .borderRadius(8)
                    .onChange((value: string) => {
                      this.startDate = value
                    })
                }
                .width('100%')
                .margin({ bottom: 12 })

                // 结束日期
                Row() {
                  Text('结束日期')
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ right: 12 })
                    .width(80)

                  TextInput({
                    placeholder: '选择结束日期',
                    text: this.endDate
                  })
                    .layoutWeight(1)
                    .height(44)
                    .fontSize(16)
                    .fontColor('#333333')
                    .backgroundColor('#F8F9FA')
                    .padding({ left: 12, right: 12 })
                    .borderRadius(8)
                    .onChange((value: string) => {
                      this.endDate = value
                    })
                }
                .width('100%')
                .margin({ bottom: 16 })

                Text('提示：可以选择多日计划')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .margin({ bottom: 24 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 24 })

              // 3. 时间选择
              Column() {
                Text('计划时间')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                // 开始时间
                Row() {
                  Text('开始时间')
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ right: 12 })
                    .width(80)

                  TextInput({
                    placeholder: 'HH:mm:ss',
                    text: this.startTime
                  })
                    .layoutWeight(1)
                    .height(44)
                    .fontSize(16)
                    .fontColor('#333333')
                    .backgroundColor('#F8F9FA')
                    .padding({ left: 12, right: 12 })
                    .borderRadius(8)
                    .onChange((value: string) => {
                      this.startTime = value
                    })
                }
                .width('100%')
                .margin({ bottom: 12 })

                // 结束时间
                Row() {
                  Text('结束时间')
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ right: 12 })
                    .width(80)

                  TextInput({
                    placeholder: 'HH:mm:ss',
                    text: this.endTime
                  })
                    .layoutWeight(1)
                    .height(44)
                    .fontSize(16)
                    .fontColor('#333333')
                    .backgroundColor('#F8F9FA')
                    .padding({ left: 12, right: 12 })
                    .borderRadius(8)
                    .onChange((value: string) => {
                      this.endTime = value
                    })
                }
                .width('100%')
                .margin({ bottom: 16 })

                Text('格式：HH:mm:ss (24小时制)')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .margin({ bottom: 24 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 24 })

              // 4. 备注
              Column() {
                Text('备注')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                TextArea({
                  placeholder: '请输入计划备注（可选）',
                  text: this.remark
                })
                  .width('100%')
                  .height(100)
                  .fontSize(16)
                  .fontColor('#333333')
                  .backgroundColor('#F8F9FA')
                  .padding(12)
                  .borderRadius(8)
                  .maxLength(200)
                  .onChange((value: string) => {
                    this.remark = value
                  })
              }
              .width('100%')
              .margin({ bottom: 32 })

              // 保存按钮
              Button('保存计划', { type: ButtonType.Capsule })
                .width('100%')
                .height(56)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .opacity(this.validateForm() ? 1 : 0.6)
                .onClick(() => {
                  this.savePlan()
                })
                .enabled(!this.isLoading && this.validateForm())
            }
            .width('90%')
            .padding(24)
            .backgroundColor('#FFFFFF')
            .borderRadius(24)
            .shadow({
              radius: 16,
              color: '#0A000000',
              offsetX: 0,
              offsetY: 4
            })
            .margin({ top: 20 })
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .padding({ top: 12 })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
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

  // 保存计划
  private async savePlan() {
    this.isLoading = true

    try {
      const userId = 1 // TODO: 从AppStorage获取

      const planData: ExercisePlanData = {
        userId: userId,
        startDate: this.startDate,
        endDate: this.endDate,
        startTime: this.startTime || undefined,
        endTime: this.endTime || undefined,
        eventContent: this.eventContent || undefined,
        weeklyPlanId: undefined,
        remark: this.remark || undefined,
        completionStatus: this.completionStatus
      }

      console.info('保存运动计划:', planData)

      const response: ApiResponse<ExercisePlanResponse> = await axiosAPI.post('/api/single-exercise-plan/create', planData)

      if (response.code === 200) {
        prompt.showToast({
          message: '保存成功',
          duration: 2000
        })

        // 使用 pathStack 返回
        setTimeout(() => {
          this.pathStack.pop()
        }, 1500)
      } else {
        prompt.showToast({
          message: response.message || '保存失败',
          duration: 2000
        })
      }
    } catch (error) {
      console.error('保存异常:', error)
      prompt.showToast({
        message: '网络异常，请重试',
        duration: 2000
      })
    } finally {
      this.isLoading = false
    }
  }

  // 工具方法
  private getTodayDate(): string {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  // 表单验证
  private validateForm(): boolean {
    // 验证开始日期和结束日期
    if (!this.startDate || !this.endDate) {
      return false
    }

    // 验证结束日期不能早于开始日期
    const start = new Date(this.startDate)
    const end = new Date(this.endDate)
    if (end < start) {
      return false
    }

    // 验证事件内容
    if (!this.eventContent || this.eventContent.trim() === '') {
      return false
    }

    // 验证时间格式（如果提供了时间）
    const timeRegex = /^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/
    if (this.startTime && !timeRegex.test(this.startTime)) {
      return false
    }
    if (this.endTime && !timeRegex.test(this.endTime)) {
      return false
    }

    return true
  }
}