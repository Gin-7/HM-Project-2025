// pages/ExercisePlan.ets
import { axiosAPI } from '../utils/BaseRequest';
import prompt from '@ohos.promptAction';
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types'
let userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!

// 运动计划接口
interface ExercisePlanItem {
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

interface ApiResponse<T> {
  code: number
  message: string
  data?: T
}

@Builder
export function ExercisePlanBuilder() {
  ExercisePlan()
}

@Preview
@Component
struct ExercisePlan {
  pathStack: NavPathStack = new NavPathStack()

  @State plans: ExercisePlanItem[] = []
  @State isLoading: boolean = false
  @State showDeleteConfirm: boolean = false
  @State deletingPlanId: number = 0

  // 完成状态显示名称映射
  private completionStatusNames: Record<number, string> = {
    0: '未完成',
    1: '已完成'
  }

  // 完成状态颜色
  private getCompletionColor(status: number): string {
    return status === 1 ? '#52C41A' : '#FAAD14'
  }

  // 获取事件图标
  private getEventIcon(content?: string): string {
    if (!content) return '📅'

    const contentLower = content.toLowerCase()
    if (contentLower.includes('跑步') || contentLower.includes('跑')) return '🏃'
    if (contentLower.includes('游泳') || contentLower.includes('泳')) return '🏊'
    if (contentLower.includes('骑行') || contentLower.includes('骑')) return '🚴'
    if (contentLower.includes('步行') || contentLower.includes('走')) return '🚶'
    if (contentLower.includes('健身') || contentLower.includes('锻炼')) return '💪'
    if (contentLower.includes('瑜伽') || contentLower.includes('拉伸')) return '🧘'
    return '📅'
  }

