import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { CreateHealthRecord, getHealthRecordLatest } from '../api/health'
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types';
import { HealthRes } from '../api/types'
import { getHealthSuggestion } from '../api/ai'

export class AIUtils {
  public async getAISuggestion(record: HealthRes): Promise<string> {
    return getHealthSuggestion(record)
  }

}

export default new AIUtils();