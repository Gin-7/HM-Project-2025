import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { userUpdate } from '../api/user'
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types';

export class UserInfoUtils {
  public async update(id: number, gender: string, age: number): Promise<boolean> {
    let check: Resource | string = this.updateCheck(age);
    if (check !== '更新成功') {
      Logger.error('UserInfoUtils', 'user information update error');
      CommonUtils.showToastContent(check);
      return false;
    }

    try {
      const res = await userUpdate(id, gender, age);
      if (res.code === 200) {
        CommonUtils.showToastContent(check);
        AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!.gender = gender
        AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!.age = age
        return true
      } else CommonUtils.showToastContent('更新失败，请稍后再试');
    } catch (err) {
      console.error('更新失败', err);
    }
    return false;
  }

  private updateCheck(age: number): string {
    let check: string = '';
    if (age < 1 || age > 120) {
      return '请输入有效的年龄（1-120）'
    } else {
      check = '更新成功';
    }
    return check;
  }
}

export default new UserInfoUtils();