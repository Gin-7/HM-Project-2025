import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse } from './types'
import type { Canteen, CanteenReq } from '../types/canteen'

export class CanteenAPI {
  public async createCanteen(canteen: CanteenReq): Promise<ApiResponse<Canteen>> {
    return await axiosAPI.post<ApiResponse<Canteen>>('/api/Canteen/create', canteen);
  };

  public async updateCanteen(id: number, canteen: CanteenReq): Promise<ApiResponse<Canteen>> {
    return await axiosAPI.put<ApiResponse<Canteen>>(`/api/Canteen/update?id=${id}`, canteen);
  };

  public async deleteCanteen(id: number): Promise<ApiResponse<null>> {
    return await axiosAPI.delete<ApiResponse<null>>(`/api/Canteen/delete?id=${id}`);
  };

  public async getCanteenById(id: number): Promise<ApiResponse<Canteen>> {
    return await axiosAPI.get<ApiResponse<Canteen>>(`/api/Canteen/get?id=${id}`);
  };

  public async getAllCanteens(): Promise<ApiResponse<Canteen[]>> {
    return await axiosAPI.get<ApiResponse<Canteen[]>>(`/api/Canteen/list`);
  };

  public async getCanteensByCampus(campus: string): Promise<ApiResponse<Canteen[]>> {
    return await axiosAPI.get<ApiResponse<Canteen[]>>(`/api/Canteen/getByCampus?campus=${encodeURIComponent(campus)}`);
  };

  public async searchCanteensByKeyword(keyword: string): Promise<ApiResponse<Canteen[]>> {
    return await axiosAPI.get<ApiResponse<Canteen[]>>(`/api/Canteen/searchByKeyword?keyword=${encodeURIComponent(keyword)}`);
  };
}

export default new CanteenAPI();