// pages/CreateExerciseRecord.ets
import { axiosAPI } from '../utils/BaseRequest';
import prompt from '@ohos.promptAction';
import { AppStorageV2 } from '@kit.ArkUI';

// 运动记录数据接口
interface ExerciseRecordData {
  userId: number
  recordDate: string
  exerciseType: string
  durationMinutes: number
  intensityLevel: string
  caloriesBurned: number | null
}

interface ApiResponse<T> {
  code: number
  msg: string
  data?: T
}

interface ExerciseRecordResponse {
  id: number
  userId: number
  recordDate: string
  exerciseType: string
  durationMinutes: number
  intensityLevel: string
  caloriesBurned: number | null
  createdAt: string
  updatedAt: string
}

@Builder
export function CreateExerciseRecordBuilder() {
  CreateExerciseRecord()
}

@Preview
@Component
struct CreateExerciseRecord {
  pathStack: NavPathStack = new NavPathStack()

  // 表单数据
  @State recordDate: string = this.getTodayDate()
  @State exerciseType: string = 'RUNNING'
  @State durationMinutes: number = 30
  @State intensityLevel: string = 'MODERATE'
  @State caloriesBurned: string = ''
  @State isLoading: boolean = false

  // 运动类型选项
  private exerciseTypes: string[] = ['跑步', '步行', '游泳', '骑行', '其他']
  private exerciseTypeValues: string[] = ['RUNNING', 'WALKING', 'SWIMMING', 'CYCLING', 'OTHER']

  // 强度等级选项
  private intensityLevels: string[] = ['低强度', '中等强度', '高强度']
  private intensityLevelValues: string[] = ['LOW', 'MODERATE', 'HIGH']

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

