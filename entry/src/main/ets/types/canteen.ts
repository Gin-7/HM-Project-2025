export interface Canteen {
  id: number;
  canteenName: string;
  location?: string;
  businessHours?: string;
  description?: string;
  recommendation?: string;
  campus?: string;
  coverUrl?: string;
  createTime?: string;
  updateTime?: string;
}

export interface CanteenReq {
  canteenName: string;
  location?: string;
  businessHours?: string;
  description?: string;
  recommendation?: string;
  campus?: string;
  coverUrl?: string;
}

export interface CanteenParams {
  canteen: Canteen
}