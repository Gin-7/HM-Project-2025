import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { userLogin, userRegister } from '../api/user'
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types';
import HealthUtils from './HealthUtils';

/**
 * Login operation tools.
 */
export class LoginUtils {
  /**
   * Login account and password.
   *
   * @param {string} account account
   * @param {string} password password
   * @return {boolean} return login result
   */
  public async login(account: string, password: string): Promise<boolean> {
    let check: Resource | string = this.loginCheck(account, password);
    if (check !== '登录成功') {
      Logger.error('LoginUtils', 'login account or password is empty');
      CommonUtils.showToastContent(check);
      return false;
    }

    try {
      const res = await userLogin(account, password);
      if (res.code === 200) {
        CommonUtils.showToastContent(check);
        AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo(res.data?.id?? -1, res.data?.username?? 'null'))!
        return true
      }
      else CommonUtils.showToastContent('登录失败，请稍后再试');
    } catch (err) {
      console.error('登录失败', err);
    }
    return false;
  }

  /**
   * Check account and password is it valid.
   *
   * @param {string} account account
   * @param {string} password password
   * @return {Resource|string} return check result
   */
  private loginCheck(account: string, password: string): string {
    let check: string = '';
    // TODO check details
    if (account === '') {
      return '请输入账号';
    } else if (password === '') {
      return '请输入密码';
    } else {
      check = '登录成功';
    }
    return check;
  }

  /**
   * Register account.
   *
   * @param {string} account account
   * @param {string} password password
   * @param {string} password2 password
   * @return {boolean} return register result
   */
  public async register(account: string, password: string, password2: string): Promise<boolean> {
    let check: Resource | string = this.RegisterCheck(account, password, password2);
    if (check !== '注册成功') {
      Logger.error('LoginUtils', 'register account error');
      CommonUtils.showToastContent(check);
      return false;
    }

    try {
      const res = await userRegister(account, password);
      if (res.code === 200) {
        const create = await HealthUtils.createRcd(res.data?.id?? -1);
        if (create) {
          CommonUtils.showToastContent(check);
          AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo(res.data?.id?? -1, res.data?.username?? 'null'))!
          return true
        }
      }
      CommonUtils.showToastContent('注册失败，请稍后再试');
    } catch (err) {
      console.error('注册失败', err);
    }
    return false;
  }

  /**
   * Check account and password is it valid.
   *
   * @param {string} account account
   * @param {string} password password
   * @param {string} password2 password
   * @return {Resource|string} return check result
   */
  private RegisterCheck(account: string, password: string, password2: string): string {
    let check: string = '';
    // TODO check details
    if (account === '') {
      return '请输入账号';
    } else if (password === '' || password2 === '') {
      return '请输入密码';
    } else if (password !== password2) {
      return '密码与确认密码不匹配，请检查后重试'
    } else if (password.length < 6 || password.length > 20) {
      return '密码长度必须在6-20个字符之间'
    } else {
      check = '注册成功';
    }
    return check;
  }
}

export default new LoginUtils();