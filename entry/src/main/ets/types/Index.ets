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