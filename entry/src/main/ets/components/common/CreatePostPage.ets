import {PostItem} from '../../types'

// 发布页面组件
@Component
export struct CreatePostPage {
  @Link isCreatingPost: boolean
  @Link postContent: string
  @Link postList: PostItem[]

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('取消')
          .fontSize(16)
          .fontColor('#666666')
          .onClick(() => {
            this.isCreatingPost = false
            this.postContent = "" // 清空输入内容
          })

        Text('发布')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.postContent ? '#007DFF' : '#CCCCCC') // 根据是否有内容改变颜色
          .margin({ left: 20 })
          .onClick(() => {
            if (this.postContent.trim()) { // 只有有内容时才发布
              this.handlePublish()
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(16)
      .backgroundColor('#FFFFFF')

      // 内容输入区域 - 正确的 TextInput 用法
      Column() {
        Text('分享你的健康动态')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ bottom: 12 })
          .width('100%')

        // 正确的 TextInput 语法
        TextInput({ placeholder: '今天完成了什么健康活动？有什么健康心得？...' })
          .width('100%')
          .height(180)
          .fontSize(15)
          .fontColor('#333333')
          .backgroundColor('#F8F9FA')
          .padding(12)
          .borderRadius(8)
          .maxLength(500)
          .onChange((value: string) => {
            this.postContent = value
          })

        Text(`${this.postContent.length}/500`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 8 })
          .width('100%')
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 发布帖子函数
  private handlePublish() {
    const newPost: PostItem = {
      id: Date.now(),
      userId: "current_user",
      userName: "我",
      avatar: "",
      postTime: "刚刚",
      content: this.postContent,
      images: [],
      likes: 0,
      comments: 0,
      isLiked: false
    }

    this.postList = [newPost, ...this.postList]
    this.isCreatingPost = false
    this.postContent = ""
    console.info('发布成功:', newPost.content)
  }
}