          Text('记录运动')
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
              Text('记录您的运动')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ bottom: 24 })
                .width('100%')
                .textAlign(TextAlign.Center)

              // 1. 运动类型
              Column() {
                Text('运动类型')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                Scroll() {
                  Row() {
                    ForEach(this.exerciseTypes, (type: string, index: number) => {
                      Column() {
                        Text(type)
                          .fontSize(14)
                          .fontColor(this.exerciseType === this.exerciseTypeValues[index] ? '#FFFFFF' : '#333333')
                          .padding(8)
                      }
                      .width(72)
                      .height(72)
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                      .backgroundColor(this.exerciseType === this.exerciseTypeValues[index] ? '#007DFF' : '#F5F5F5')
                      .borderRadius(12)
                      .onClick(() => {
                        this.exerciseType = this.exerciseTypeValues[index]
                      })
                      .margin({ right: 12 })
                    })
                  }
                  .padding({ left: 4, right: 4 })
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
              }
              .width('100%')
              .margin({ bottom: 32 })
              .padding({ bottom: 16 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 32 })

              // 2. 运动时长
              Column() {
                Text('运动时长（分钟）')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 20 })

                Row() {
                  Column() {
                    Text('-')
                      .fontSize(32)
                      .fontColor('#007DFF')
                      .fontWeight(FontWeight.Bold)
                  }
                  .width(56)
                  .height(56)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#F0F8FF')
                  .borderRadius(28)
                  .onClick(() => {
                    if (this.durationMinutes > 5) {
                      this.durationMinutes -= 5
                    }
                  })

                  Column() {
                    Text(`${this.durationMinutes}`)
                      .fontSize(36)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#333333')

                    Text('分钟')
                      .fontSize(14)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                  }
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)

                  Column() {
                    Text('+')
                      .fontSize(32)
                      .fontColor('#007DFF')
                      .fontWeight(FontWeight.Bold)
                  }
                  .width(56)
                  .height(56)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('#F0F8FF')
                  .borderRadius(28)
                  .onClick(() => {
                    if (this.durationMinutes < 300) {
                      this.durationMinutes += 5
                    }
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .width('100%')
              .margin({ bottom: 32 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 32 })

              // 3. 强度等级
              Column() {
                Text('强度等级')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                Column() {
                  ForEach(this.intensityLevels, (level: string, index: number) => {
                    Row() {
                      Column() {
                        Circle({ width: 8, height: 8 })
                          .fill(this.intensityLevel === this.intensityLevelValues[index] ? '#007DFF' : '#E8E8E8')
                      }
                      .width(20)
                      .height(56)
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)

                      Text(level)
                        .fontSize(16)
                        .fontColor(this.intensityLevel === this.intensityLevelValues[index] ? '#007DFF' : '#333333')
                        .fontWeight(this.intensityLevel === this.intensityLevelValues[index] ? FontWeight.Medium : FontWeight.Normal)
                        .layoutWeight(1)

                      if (this.intensityLevel === this.intensityLevelValues[index]) {
                        Text('✓')
                          .fontSize(16)
                          .fontColor('#007DFF')
                          .fontWeight(FontWeight.Bold)
                          .margin({ right: 8 })
                      }
                    }
                    .width('100%')
                    .height(56)
                    .backgroundColor(this.intensityLevel === this.intensityLevelValues[index] ? '#F0F8FF' : '#FFFFFF')
                    .borderRadius(12)
                    .padding({ left: 12, right: 12 })
                    .border({
                      width: this.intensityLevel === this.intensityLevelValues[index] ? 1 : 0,
                      color: '#007DFF',
                      style: BorderStyle.Solid
                    })
                    .onClick(() => {
                      this.intensityLevel = this.intensityLevelValues[index]
                    })
                    .margin({ bottom: 8 })
                  })
                }
                .width('100%')
              }
              .width('100%')
              .margin({ bottom: 32 })

              Divider()
                .strokeWidth(1)
                .color('#E8E8E8')
                .margin({ bottom: 32 })

              // 4. 消耗卡路里（改为纯手动输入）
              Column() {
                Text('消耗卡路里（kcal）')
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 12 })

                Row() {
                  TextInput({
                    placeholder: '请输入消耗的卡路里数',
                    text: this.caloriesBurned
                  })
                    .layoutWeight(1)
                    .height(56)
                    .fontSize(18)
                    .fontColor('#333333')
                    .backgroundColor('#F8F9FA')
                    .padding({ left: 16, right: 16 })
                    .borderRadius(12)
                    .type(InputType.Number)
                    .maxLength(6)
                    .onChange((value: string) => {
                      const numericValue = value.replace(/[^\d]/g, '')
                      this.caloriesBurned = numericValue
                    })

                  Text('kcal')
                    .fontSize(16)
                    .fontColor('#666666')
                    .margin({ left: 12 })
                }

                Text('请根据实际消耗填写卡路里数值')
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 8 })
              }
              .width('100%')
              .margin({ bottom: 40 })

              // 保存按钮
              Button('保存记录', { type: ButtonType.Capsule })
                .width('100%')
                .height(56)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .opacity(this.validateForm() ? 1 : 0.6)
                .onClick(() => {
                  this.saveRecord()
                })
                .enabled(!this.isLoading && this.validateForm())
            }
            .width('100%')
            .padding(24)
            .backgroundColor('#FFFFFF')
            .borderRadius(24)
            .shadow({
              radius: 16,
              color: '#0A000000',
              offsetX: 0,
              offsetY: 4
            })
            .margin({ top: 12, left: 16, right: 16, bottom: 24 })
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

  // 保存记录
  private async saveRecord() {
    this.isLoading = true

    try {
      const userId = 1 // TODO: 从AppStorage获取

      const caloriesNum = this.caloriesBurned.trim() ? parseInt(this.caloriesBurned) : null

      const recordData: ExerciseRecordData = {
        userId: userId,
        recordDate: this.recordDate,
        exerciseType: this.exerciseType,
        durationMinutes: this.durationMinutes,
        intensityLevel: this.intensityLevel,
        caloriesBurned: caloriesNum
      }

      console.info('保存运动记录:', recordData)

      const response: ApiResponse<ExerciseRecordResponse> = await axiosAPI.post('api/exercise', recordData)

      if (response.code === 200) {
        prompt.showToast({
          message: '保存成功',
          duration: 2000
        })

        // 使用 pathStack 返回，而不是 router.back()
        setTimeout(() => {
          this.pathStack.pop()
        }, 1500)
      } else {
        prompt.showToast({
          message: response.msg || '保存失败',
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

  private validateForm(): boolean {
    const durationValid = this.durationMinutes > 0 && this.durationMinutes <= 300

    let caloriesValid = true
    if (this.caloriesBurned.trim()) {
      const caloriesNum = parseInt(this.caloriesBurned)
      caloriesValid = !isNaN(caloriesNum) && caloriesNum > 0 && caloriesNum <= 5000
    }

    return durationValid && caloriesValid
  }
}