  aboutToAppear() {
    this.loadPlans()
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

          Text('运动计划')
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

        // 移除了过滤选项

        // 计划列表区域
        Column() {
          if (this.isLoading && (!this.plans || this.plans.length === 0)) {
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
          } else if (!this.plans || this.plans.length === 0) {
            // 空状态
            Column() {
              Text('暂无运动计划')
                .fontSize(16)
                .fontColor('#666666')
                .margin({ bottom: 8 })

              Text('点击下方按钮创建第一个计划')
                .fontSize(14)
                .fontColor('#999999')
            }
            .width('100%')
            .height(400)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 计划列表
            Scroll() {
              Column() {
                if (this.plans && this.plans.length > 0) {
                  ForEach(this.plans, (plan: ExercisePlanItem) => {
                    this.buildPlanItem(plan)
                  })
                }
              }
              .width('100%')
              .padding({ top: 8, bottom: 80 })
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
          Button('+ 添加运动计划', { type: ButtonType.Normal })
            .width('100%')
            .height(56)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor('#007DFF')
            .borderRadius(0)
            .onClick(() => {
              this.pathStack.pushPathByName('CreateExercisePlan', null, false)
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
      this.loadPlans()
    })
    .hideTitleBar(true)
  }

  @Builder
  buildPlanItem(plan: ExercisePlanItem) {
    Column() {
      Row() {
        // 左侧：图标和状态
        Column() {
          Column() {
            Text(this.getEventIcon(plan.eventContent))
              .fontSize(20)
          }
          .width(48)
          .height(48)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(plan.completionStatus === 1 ? '#E6F7FF' : '#F0F8FF')
          .borderRadius(24)

          // 状态指示器
          if (plan.completionStatus === 1) {
            Text('✓')
              .fontSize(12)
              .fontColor('#52C41A')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 4 })
          }
        }
        .alignItems(HorizontalAlign.Center)

        // 中间：信息
        Column() {
          // 事件内容
          Row() {
            Text(plan.eventContent || '运动计划')
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            Text(this.completionStatusNames[plan.completionStatus] || '未知状态')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .backgroundColor(this.getCompletionColor(plan.completionStatus))
              .borderRadius(4)
          }
          .width('100%')
          .margin({ bottom: 4 })

          // 日期时间
          Row() {
            Text(`${plan.startDate}`)
              .fontSize(14)
              .fontColor('#666666')

            if (plan.startTime) {
              Text(` ${plan.startTime}`)
                .fontSize(14)
                .fontColor('#666666')
            }

            if (plan.endDate && plan.endDate !== plan.startDate) {
              Text(` 至 ${plan.endDate}`)
                .fontSize(14)
                .fontColor('#666666')
            }

            if (plan.endTime) {
              Text(` ${plan.endTime}`)
                .fontSize(14)
                .fontColor('#666666')
            }
          }
          .width('100%')
          .margin({ bottom: 4 })

          // 备注
          if (plan.remark) {
            Text(plan.remark)
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
          }
        }
        .margin({ left: 12 })
        .layoutWeight(1)
      }
      .width('100%')

      // 操作按钮行
      Row() {
        // 如果是未完成状态，显示标记完成按钮
        if (plan.completionStatus === 0) {
          Button('标记完成', { type: ButtonType.Normal })
            .width(80)
            .height(32)
            .fontSize(12)
            .fontColor('#52C41A')
            .backgroundColor('#F6FFED')
            .border({
              width: 1,
              color: '#52C41A',
              style: BorderStyle.Solid
            })
            .onClick(() => {
              this.markAsCompleted(plan.id)
            })
            .margin({ right: 8 })
        }

        // 编辑按钮
        Button('编辑', { type: ButtonType.Normal })
          .width(60)
          .height(32)
          .fontSize(12)
          .fontColor('#007DFF')
          .backgroundColor('#F0F8FF')
          .border({
            width: 1,
            color: '#007DFF',
            style: BorderStyle.Solid
          })
          .onClick(() => {
            this.editPlan(plan.id)
          })
          .margin({ right: 8 })

        // 删除按钮
        Button('删除', { type: ButtonType.Normal })
          .width(60)
          .height(32)
          .fontSize(12)
          .fontColor('#F5222D')
          .backgroundColor('#FFF2F0')
          .border({
            width: 1,
            color: '#F5222D',
            style: BorderStyle.Solid
          })
          .onClick(() => {
            this.showDeleteConfirmDialog(plan.id)
          })

        Blank()
      }
      .width('100%')
      .margin({ top: 12 })
      .justifyContent(FlexAlign.Start)
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

  // 加载计划
  private async loadPlans() {
    this.isLoading = true

    try {
      const date = new Date()
      const date7 = new Date();
      date7.setDate(date7.getDate() + 7);

      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需+1
      const day = String(date.getDate()).padStart(2, '0');

      const formattedDate = `${year}-${month}-${day}`;

      const year7 = date7.getFullYear();
      const month7 = String(date7.getMonth() + 1).padStart(2, '0'); // 月份从0开始，需+1
      const day7 = String(date7.getDate()).padStart(2, '0');

      const formattedDate7 = `${year7}-${month7}-${day7}`;
      const response: ApiResponse<ExercisePlanItem[]> = await axiosAPI.get(`/api/single-exercise-plan/weekly?userId=${userInfo.userId}&startDate=${formattedDate}&endDate=${formattedDate7}`)

      console.info('加载计划API响应:', response)

      if (response.code === 200) {
        if (response.data && Array.isArray(response.data)) {
          this.plans = response.data.sort((a, b) =>
          new Date(b.startDate).getTime() - new Date(a.startDate).getTime()
          )
        } else {
          this.plans = []
          console.warn('API返回的数据不是数组:', response.data)
        }
      } else {
        prompt.showToast({
          message: response.message || '加载失败',
          duration: 2000
        })
        this.plans = []
      }
    } catch (error) {
      console.error('加载异常:', error)
      prompt.showToast({
        message: '网络异常，请重试',
        duration: 2000
      })
      this.plans = []
    } finally {
      this.isLoading = false
      console.info('加载完成，plans:', this.plans)
    }
  }

  // 标记为已完成
  private async markAsCompleted(planId: number) {
    try {
      const response: ApiResponse<void> = await axiosAPI.put(`/exercise/plan/${planId}/complete`)

      if (response.code === 200) {
        prompt.showToast({
          message: '标记完成成功',
          duration: 2000
        })
        this.loadPlans()
      } else {
        prompt.showToast({
          message: response.message || '操作失败',
          duration: 2000
        })
      }
    } catch (error) {
      console.error('操作异常:', error)
      prompt.showToast({
        message: '网络异常，请重试',
        duration: 2000
      })
    }
  }

  // 编辑计划
  private editPlan(planId: number) {
    prompt.showToast({
      message: '编辑功能开发中',
      duration: 2000
    })
  }

  // 显示删除确认对话框
  private showDeleteConfirmDialog(planId: number) {
    this.deletingPlanId = planId
    this.showDeleteConfirm = true

    // 使用自定义对话框提示
    prompt.showDialog({
      title: '确认删除',
      message: '确定要删除这个运动计划吗？删除后无法恢复。',
      buttons: [
        {
          text: '取消',
          color: '#666666'
        },
        {
          text: '删除',
          color: '#F5222D'
        }
      ]
    }).then((result) => {
      if (result.index === 1) { // 点击了删除按钮
        this.deletePlan(planId)
      }
      this.showDeleteConfirm = false
    })
  }

  // 删除计划
  private async deletePlan(planId: number) {
    try {
      const response: ApiResponse<void> = await axiosAPI.delete(`/api/single-exercise-plan/delete?id=${planId}`)

      if (response.code === 200) {
        prompt.showToast({
          message: '删除成功',
          duration: 2000
        })
        // 重新加载计划列表
        this.loadPlans()
      } else {
        prompt.showToast({
          message: response.message || '删除失败',
          duration: 2000
        })
      }
    } catch (error) {
      console.error('删除异常:', error)
      prompt.showToast({
        message: '网络异常，请重试',
        duration: 2000
      })
    }
  }
}