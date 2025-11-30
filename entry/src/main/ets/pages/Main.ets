import { AccountComponent } from '../components/user/AccountComponent'
import {AdSwiper} from '../components/common/AdSwiper'
import {PostCard} from '../components/common/PostCard'
import {PostItem,AdItem} from '../types/Types'
import {CreatePostPage} from '../components/common/CreatePostPage'
import {ServicePage} from './ServicePage'

interface tabClass {
  text: string
  icon: ResourceStr
}

@Builder
export function MainBuilder() {
  Main()
}

@Entry
@Preview
@Component
struct Main {
  pathStack: NavPathStack = new NavPathStack()

  private tabsController: TabsController = new TabsController()
  private swiperController: SwiperController = new SwiperController()
  @State currentIndex: number = 0
  @State currentAdIndex: number = 0
  @State isCreatingPost: boolean = false // 控制发布页面显示
  @State postContent: string = "" // 保存用户输入的帖子内容
  @State postList: Array<PostItem> = [] // 用户发布的帖子列表
  private adTimer: number = 0

  tabData: tabClass[] = [
    {text: '首页', icon: $r('app.media.startIcon')},
    {text: '服务', icon: $r('app.media.startIcon')},
    {text: '我的', icon: $r('app.media.startIcon')}
  ]

  build() {
    NavDestination() {
      Column() {
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
          ForEach(this.tabData, (item: tabClass, index: number) => {
            TabContent() {
              // 第一个标签页：主页 - 修改为社区帖子流
              if (index === 0) {
                // 使用 Column 包装所有首页内容  TODO 可以像其他标签页一样单独开一个文件
                Column() {
                  // 广告轮播 - 只在首页显示
                  AdSwiper({ currentAdIndex: $currentAdIndex })

                  // 主页内容区域 - 使用 Stack 包装帖子列表和发布页面
                  Stack() {
                    // 帖子列表内容
                    Column() {
                      // 顶部标题和发布按钮
                      Row() {
                        Text('健康社区')
                          .fontSize(20)
                          .fontWeight(FontWeight.Bold)
                          .fontColor('#333333')

                        // 发布按钮
                        Row() {
                          Text('发布')
                            .fontSize(14)
                            .fontColor('#007DFF')
                        }
                        .onClick(() => {
                          this.isCreatingPost = true // 打开发布页面
                          this.postContent = "" // 清空之前的内容
                        })
                        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                        .backgroundColor('#E6F2FF')
                        .borderRadius(16)
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.SpaceBetween)
                      .padding(16)

                      // 帖子列表区域
                      if (this.postList.length > 0) {
                        // 有帖子时显示列表
                        Scroll() {
                          Column() {
                            ForEach(this.postList, (item: PostItem, index: number) => {
                              // 使用自定义组件
                              PostCard({
                                post: item,
                                index: index,
                                postList: $postList
                              })
                            })
                          }
                          .width('100%')
                        }
                        .width('100%')
                        .layoutWeight(1)
                      } else {
                        // 没有帖子时显示空状态
                        Column() {
                          Text('还没有动态')
                            .fontSize(18)
                            .fontColor('#999999')
                            .margin({ bottom: 8 })
                          Text('点击发布按钮，分享你的健康生活')
                            .fontSize(14)
                            .fontColor('#CCCCCC')
                        }
                        .width('100%')
                        .height('100%')
                        .justifyContent(FlexAlign.Center)
                        .layoutWeight(1)
                      }
                    }
                    .width('100%')
                    .height('100%')
                    .backgroundColor('#F5F5F5')

                    // 发布页面（覆盖在主页上面）
                    if (this.isCreatingPost) {
                      CreatePostPage({
                        isCreatingPost: $isCreatingPost,
                        postContent: $postContent,
                        postList: $postList
                      })
                    }
                  }
                  .layoutWeight(1) // 让Stack占据剩余空间
                }
              }
              // 第二个标签页：服务
              else if (index === 1) {
                ServicePage()
              }
              // 第三个标签页：个人中心
              else if (index === 2) {
                AccountComponent()
              }
            }
            .tabBar(this.TabBuilder(index, item))
          })
        }
        .width('100%')
        .layoutWeight(1)
        .barMode(BarMode.Fixed) // 固定模式，平均分配宽度
        .onChange((index: number) => {
          this.currentIndex = index
          console.info(`切换到标签页: ${index}`)
        })
      }
      .width('100%')
      .height('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

  // TabBuilder (需更换图片)
  @Builder TabBuilder(index: number, item: tabClass) {
    Column() {
      // Image(item.icon)
      //   .width(this.currentIndex === index ? 28 : 24)
      Text(item.text)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#666666')
        .padding(12)
        .backgroundColor(this.currentIndex === index ? '#E6F2FF' : '#FFFFFF')
        .borderRadius(20)
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
  }
}