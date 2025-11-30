// TrainingPlan.ets
import router from '@ohos.router';

@Entry
@Component
struct TrainingPlan {
  @State planName: string = '我的训练计划'
  @State selectedDays: number[] = [1, 3, 5] // 1-7 周一到周日
  @State duration: number = 30 // 分钟
  @State intensity: string = '中等'
  @State exercises: ExerciseItem[] = []
  @State showExercisePicker: boolean = false

  // 训练类型数据
  private exerciseTypes: ExerciseType[] = [
    { id: 1, name: '有氧运动', icon: '🏃', color: '#FF6B6B' },
    { id: 2, name: '力量训练', icon: '💪', color: '#4ECDC4' },
    { id: 3, name: '柔韧性', icon: '🧘', color: '#45B7D1' },
    { id: 4, name: '平衡训练', icon: '⚖️', color: '#96CEB4' }
  ]

  // 具体训练项目
  private exerciseItems: ExerciseItem[] = [
    { id: 1, name: '慢跑', type: '有氧运动', duration: 20, calories: 150, icon: '🏃' },
    { id: 2, name: '游泳', type: '有氧运动', duration: 30, calories: 200, icon: '🏊' },
    { id: 3, name: '深蹲', type: '力量训练', duration: 10, calories: 80, icon: '🦵' },
    { id: 4, name: '俯卧撑', type: '力量训练', duration: 10, calories: 70, icon: '✋' },
    { id: 5, name: '瑜伽', type: '柔韧性', duration: 25, calories: 120, icon: '🧘' },
    { id: 6, name: '拉伸', type: '柔韧性', duration: 15, calories: 60, icon: '🤸' },
    { id: 7, name: '单腿站立', type: '平衡训练', duration: 10, calories: 40, icon: '🦶' }
  ]

