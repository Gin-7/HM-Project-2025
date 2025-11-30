import { AppStorageV2 } from '@kit.ArkUI'
import { GlobalUserInfo } from '../types/Types'
import CommonUtils from '../utils/CommonUtils'
import LoginUtils from '../utils/LoginUtils'

@Builder
export function LoginBuilder() {
  Login()
}

let para: Record<string, boolean> = { 'Login': true };
let storage: LocalStorage = new LocalStorage(para);

/**
 * The login page consists of two components.
 * LoginTitle and LoginBottom, which can be invoked by directly referencing the control.
 */
@Preview
@Entry(storage)
@Component
struct Login {
  @LocalStorageLink('Login') login: boolean = true

  build() {
    NavDestination() {
      Column() {
        if (this.login) {
          // Title component
          LoginTitle()
          // Bottom component
          LoginBottom()
        } else {
          RegisterTitle()
          RegisterBottom()
        }
      }
    }
    .backgroundColor('#F1F3F5')
  }
}

@Component
struct LoginTitle {
  build() {
    Column() {
      Image($r('app.media.startIcon'))
        .width('78vp')
        .height('78vp')
        .margin({ bottom: '8vp' })
      Text('登录界面')
        .fontSize('24fp')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
      Text('登录账号以使用更多服务')
        .fontSize('16fp')
        .fontColor('#99182431')
        .margin({
          top: '8vp',
          bottom: '12vp'
        })
    }
    .backgroundColor('#F1F3F5')
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('40%')
  }
}

@Component
struct LoginBottom {
  pageStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  @State account: string = '';
  @State password: string = '';
  @LocalStorageLink('Login') login: boolean = true

  build() {
    Column() {
      Column() {
        TextInput({ placeholder: '账号' })
          .maxLength(11)
          .type(InputType.Number)
          .inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })

        Line()
          .width('100%')
          .height('0.5vp')
          .margin({
            left: '12vp',
            right: '12vp'
          })
          .backgroundColor('#0D182431')

        TextInput({ placeholder: '密码' })
          .maxLength(32)
          .type(InputType.Password)
          .inputStyle()
          .onChange((value: string) => {
            this.password = value;
          })
      }
      .backgroundColor(Color.White)
      .borderRadius('24vp')

      Row() {
        Text('短信验证码登录')
          .blueTextStyle()
          .onClick(() => {
            CommonUtils.showToastContent('暂无相关服务');
          })
        Text('忘记密码')
          .blueTextStyle()
          .onClick(() => {
            CommonUtils.showToastContent('暂无相关服务');
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: '12vp' })
      .padding({
        left: '12vp',
        right: '12vp'
      })

      Button('登录')
        .id('loginButtonId')
        .width('100%')
        .height('40vp')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#007DFF')
        .margin({
          top: '68vp',
          bottom: '12vp'
        })
        .onClick(async () => {
          const success = await LoginUtils.login(this.account, this.password)
          if (success) {
            this.pageStack.replacePathByName('Main', null, false)
          }
        })
      Text('注册账号')
        .fontColor('#007DFF')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          this.login = false
        })
    }
    .padding({
      left: '12vp',
      right: '12vp',
    })
    .backgroundColor('#F1F3F5')
    .height('60%')
  }
}

@Component
struct RegisterTitle {
  build() {
    Column() {
      Image($r('app.media.startIcon'))
        .width('78vp')
        .height('78vp')
        .margin({ bottom: '8vp' })
      Text('注册界面')
        .fontSize('24fp')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
    }
    .backgroundColor('#F1F3F5')
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('37%')
  }
}

@Component
struct RegisterBottom {
  pageStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  @State account: string = '';
  @State password: string = '';
  @State password_again: string = '';
  @LocalStorageLink('Login') login: boolean = false

  build() {
    Column() {
      Column() {
        TextInput({ placeholder: '账号' })
          .maxLength(11)
          .type(InputType.Number)
          .inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })

        Line()
          .width('100%')
          .height('0.5vp')
          .margin({
            left: '12vp',
            right: '12vp'
          })
          .backgroundColor('#0D182431')

        TextInput({ placeholder: '密码' })
          .maxLength(32)
          .type(InputType.Password)
          .inputStyle()
          .onChange((value: string) => {
            this.password = value;
          })

        Line()
          .width('100%')
          .height('0.5vp')
          .margin({
            left: '12vp',
            right: '12vp'
          })
          .backgroundColor('#0D182431')

        TextInput({ placeholder: '确认密码' })
          .maxLength(32)
          .type(InputType.Password)
          .inputStyle()
          .onChange((value: string) => {
            this.password_again = value;
          })
      }
      .backgroundColor(Color.White)
      .borderRadius('24vp')

      Button('注册')
        .id('loginButtonId')
        .width('100%')
        .height('40vp')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#007DFF')
        .margin({
          top: '68vp',
          bottom: '12vp'
        })
        .onClick(async () => {
          const success = await LoginUtils.register(this.account, this.password, this.password_again)
          if (success) {
            this.pageStack.replacePathByName('Main', null, false)
          }
        })
      Text('返回登录')
        .fontColor('#007DFF')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          this.login = true
        })
    }
    .padding({
      left: '12vp',
      right: '12vp',
    })
    .backgroundColor('#F1F3F5')
    .height('63%')
  }
}

@Extend(TextInput) function inputStyle() {
  .placeholderColor('#99182431')
  .height('48vp')
  .fontSize('16fp')
  .backgroundColor(Color.White)
  .margin({ top: '4vp' })
  .padding({ left: 12 })
}

@Extend(Text) function blueTextStyle() {
  .fontColor('#007DFF')
  .fontSize('14fp')
  .fontWeight(FontWeight.Medium)
}