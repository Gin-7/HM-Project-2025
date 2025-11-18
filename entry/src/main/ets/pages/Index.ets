import { AppStorageV2 } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  pageStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {
    Navigation(this.pageStack) {

    }.onAppear(() => {
      this.pageStack.replacePathByName("Main", null, false)
    })
    .hideNavBar(true)
  }
}