  build() {
    Column() {
      // 顶部导航 - 极简设计
      Row() {
        Text('←')
          .fontSize(20)
          .fontColor('#2C3E50')
          .onClick(() => {
            router.back()
          })

        Text('训练计划')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2C3E50')
          .margin({ left: 12 })
          .layoutWeight(1)

        Text('保存')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .padding({ left: 20, right: 20, top: 8, bottom: 8 })
          .backgroundColor('#2C3E50')
          .borderRadius(20)
          .onClick(() => {
            this.savePlan()
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 计划名称
          this.PlanNameSection()

          // 训练天数
          this.DaySelectionSection()

          // 训练时长和强度
          this.DurationIntensitySection()

          // 训练类型选择
          this.ExerciseTypeSection()

          // 已选训练项目
          this.SelectedExercisesSection()

          // 添加训练按钮
          this.AddExerciseButton()
        }
        .width('100%')
        .padding({ bottom: 30 })
      }
      .layoutWeight(1)

      // 训练项目选择器
      if (this.showExercisePicker) {
        this.ExercisePicker()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA') // 浅灰背景，ins风
  }

  @Builder
  PlanNameSection() {
    Column() {
      Text('计划名称')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#2C3E50')
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      TextInput({ placeholder: '输入计划名称', text: this.planName })
        .width('100%')
        .height(50)
        .fontSize(16)
        .fontColor('#2C3E50')
        .backgroundColor('#FFFFFF')
        .padding(16)
        .borderRadius(12)
        .onChange((value: string) => {
          this.planName = value
        })
    }
    .width('100%')
    .padding(20)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  DaySelectionSection() {
    Column() {
      Text('训练天数')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#2C3E50')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Row() {
        ForEach([1, 2, 3, 4, 5, 6, 7], (day: number) => {
          Column() {
            Text(this.getDayShortName(day))
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.selectedDays.includes(day) ? '#FFFFFF' : '#2C3E50')
          }
          .width(40)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.selectedDays.includes(day) ? '#2C3E50' : '#F8F9FA')
          .borderRadius(20)
          .onClick(() => {
            this.toggleDaySelection(day)
          })
          .margin({ right: 8 })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(20)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  DurationIntensitySection() {
    Row() {
      // 时长选择
      Column() {
        Text('时长')
          .fontSize(14)
          .fontColor('#7F8C8D')
          .margin({ bottom: 8 })

        Row() {
          Text('-')
            .fontSize(18)
            .fontColor('#2C3E50')
            .padding(8)
            .onClick(() => {
              if (this.duration > 10) this.duration -= 5
            })

          Text(`${this.duration}分钟`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#2C3E50')
            .margin({ left: 16, right: 16 })

          Text('+')
            .fontSize(18)
            .fontColor('#2C3E50')
            .padding(8)
            .onClick(() => {
              if (this.duration < 120) this.duration += 5
            })
        }
        .alignItems(VerticalAlign.Center)
      }
      .layoutWeight(1)

      // 强度选择
      Column() {
        Text('强度')
          .fontSize(14)
          .fontColor('#7F8C8D')
          .margin({ bottom: 8 })

        Row() {
          ForEach(['低', '中等', '高'], (level: string) => {
            Text(level)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.intensity === level ? '#FFFFFF' : '#2C3E50')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor(this.intensity === level ? '#2C3E50' : '#F8F9FA')
              .borderRadius(16)
              .onClick(() => {
                this.intensity = level
              })
              .margin({ right: 8 })
          })
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding(20)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  ExerciseTypeSection() {
    Column() {
      Text('训练类型')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#2C3E50')
        .margin({ bottom: 16 })
        .alignSelf(ItemAlign.Start)

      Row() {
        ForEach(this.exerciseTypes, (type: ExerciseType) => {
          Column() {
            Text(type.icon)
              .fontSize(24)
              .margin({ bottom: 8 })
            Text(type.name)
              .fontSize(12)
              .fontColor('#2C3E50')
          }
          .width(70)
          .height(70)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#FFFFFF')
          .border({ width: 1, color: '#ECF0F1' })
          .borderRadius(12)
          .onClick(() => {
            this.filterExercisesByType(type.name)
          })
          .margin({ right: 12 })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(20)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  SelectedExercisesSection() {
    Column() {
      Row() {
        Text('已选项目')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2C3E50')
          .layoutWeight(1)

        Text(`共 ${this.exercises.length} 项`)
          .fontSize(14)
          .fontColor('#7F8C8D')
      }
      .width('100%')
      .margin({ bottom: 16 })

      if (this.exercises.length > 0) {
        ForEach(this.exercises, (exercise: ExerciseItem, index: number) => {
          this.ExerciseItem(exercise, index)
        })
      } else {
        Column() {
          Text('暂无训练项目')
            .fontSize(14)
            .fontColor('#BDC3C7')
            .margin({ bottom: 8 })
          Text('点击下方添加训练项目')
            .fontSize(12)
            .fontColor('#BDC3C7')
        }
        .width('100%')
        .padding(40)
        .backgroundColor('#F8F9FA')
        .borderRadius(12)
      }
    }
    .width('100%')
    .padding(20)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  ExerciseItem(exercise: ExerciseItem, index: number) {
    Row() {
      Text(exercise.icon)
        .fontSize(20)
        .margin({ right: 12 })

      Column() {
        Text(exercise.name)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2C3E50')
        Text(`${exercise.duration}分钟 · ${exercise.calories}卡路里`)
          .fontSize(12)
          .fontColor('#7F8C8D')
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('×')
        .fontSize(18)
        .fontColor('#E74C3C')
        .onClick(() => {
          this.removeExercise(index)
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#F8F9FA')
    .borderRadius(12)
    .margin({ bottom: 8 })
  }

  @Builder
  AddExerciseButton() {
    Row() {
      Text('+ 添加训练项目')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#2C3E50')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
    .border({ width: 1, color: '#2C3E50', style: BorderStyle.Dashed })
    .borderRadius(12)
    .margin({ top: 8 })
    .onClick(() => {
      this.showExercisePicker = true
    })
  }

  @Builder
  ExercisePicker() {
    Column() {
      // 半透明遮罩
      Column() {
        Column() {
          Text('选择训练项目')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#2C3E50')
            .margin({ bottom: 20 })

          Scroll() {
            Column() {
              ForEach(this.exerciseItems, (exercise: ExerciseItem) => {
                Row() {
                  Text(exercise.icon)
                    .fontSize(20)
                    .margin({ right: 12 })

                  Column() {
                    Text(exercise.name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#2C3E50')
                    Text(exercise.type)
                      .fontSize(12)
                      .fontColor('#7F8C8D')
                      .margin({ top: 2 })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)

                  Text('添加')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                    .backgroundColor('#2C3E50')
                    .borderRadius(12)
                    .onClick(() => {
                      this.addExercise(exercise)
                    })
                }
                .width('100%')
                .padding(16)
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .margin({ bottom: 8 })
              })
            }
          }
          .layoutWeight(1)

          Button('关闭', { type: ButtonType.Normal })
            .width('100%')
            .height(44)
            .fontSize(16)
            .fontColor('#2C3E50')
            .backgroundColor('#ECF0F1')
            .margin({ top: 16 })
            .onClick(() => {
              this.showExercisePicker = false
            })
        }
        .width('90%')
        .height('70%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(20)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#CC000000')
    }
    .width('100%')
    .height('100%')
  }

  // 工具方法
  private getDayShortName(day: number): string {
    const days = ['一', '二', '三', '四', '五', '六', '日']
    return days[day - 1]
  }

  private toggleDaySelection(day: number) {
    if (this.selectedDays.includes(day)) {
      this.selectedDays = this.selectedDays.filter(d => d !== day)
    } else {
      this.selectedDays = [...this.selectedDays, day]
    }
  }

  private filterExercisesByType(type: string) {
    this.showExercisePicker = true
    // 这里可以根据类型筛选，暂时显示所有
  }

  private addExercise(exercise: ExerciseItem) {
    this.exercises = [...this.exercises, exercise]
    this.showExercisePicker = false
  }

  private removeExercise(index: number) {
    this.exercises.splice(index, 1)
    this.exercises = [...this.exercises]
  }

  private savePlan() {
    console.info('保存训练计划:', {
      name: this.planName,
      days: this.selectedDays,
      duration: this.duration,
      intensity: this.intensity,
      exercises: this.exercises
    })
    // 这里调用保存API
    router.back()
  }
}

// 类型定义
interface ExerciseType {
  id: number
  name: string
  icon: string
  color: string
}

interface ExerciseItem {
  id: number
  name: string
  type: string
  duration: number
  calories: number
  icon: string
}