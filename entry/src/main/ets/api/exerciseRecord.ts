import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse } from './types'
import type { Exercise, ExerciseReq } from '../types/exercise'

export class ExerciseRecordAPI {
  public async createExerciseRecord(record: ExerciseReq): Promise<ApiResponse<null>> {
    return await axiosAPI.post<ApiResponse<null>>('/api/exercise', record);
  };

}

export default new ExerciseRecordAPI();