import { AppStorageV2, UIContext } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  pageStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  uiContext: UIContext = AppStorageV2.connect(UIContext, 'uiContext', () => this.getUIContext())!

  build() {
    Navigation(this.pageStack) {

    }.onAppear(() => {
      this.pageStack.replacePathByName("Login", null, false)
    })
    .hideNavBar(true)
  }
}