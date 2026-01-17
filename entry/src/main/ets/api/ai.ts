import { axiosAPI } from '../utils/BaseRequest';
import type { ApiResponse, HealthCls, HealthRes, SessionRes, MessageReq, MessageRes } from './types'

/**
 * 创建新会话
 * @param userId 用户 ID
 * @returns 新创建的会话（初始 title 为 null）
 */
export const createSession = async (userId: number): Promise<ApiResponse<SessionRes>> => {
  return axiosAPI.post<ApiResponse<SessionRes>>('/api/sessions', { userId });
};

/**
 * 更新会话标题
 * @param id 会话 ID
 * @param title 新的会话标题
 */
export const updateSessionName = async (id: number, title: string) => {
  return axiosAPI.post<ApiResponse<SessionRes>>(`/api/sessions/${id}/title`, { title });
};

/**
 * 发送用户消息到指定会话
 * @param id 会话 ID
 * @param text 用户输入的消息内容
 */
export const sendUserMessage = async (id: number, text: string): Promise<ApiResponse<MessageRes>> => {
  return axiosAPI.post<ApiResponse<MessageRes>>(`/api/sessions/${id}/messages`, {
    role: 'USER',
    text,
  });
};

/**
 * 获取指定会话的所有消息（用于轮询）
 * @param id 会话 ID
 */
export const getMessagesBySessionId = async (id: number): Promise<ApiResponse<MessageRes[]>> => {
  return axiosAPI.get<ApiResponse<MessageRes[]>>(`/api/sessions/${id}/messages`);
};

/**
 * 获取用户的会话列表
 * @param userId 用户 ID
 */
export const getSessionList = async (userId: number): Promise<ApiResponse<SessionRes[]>> => {
  return axiosAPI.get<ApiResponse<SessionRes[]>>(`/api/sessions?userId=${userId}`);
};