import { GlobalUserInfo } from '../types/Types'
import { AppStorageV2 } from '@kit.ArkUI'
import { HealthRes, StepsRes } from '../api/types'
import { Canteen } from '../types/canteen'

export class MockUtils {
  userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!

  public mockHealthRecord(): HealthRes {
    const today = new Date();
    const dateString = today.toISOString().split('T')[0]; // "yyyy-MM-dd"
    const isoTimestamp = today.toISOString(); // "2025-11-30T12:07:47.784Z"

    return {
      id: 1,
      userId: this.userInfo.userId,
      recordDate: dateString,           // e.g. "2026-01-15"
      bloodOxygen: 98.5,
      systolicBp: 120,
      diastolicBp: 80,
      bloodGlucose: 5.6,
      weight: 66.0,
      height: 178.0,
      heartRate: 72,
      sleepDuration: 7.5,
      deepSleep: 2.3,
      lightSleep: 4.8,
      steps: 8500,
      stressLevel: 50,
      vitality: 85,
      createTime: isoTimestamp,
      updateTime: isoTimestamp
    };
  }

  public mockWeeklySteps(): StepsRes[] {
    return [
      { date: "2025-11-25", steps: 6770 },
      { date: "2025-11-26", steps: 7450 },
      { date: "2025-11-27", steps: 230 },
      { date: "2025-11-28", steps: 4230 },
      { date: "2025-11-29", steps: 12110 },
      { date: "2025-11-30", steps: 3220 },
      { date: "2025-12-01", steps: 110 },
    ]
  }

  public mockCanteens(): Canteen[] {
    return [
      {
        id: 1,
        canteenName: "第一食堂",
        location: "主教学楼东侧",
        businessHours: "06:30-21:30",
        description: "提供川菜、粤菜、面食及清真窗口，支持校园卡与移动支付。",
        recommendation: "红烧肉、牛肉面",
        campus: "主校区",
        coverUrl: "",
        createTime: "2025-10-01T08:00:00Z",
        updateTime: "2025-12-10T14:20:00Z"
      },
      {
        id: 2,
        canteenName: "第二食堂（风味餐厅）",
        location: "学生生活区A栋1层",
        businessHours: "07:00-22:00",
        description: "主打各地特色小吃，包括麻辣烫、黄焖鸡、煎饼果子等。",
        recommendation: "麻辣香锅、鸡蛋灌饼",
        campus: "主校区",
        coverUrl: "",
        createTime: "2025-10-05T09:15:00Z",
        updateTime: "2025-12-12T10:30:00Z"
      },
      {
        id: 3,
        canteenName: "东区食堂",
        location: "东校区实验楼旁",
        businessHours: "07:00-20:00",
        description: "简约快捷餐，适合课间快速用餐，价格实惠。",
        recommendation: "套餐饭、豆浆油条",
        campus: "东校区",
        coverUrl: "",
        createTime: "2025-11-01T10:00:00Z",
        updateTime: "2025-12-05T16:45:00Z"
      }
    ];
  }
}

export default new MockUtils();

