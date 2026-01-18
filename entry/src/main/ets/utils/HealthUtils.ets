import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types';
import { HealthRes, StepsRes } from '../api/types'
import { Health } from '../types/health';
import HealthAPI from '../api/health';

export class HealthUtils {
  public async createRcd(userId: number): Promise<boolean> {
    const today = new Date();
    const recordDate = today.toISOString().split('T')[0];
    try {
      const res = await HealthAPI.CreateHealthRecord({ userId, recordDate });
      if (res.code === 200) {
        return true
      }
      else CommonUtils.showToastContent('注册失败，请稍后再试');
    } catch (err) {
      console.error('注册失败', err);
    }
    return false;
  }

  public async getRcdLastN(userId: number, days: number): Promise<Health[] | null> {
    try {
      const res = await HealthAPI.getHealthRecordLastNDays(userId, days);
      if (res.code === 200) {
        return res.data
      }
      else CommonUtils.showToastContent('获取记录失败，请稍后再试');
    } catch (err) {
      console.error('获取记录失败', err);
    }
    return null;
  }

  public async getRcdLatest(userId: number): Promise<HealthRes | null> {
    try {
      const res = await HealthAPI.getHealthRecordLatest(userId);
      console.info(JSON.stringify(res))
      if (res.code === 200) {
        return res.data
      }
      else CommonUtils.showToastContent('获取最新记录失败，请稍后再试');
    } catch (err) {
      console.error('获取最新记录失败', err);
    }
    return null;
  }

  public async getSteps(userId: number): Promise<StepsRes[] | null> {
    try {
      const res = await HealthAPI.getStepsLastWeek(userId);
      if (res.code === 200) {
        return res.data
      }
      else CommonUtils.showToastContent('获取运动记录失败，请稍后再试');
    } catch (err) {
      console.error('获取运动记录失败', err);
    }
    return null;
  }
}

export default new HealthUtils();