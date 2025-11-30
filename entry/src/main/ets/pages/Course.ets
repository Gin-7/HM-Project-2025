// CourseSchedule.ets
import router from '@ohos.router';

@Preview
@Component
struct CourseSchedule {
  @State courses: CourseItem[] = [
    { id: 1, day: 1, startTime: '08:00', endTime: '08:50', name: '晨间瑜伽', location: '健身房', type: '运动' },
    { id: 2, day: 1, startTime: '11:10', endTime: '12:00', name: '营养学基础', location: '线上', type: '学习' },
    { id: 3, day: 3, startTime: '14:00', endTime: '14:50', name: '有氧运动', location: '操场', type: '运动' },
    { id: 4, day: 5, startTime: '16:10', endTime: '17:00', name: '心理健康', location: '咨询室', type: '咨询' }
  ]

  @State selectedDay: number = 1 // 1-5 周一到周五
  @State showAddCourse: boolean = false

  // 时间段定义
  private timeSlots: string[] = [
    '08:00-08:50',
    '09:00-09:50',
    '10:10-11:00',
    '11:10-12:00',
    '14:00-14:50',
    '15:00-15:50',
    '16:10-17:00',
    '17:10-18:00',
    '18:30-20:20',
    '20:30-21:20',
    '21:30-22:20'
  ]


  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('←')
          .fontSize(20)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back()
          })

        Text('健康课程表')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 12 })

        // 导入和添加按钮
        Row() {
          Text('导入')
            .fontSize(14)
            .fontColor('#007DFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#E6F2FF')
            .borderRadius(16)
            .onClick(() => {
              this.importSchedule()
            })

          Text('+')
            .fontSize(18)
            .fontColor('#007DFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#E6F2FF')
            .borderRadius(16)
            .margin({ left: 8 })
            .onClick(() => {
              this.showAddCourse = true
            })
        }
        .margin({ left: 12 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)

      // 星期选择
      this.DaySelector()

      // 课程表主体
      Scroll() {
        Column() {
          // 时间轴和课程
          Row() {
            // 时间轴
            Column() {
              ForEach(this.timeSlots, (timeSlot: string) => {
                Column() {
                  Text(timeSlot.split('-')[0])
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(timeSlot.split('-')[1])
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ top: 2 })
                }
                .width(60)
                .height(80)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor('#F8F9FA')
                .border({ width: { bottom: 1 }, color: '#E5E5E5' })
              })
            }

            // 课程内容
            // 课程内容
            Scroll() {
              Column() {
                ForEach(this.timeSlots, (timeSlot: string, timeIndex: number) => {
                  // 使用三元表达式直接判断，避免变量声明
                  Row() {
                    if (this.getCourseAtTime(timeSlot, this.selectedDay)) {
                      // 有课程的情况
                      this.CourseBlock(this.getCourseAtTime(timeSlot, this.selectedDay)!)
                    } else {
                      // 空时间段
                      Column() {
                        Text('')
                      }
                      .width('100%')
                      .height(80)
                      .backgroundColor('#FFFFFF')
                      .border({ width: { bottom: 1 }, color: '#E5E5E5' })
                      .onClick(() => {
                        this.addCourseAtTime(timeSlot)
                      })
                    }
                  }
                  .width('100%')
                })
              }
            }
            .layoutWeight(1)
          }
        }
      }
      .layoutWeight(1)
      .backgroundColor('#FFFFFF')

      // 添加课程弹窗
      if (this.showAddCourse) {
        this.AddCourseDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  DaySelector() {
    Row() {
      ForEach([1, 2, 3, 4, 5], (day: number) => {
        Column() {
          Text(this.getDayName(day))
            .fontSize(14)
            .fontColor(this.selectedDay === day ? '#007DFF' : '#666666')
            .fontWeight(this.selectedDay === day ? FontWeight.Bold : FontWeight.Normal)
          Text(this.getDayDate(day))
            .fontSize(12)
            .fontColor(this.selectedDay === day ? '#007DFF' : '#999999')
            .margin({ top: 2 })
        }
        .padding(12)
        .backgroundColor(this.selectedDay === day ? '#E6F2FF' : '#F8F9FA')
        .borderRadius(8)
        .onClick(() => {
          this.selectedDay = day
        })
        .margin({ right: 8 })
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.SpaceAround)
  }

  @Builder
  CourseBlock(course: CourseItem) {
    Column() {
      Text(course.name)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(course.location)
        .fontSize(12)
        .fontColor('#FFFFFF')
        .opacity(0.9)
        .margin({ top: 2 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(course.type)
        .fontSize(10)
        .fontColor('#FFFFFF')
        .opacity(0.8)
        .margin({ top: 4 })
    }
    .width('100%')
    .height(80)
    .padding(8)
    .backgroundColor(this.getCourseColor(course.type))
    .borderRadius(8)
    .onClick(() => {
      this.editCourse(course)
    })
  }

  @Builder
  AddCourseDialog() {
    Column() {
      // 半透明背景
      Column() {
        // 弹窗内容
        Column() {
          Text('添加课程')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ bottom: 20 })

          // 这里可以添加课程表单
          Text('课程表单区域...')
            .fontSize(14)
            .fontColor('#666666')

          Row() {
            Button('取消', { type: ButtonType.Normal })
              .layoutWeight(1)
              .height(40)
              .fontSize(16)
              .fontColor('#666666')
              .backgroundColor('#F0F0F0')
              .onClick(() => {
                this.showAddCourse = false
              })

            Button('保存', { type: ButtonType.Normal })
              .layoutWeight(1)
              .height(40)
              .fontSize(16)
              .fontColor('#FFFFFF')
              .backgroundColor('#007DFF')
              .margin({ left: 12 })
              .onClick(() => {
                this.saveCourse()
              })
          }
          .width('100%')
          .margin({ top: 20 })
        }
        .width('80%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
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
  private getDayName(day: number): string {
    const days = ['周一', '周二', '周三', '周四', '周五']
    return days[day - 1]
  }

  private getDayDate(day: number): string {
    // 这里可以计算实际日期，暂时返回示例
    const dates = ['9/1', '9/2', '9/3', '9/4', '9/5']
    return dates[day - 1]
  }

  private getCourseAtTime(timeSlot: string, day: number): CourseItem | null {
    const startTime = timeSlot.split('-')[0]
    return this.courses.find(course =>
    course.day === day && course.startTime === startTime
    ) || null
  }

  private getCourseColor(type: string): string {
    const colors: Record<string, string> = {
      '运动': '#FF6B6B',
      '学习': '#4ECDC4',
      '咨询': '#45B7D1',
      '休息': '#96CEB4',
      '其他': '#FFBE0B'
    }
    return colors[type] || '#CCCCCC'
  }

  private addCourseAtTime(timeSlot: string) {
    this.showAddCourse = true
    console.info(`在 ${timeSlot} 添加课程`)
  }

  private editCourse(course: CourseItem) {
    console.info(`编辑课程: ${course.name}`)
    // 这里可以打开编辑弹窗
  }

  private importSchedule() {
    console.info('导入课程表')
    // 这里可以实现导入逻辑
  }

  private saveCourse() {
    console.info('保存课程')
    this.showAddCourse = false
    // 这里可以保存课程数据
  }
}

// 课程项接口
interface CourseItem {
  id: number
  day: number // 1-5 周一到周五
  startTime: string
  endTime: string
  name: string
  location: string
  type: string
}