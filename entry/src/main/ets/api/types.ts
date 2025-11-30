export interface RegisterRes {
  id: number;
  username: string;
  email: string;
  createTime: string;
}

export interface LoginRes {
  id: number;
  username: string;
  email: string;
  createTime: string;
}

export interface InfoChangeRes {
  id: number;
  username: string;
  email: string;
  createTime: string;
}

export interface ApiResponse<T = never> {
  code: number;
  msg: string;
  data: T;
}