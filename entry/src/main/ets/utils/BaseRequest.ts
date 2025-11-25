import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from '@ohos/axios';
import { AppStorageV2, UIContext } from '@kit.ArkUI';

class BaseRequest {
  instance: AxiosInstance;

  debug: boolean = true;    // debug

  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config);
    const uiContext: UIContext = AppStorageV2.connect(UIContext, 'uiContext', () => new UIContext())!;

    // 请求拦截器
    this.instance.interceptors.request.use(
      (config) => {
        // 可添加 token
        const token = ''; // 从本地存储获取
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        console.log('请求配置:', config);
        return config;
      },
      (error) => {
        console.error('请求错误:', error);
        return Promise.reject(error);
      }
    );

    // 响应拦截器
    this.instance.interceptors.response.use(
      (response: AxiosResponse) => {
        let data = response.data;
        if (typeof data === 'string') {
          data = JSON.parse(data.trim());
        }

        // 假设后端返回格式：{ code: 200, msg: 'success', data: {...} }
        if (data.code === 200) {
          return data;
        } else {
          uiContext!.getPromptAction().showToast({ message: data.msg || '请求失败', duration: 2000 });
          return Promise.reject(new Error(data.msg));
        }
      },
      (error) => {
        console.error('响应错误:', error);
        uiContext!.getPromptAction().showToast({ message: '网络请求失败，请稍后重试', duration: 2000 });
        return Promise.reject(error);
      }
    );
  }

  request<T = any>(config: AxiosRequestConfig): Promise<T> {
    if (this.debug) {
      const mockData = { code: 200, msg: 'Mock success', data: {} }
      return new Promise((resolve) => { resolve(mockData as T) });
    }
    return this.instance.request<any, T>(config);
  }

  get<T = any>(url: string, params?: any): Promise<T> {
    if (this.debug) {
      const mockData = { code: 200, msg: 'Mock success', data: {} }
      return new Promise((resolve) => { resolve(mockData as T) });
    }
    return this.request<T>({ method: 'GET', url, params });
  }

  post<T = any>(url: string, data?: any): Promise<T> {
    if (this.debug) {
      const mockData = { code: 200, msg: 'Mock success', data: {} }
      return new Promise((resolve) => { resolve(mockData as T) });
    }
    return this.request<T>({ method: 'POST', url, data });
  }
}

// 导出实例
export const axiosAPI = new BaseRequest({
  baseURL: 'http://localhost:8080',
  timeout: 10000
});