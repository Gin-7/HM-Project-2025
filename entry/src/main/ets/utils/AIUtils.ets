import CommonUtils from './CommonUtils'
import Logger from './Logger'
import { CreateHealthRecord, getHealthRecordLatest } from '../api/health'
import { AppStorageV2 } from '@kit.ArkUI';
import { GlobalUserInfo } from '../types/Types';
import { SessionRes, MessageReq, MessageRes } from '../api/types'
import { createSession, updateSessionName, sendUserMessage, getMessagesBySessionId, getSessionList } from '../api/ai'

export class AIUtils {
  /**
   * 创建一个新会话（直接返回会话对象）
   * @param userId 用户 ID
   * @returns Promise<SessionRes> | null（失败返回 null）
   */
  public async createSession(userId: number): Promise<SessionRes | null> {
    try {
      const res = await createSession(userId);
      if (res.code === 200) return res.data;
      console.error('创建会话失败:', res.msg);
      return null;
    } catch (error) {
      console.error('创建会话异常:', error);
      return null;
    }
  }

  public async updateSessionName(id: number, title: string): Promise<SessionRes | null> {
    try {
      const res = await updateSessionName(id, title);
      if (res.code === 200) return res.data;
      console.error('更新会话名称失败:', res.msg);
      return null;
    } catch (error) {
      console.error('更新会话名称异常:', error);
      return null;
    }
  }

  /**
   * 获取用户会话列表（直接返回数组）
   */
  public async getSessionList(userId: number): Promise<SessionRes[] | null> {
    try {
      const res = await getSessionList(userId);
      if (res.code === 200) return res.data;
      console.error('获取会话列表失败:', res.msg);
      return null;
    } catch (error) {
      console.error('获取会话列表异常:', error);
      return null;
    }
  }

  /**
   * 发送用户消息，并自动轮询直到收到 AI 回复（或超时）
   * @param sessionId 会话 ID
   * @param userText 用户输入
   * @param onNewMessage 每次轮询到新消息时的回调（用于实时更新 UI）
   * @param maxWaitSeconds 最大等待时间（默认 15 秒）
   * @returns 最终完整的消息列表，或 null（失败/超时）
   */
  public async sendMessageAndWaitAI(
    sessionId: number,
    userText: string,
    onNewMessage?: (messages: MessageRes[]) => void,
    maxWaitSeconds: number = 15
  ): Promise<MessageRes[] | null> {
    try {
      // 1. 先发送用户消息
      const sendRes = await sendUserMessage(sessionId, userText);
      if (sendRes.code !== 200) {
        console.error('发送消息失败:', sendRes.msg);
        return null;
      }

      // 2. 开始轮询
      const startTime = Date.now();
      const interval = 2000; // 每 2 秒轮询一次

      const poll = async (): Promise<MessageRes[] | null> => {
        const now = Date.now();
        if (now - startTime > maxWaitSeconds * 1000) {
          console.warn('AI 回复超时');
          return null;
        }

        const pollRes = await getMessagesBySessionId(sessionId);
        if (pollRes.code !== 200) {
          console.error('轮询消息失败:', pollRes.msg);
          return null;
        }

        const messages = pollRes.data;
        // 触发实时更新回调
        onNewMessage?.(messages);

        // 检查是否有 AI 回复
        const hasAssistant = messages.some(msg => msg.role === 'ASSISTANT');
        if (hasAssistant) {
          return messages;
        }

        // 继续轮询
        await new Promise<void>(resolve => setTimeout(resolve, interval));
        return poll();
      };

      return await poll();
    } catch (error) {
      console.error('sendMessageAndWaitAI 异常:', error);
      return null;
    }
  }

  /**
   * 单次获取当前会话的所有消息（不轮询）
   */
  public async getMessages(sessionId: number): Promise<MessageRes[] | null> {
    try {
      const res = await getMessagesBySessionId(sessionId);
      if (res.code === 200) return res.data;
      console.error('获取消息失败:', res.msg);
      return null;
    } catch (error) {
      console.error('获取消息异常:', error);
      return null;
    }
  }
}

export default new AIUtils();