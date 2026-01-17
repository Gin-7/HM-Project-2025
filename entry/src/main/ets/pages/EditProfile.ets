// pages/EditProfilePage.ets
import { AppStorageV2 } from '@kit.ArkUI';
import { PageTitle } from '../components/common/PageTitle';
import { GlobalUserInfo } from '../types/Types';
import UserInfoUtils from '../utils/UserInfoUtils';

@Builder
export function EditProfileBuilder() {
  EditProfilePage()
}

@Preview
@Component
export struct EditProfilePage {
  pathStack: NavPathStack = new NavPathStack()

  userInfo: GlobalUserInfo = AppStorageV2.connect(GlobalUserInfo, 'globalUserInfo', () => new GlobalUserInfo())!;

  @State gender: string = this.userInfo.gender || 'MALE';
  @State age: string = (this.userInfo.age || 18).toString();

  build() {
    NavDestination() {
      Column() {
        PageTitle({ title: "编辑个人资料"})

        Column({ space: 24 }) {
          // 性别选择
          Column({ space: 8 }) {
            Text('性别')
              .fontSize(16)
              .fontColor('#333333')
              .alignSelf(ItemAlign.Start)
            Row() {
              this.GenderOption('男', 'MALE')
              this.GenderOption('女', 'FEMALE')
            }
            .width('100%')
          }

          // 年龄输入
          Column({ space: 8 }) {
            Text('年龄')
              .fontSize(16)
              .fontColor('#333333')
              .alignSelf(ItemAlign.Start)
            TextInput({ placeholder: '请输入年龄', text: this.age })
              .type(InputType.Number)
              .width('100%')
              .height(48)
              .borderRadius(8)
              .backgroundColor('#FFFFFF')
              .padding(12)
              .onChange((value: string) => {
                this.age = value;
              })
          }

          // 保存按钮
          Button('保存')
            .width('100%')
            .height(48)
            .backgroundColor('#007DFF')
            .fontColor('#FFFFFF')
            .borderRadius(8)
            .onClick(this.saveProfile)
        }
        .padding({ left: 16, right: 16 })

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }

  @Builder
  GenderOption(label: string, value: string) {
    Row() {
      Circle({ width: 12, height: 12 })
        .stroke(this.gender === value ? '#007DFF' : '#CCCCCC').strokeWidth(2)
        .fill(this.gender === value ? '#007DFF' : '#FFFFFF')
      Text(label)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ left: 8 })
    }
    .layoutWeight(1)
    .onClick(() => {
      this.gender = value;
    })
  }

  saveProfile = async () => {
    UserInfoUtils.update(this.userInfo.userId, this.gender, parseInt(this.age))
  };
}