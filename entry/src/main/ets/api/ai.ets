import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse, HealthCls, HealthRes } from './types'

// 改
export const getHealthSuggestion = async (record: HealthRes): Promise<string> => {
  try {
    // const response = await axiosAPI.post<>('/api/ai', record);
    return '保持规律作息，均衡饮食，适度运动。';
  } catch (error) {
    console.error('AI 建议获取失败:', error);
    return '暂时无法生成建议，请稍后再试。';
  }
};