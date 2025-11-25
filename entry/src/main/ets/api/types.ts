export interface RegisterReq {
  account: string;
  username: string;
  password: string;
}

export interface ApiResponse<T = never> {
  code: number;
  msg: string;
  data: T;
}