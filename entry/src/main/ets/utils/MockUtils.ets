import { GlobalUserInfo } from '../types/Types'
import { AppStorageV2 } from '@kit.ArkUI'
import { HealthRes, StepsRes } from '../api/types'

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
      weight: 132.0,
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
}

export default new MockUtils();

