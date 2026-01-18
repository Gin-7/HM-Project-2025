export interface Exercise {
  id: number;
  userId: number;
  recordDate: string
  exerciseType: string
  durationMinutes: number
  intensityLevel?: string
  caloriesBurned?: number
  createTime?: string;
  updateTime?: string;
}

export interface ExerciseReq {
  userId: number;
  recordDate: string
  exerciseType: string
  durationMinutes: number
  intensityLevel?: string
  caloriesBurned?: number
}
