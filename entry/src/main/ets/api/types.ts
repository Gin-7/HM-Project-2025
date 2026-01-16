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

export interface HealthCls {
  userId: number;
  recordDate: string; // 通常为 ISO 8601 日期字符串，如 "2025-11-30"
  bloodOxygen?: number;      // 血氧饱和度（%）
  systolicBp?: number;       // 收缩压（mmHg）
  diastolicBp?: number;      // 舒张压（mmHg）
  bloodGlucose?: number;     // 血糖（mmol/L）
  weight?: number;           // 体重（kg）
  height?: number;           // 身高（cm）
  heartRate?: number;        // 心率（bpm）
  sleepDuration?: number;    // 总睡眠时长（小时）
  deepSleep?: number;        // 深度睡眠时长（小时）
  lightSleep?: number;       // 浅睡时长（小时）
  steps?: number;            // 步数
  stressLevel?: number;      // 压力水平（0-100 或其他自定义范围）
  vitality?: number;         // 活力值（假设为 0-100）
}

export interface HealthRes {
  id: number;
  userId: number;
  recordDate: string; // 通常为 ISO 8601 日期字符串，如 "2025-11-30"
  bloodOxygen: number;      // 血氧饱和度（%）
  systolicBp: number;       // 收缩压（mmHg）
  diastolicBp: number;      // 舒张压（mmHg）
  bloodGlucose: number;     // 血糖（mmol/L）
  weight: number;           // 体重（kg）
  height: number;           // 身高（cm）
  heartRate: number;        // 心率（bpm）
  sleepDuration: number;    // 总睡眠时长（小时）
  deepSleep: number;        // 深度睡眠时长（小时）
  lightSleep: number;       // 浅睡时长（小时）
  steps: number;            // 步数
  stressLevel: number;      // 压力水平（0-100 或其他自定义范围）
  vitality: number;         // 活力值（假设为 0-100）
  createTime: string;       // ISO 8601 时间戳
  updateTime: string;       // ISO 8601 时间戳
}

export interface StepsRes {
  date: string;
  steps: number;
}

export interface ApiResponse<T = never> {
  code: number;
  msg: string;
  data: T;
}