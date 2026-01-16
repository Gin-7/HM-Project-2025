import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse, HealthCls, HealthRes, StepsRes } from './types'

export const CreateHealthRecord = (health: HealthCls) => {
  return axiosAPI.post<ApiResponse<HealthRes>>('/api/health', health);
};

export const getHealthRecordLatest = (userId: number) => {
  return axiosAPI.get<ApiResponse<HealthRes>>('/api/health/latest', { userId });
};

export const getStepsLastWeek = (userId: number) => {
  return axiosAPI.get<ApiResponse<StepsRes[]>>('/api/health/daily-steps-last-week', { userId });
};