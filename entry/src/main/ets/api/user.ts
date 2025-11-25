import { axiosAPI } from '../utils/BaseRequest';
import type {RegisterReq, ApiResponse} from './types'

export const userRegister = (account: string, username: string, password: string) => {
  return axiosAPI.post<ApiResponse<void>>('/api/user/register', {
    account,
    username,
    password
  });
};

export const userLogin = (account: string, password: string) => {
  return axiosAPI.post<ApiResponse<void>>('/api/user/login', {
    account,
    password
  });
};