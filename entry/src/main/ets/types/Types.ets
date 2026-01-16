// types/Index.ets
export interface AdItem {
  id: number;
  title: string;
  bgColor: string;
  content: string;
}

export interface PostItem {
  id: number;
  userId: string;
  userName: string;
  avatar: string;
  postTime: string;
  content: string;
  images?: string[];
  likes: number;
  comments: number;
  isLiked: boolean;
}

/**
 * 全局存储的用户信息
 */
export class GlobalUserInfo {
  userId: number;
  userName: string;
  gender: string;
  age: number;

  constructor(userId?: number, userName?: string, gender?: string, age?: number) {
    this.userId = userId ?? 1;
    this.userName = userName ?? 'Jack';
    this.gender = gender ?? 'MALE';
    this.age = age ?? 20;
  }
}

/**
 * 用户基本健康数据
 */
export interface HealthData {
  userID: number;
  userName: string;

  height: number;
  weight: number;
  age: number;
  heartRate: number;        // 心率
  bloodOxygen: number;      // 血氧
  bloodPressure: number;    // 血压
  bloodGlucose: number;     // 血糖
  sleepDuration: number;    // 睡眠时长

  calories: number;
  steps: number;
  exerciseDuration: number;
}