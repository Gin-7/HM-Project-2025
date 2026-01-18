import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse, HealthCls, HealthRes, StepsRes } from './types'
import { Health } from '../types/health'

export const CreateHealthRecord = (health: HealthCls) => {
  return axiosAPI.post<ApiResponse<HealthRes>>('/api/health', health);
};

export const getHealthRecordLastNDays = (userId: number, days: number) => {
  return axiosAPI.get<ApiResponse<Health[]>>('/api/health/last-n-days', { userId, days });
};

export const getHealthRecordLatest = (userId: number) => {
  const res = axiosAPI.get<ApiResponse<HealthRes>>('/api/health/latest', { userId });
  console.info("11", JSON.stringify(res))
  return axiosAPI.get<ApiResponse<HealthRes>>('/api/health/latest', { userId });
};

export const getStepsLastWeek = (userId: number) => {
  return axiosAPI.get<ApiResponse<StepsRes[]>>('/api/health/daily-steps-last-week', { userId });
};

export class HealthAPI {
  public async CreateHealthRecord(health: HealthCls): Promise<ApiResponse<Health>> {
    return await axiosAPI.post<ApiResponse<Health>>('/api/health', health);
  };

  public async getHealthRecordLastNDays(userId: number, days: number): Promise<ApiResponse<Health[]>> {
    return await axiosAPI.get<ApiResponse<Health[]>>('/api/health/last-n-days', { userId, days });
  };

  public async getHealthRecordLatest(userId: number): Promise<ApiResponse<Health>> {
    return await axiosAPI.get<ApiResponse<Health>>(`/api/health/latest?userId=${userId}`);
  };

  public async getStepsLastWeek(userId: number): Promise<ApiResponse<StepsRes[]>> {
    return await axiosAPI.get<ApiResponse<StepsRes[]>>('/api/health/daily-steps-last-week', { userId });
  };
}

export default new HealthAPI();