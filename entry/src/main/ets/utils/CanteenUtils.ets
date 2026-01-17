import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { AppStorageV2 } from '@kit.ArkUI';
import type { Canteen, CanteenReq } from '../types/canteen';
import CanteenAPI from '../api/canteen'

export class CanteenUtils {
  /**
   * 创建食堂
   */
  public async createCanteen(params: CanteenReq): Promise<Canteen | null> {
    try {
      if (!params.canteenName) {
        CommonUtils.showToastContent("请输入食堂名称")
        return null
      }
      const res = await CanteenAPI.createCanteen(params);
      if (res.code === 200) {
        CommonUtils.showToastContent("成功添加食堂")
        return res.data;
      }
      console.error('创建食堂失败:', res.msg);
      CommonUtils.showToastContent("添加食堂失败")
      return null;
    } catch (error) {
      console.error('创建食堂异常:', error);
      CommonUtils.showToastContent("添加食堂失败")
      return null;
    }
  }

  /**
   * 修改食堂信息（仅更新非空字段）
   */
  public async updateCanteen(id: number, params: CanteenReq): Promise<Canteen | null> {
    try {
      if (!params.canteenName) {
        CommonUtils.showToastContent("请输入食堂名称")
        return null
      }
      const res = await CanteenAPI.updateCanteen(id, params);
      if (res.code === 200) {
        CommonUtils.showToastContent("成功更新食堂")
        return res.data;
      }
      console.error('更新食堂失败:', res.msg);
      CommonUtils.showToastContent("更新食堂失败")
      return null;
    } catch (error) {
      console.error('更新食堂异常:', error);
      CommonUtils.showToastContent("更新食堂失败")
      return null;
    }
  }

  /**
   * 删除食堂
   */
  public async deleteCanteen(id: number): Promise<boolean> {
    try {
      const res = await CanteenAPI.deleteCanteen(id);
      if (res.code === 200) {
        CommonUtils.showToastContent("删除食堂成功")
        return true;
      }
      console.error('删除食堂失败:', res.msg);
      CommonUtils.showToastContent("删除食堂失败")
      return false;
    } catch (error) {
      console.error('删除食堂异常:', error);
      CommonUtils.showToastContent("删除食堂失败")
      return false;
    }
  }

  /**
   * 查询指定食堂
   */
  public async getCanteenById(id: number): Promise<Canteen | null> {
    try {
      const res = await CanteenAPI.getCanteenById(id);
      if (res.code === 200) return res.data;
      console.error('查询食堂失败:', res.msg);
      return null;
    } catch (error) {
      console.error('查询食堂异常:', error);
      return null;
    }
  }

  /**
   * 查询所有食堂
   */
  public async getAllCanteens(): Promise<Canteen[] | null> {
    try {
      const res = await CanteenAPI.getAllCanteens();
      if (res.code === 200) return res.data;
      console.error('查询所有食堂失败:', res.msg);
      return null;
    } catch (error) {
      console.error('查询所有食堂异常:', error);
      return null;
    }
  }

  /**
   * 根据校区查询食堂
   */
  public async getCanteensByCampus(campus: string): Promise<Canteen[] | null> {
    try {
      const res = await CanteenAPI.getCanteensByCampus(campus);
      if (res.code === 200) return res.data;
      console.error(`校区【${campus}】查询食堂失败:`, res.msg);
      return null;
    } catch (error) {
      console.error('按校区查询食堂异常:', error);
      return null;
    }
  }

  /**
   * 关键词搜索食堂（支持模糊匹配多个字段）
   */
  public async searchCanteensByKeyword(keyword: string): Promise<Canteen[] | null> {
    try {
      const res = await CanteenAPI.searchCanteensByKeyword(keyword);
      if (res.code === 200) return res.data;
      console.error('食堂搜索失败:', res.msg);
      return null;
    } catch (error) {
      console.error('食堂搜索异常:', error);
      return null;
    }
  }
}

export default new CanteenUtils();