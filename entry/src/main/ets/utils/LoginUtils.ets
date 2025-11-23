import CommonUtils from './CommonUtils'
import Logger from './Logger'

/**
 * Login operation tools.
 */
export class LoginUtils {
  /**
   * Login account and password.
   *
   * @param {string} account account
   * @param {string} password password
   */
  public login(account: string, password: string): boolean {
    let check: Resource | string = this.loginCheck(account, password);
    if (check !== '登录') {
      Logger.error('LoginUtils', 'login account or password is empty');
      CommonUtils.showToastContent(check);
      return false;
    }
    return true;
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
      check = '登录';
    }
    return check;
  }

}

export default new LoginUtils();