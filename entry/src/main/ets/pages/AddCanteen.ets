// AddCanteen.ets
import { PageTitle } from '../components/common/PageTitle';
import { CanteenReq } from '../types/canteen';
import CanteenUtils from '../utils/CanteenUtils';
import { emitter } from "@kit.BasicServicesKit";

const EMITTER_ID = "refreshCanteen";
@Builder
export function AddCanteenBuilder() {
  AddCanteen()
}

@Preview
@Component
struct AddCanteen {
  pathStack: NavPathStack = new NavPathStack()

  private form: CanteenReq = {
    canteenName: '',
    location: '',
    businessHours: '',
    description: '',
    recommendation: '',
    campus: '',
    coverUrl: ''
  };

  build() {
    NavDestination() {
      Column() {
        PageTitle({ title: "添加食堂" })
        TextInput({ placeholder: '请输入食堂名称' })
          .onChange((value) => this.form.canteenName = value)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入位置' })
          .onChange((value) => this.form.location = value)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入营业时间' })
          .onChange((value) => this.form.businessHours = value)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入描述' })
          .onChange((value) => this.form.description = value)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入推荐理由' })
          .onChange((value) => this.form.recommendation = value)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入校区' })
          .onChange((value) => this.form.campus = value)
          .margin({ bottom: 8 })

        // TextInput({ placeholder: '请输入图片URL' })
        //   .onChange((value) => this.form.coverUrl = value)

        Button('保存')
          .onClick(async () => {
            await CanteenUtils.createCanteen(this.form)
            emitter.emit(EMITTER_ID);
            this.pathStack.pop()
          })
      }
      .padding(16)
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }
}