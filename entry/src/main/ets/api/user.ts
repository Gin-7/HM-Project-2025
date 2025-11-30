import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse, LoginRes, RegisterRes } from './types'

export const userRegister = (username: string, password: string) => {
  return axiosAPI.post<ApiResponse<RegisterRes>>('/api/user/register', {
    username,
    password
  });
};

export const userLogin = (username: string, password: string) => {
  return axiosAPI.post<ApiResponse<LoginRes>>('/api/user/login', {
    username,
    password
  });
};