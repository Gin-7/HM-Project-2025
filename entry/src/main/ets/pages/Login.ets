import { AppStorageV2 } from '@kit.ArkUI'
import LoginUtils from '../utils/LoginUtils'

@Builder
export function LoginBuilder() {
  Login()
}

/**
 * The login page consists of two components.
 * LoginTitle and LoginBottom, which can be invoked by directly referencing the control.
 */
@Preview
@Component
struct Login {
  build() {
    NavDestination() {
      Column() {
        // Title component
        LoginTitle()
        // Bottom component
        LoginBottom()
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
            // CommonUtils.showToastContent($r('app.string.incomplete_toast'));
          })
        Text('忘记密码')
          .blueTextStyle()
          .onClick(() => {
            // CommonUtils.showToastContent($r('app.string.incomplete_toast'));
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
        .onClick(() => {
          if (LoginUtils.login(this.account, this.password)) {
            this.pageStack.replacePathByName('Main', null, false)
          }
        })
      Text('注册账号')
        .fontColor('#007DFF')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          // CommonUtils.showToastContent($r('app.string.incomplete_toast'));
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