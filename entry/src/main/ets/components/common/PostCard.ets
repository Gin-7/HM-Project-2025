// components/common/PostCard.ets
import {PostItem} from '../../types/Index'

@Component
export struct PostCard {
  post: PostItem = {
    id: 0,
    userId: "",
    userName: "",
    avatar: "",
    postTime: "",
    content: "",
    likes: 0,
    comments: 0,
    isLiked: false
  }
  index: number = 0
  @Link postList: PostItem[]

  build() {
    Column() {
      // 用户信息栏
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Circle({ width: 40, height: 40 })
            .fill('#E6F2FF')
          Text(this.post.userName.length > 0 ? this.post.userName.substring(0, 1) : '?')
            .fontSize(16)
            .fontColor('#007DFF')
            .fontWeight(FontWeight.Bold)
        }
        .width(40)
        .height(40)

        Column() {
          Text(this.post.userName)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Text(this.post.postTime)
            .fontSize(12)
            .fontColor('#999999')
        }
        .margin({ left: 12 })
        .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Text(this.post.content)
        .fontSize(15)
        .fontColor('#333333')
        .lineHeight(20)
        .margin({ top: 12, bottom: 12 })
        .width('100%')

      Row() {
        Row() {
          Text(this.post.isLiked ? '❤️' : '🤍')
            .fontSize(16)
          Text(this.post.likes.toString())
            .fontSize(14)
            .fontColor(this.post.isLiked ? '#FF3B30' : '#666666')
            .margin({ left: 4 })
        }
        .onClick(() => {
          this.handleLike()
        })
        .padding(8)

        Row() {
          Text('💬')
            .fontSize(16)
          Text(this.post.comments.toString())
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 4 })
        }
        .padding(8)
        .margin({ left: 20 })
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ top: 8 })
  }

  // 点赞处理函数
  handleLike() {
    let newPostList = [...this.postList]
    let originalPost = newPostList[this.index]

    newPostList[this.index] = {
      id: originalPost.id,
      userId: originalPost.userId,
      userName: originalPost.userName,
      avatar: originalPost.avatar,
      postTime: originalPost.postTime,
      content: originalPost.content,
      images: originalPost.images,
      likes: originalPost.isLiked ? originalPost.likes - 1 : originalPost.likes + 1,
      comments: originalPost.comments,
      isLiked: !originalPost.isLiked
    }

    this.postList = newPostList
  }
}