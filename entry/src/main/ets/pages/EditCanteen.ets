// EditCanteen.ets
import { Canteen, CanteenParams, CanteenReq } from '../types/canteen';
import CanteenUtils from '../utils/CanteenUtils';
import { AppStorageV2 } from '@kit.ArkUI';
import { PageTitle } from '../components/common/PageTitle';
import { emitter } from "@kit.BasicServicesKit";

const EMITTER_ID = "refreshCanteen";

@Builder
export function EditCanteenBuilder() {
  EditCanteen()
}

@Preview
@Component
struct EditCanteen {
  pathStack: NavPathStack = new NavPathStack()

  canteen: Canteen | null = null
  canteenId: number = 1;

  private form: CanteenReq = {
    canteenName: '',
    location: '',
    businessHours: '',
    description: '',
    recommendation: '',
    campus: '',
    coverUrl: ''
  };

  private async loadCanteen() {
    if (this.canteen) {
      this.form = {
        canteenName: this.canteen.canteenName,
        location: this.canteen.location || '',
        businessHours: this.canteen.businessHours || '',
        description: this.canteen.description || '',
        recommendation: this.canteen.recommendation || '',
        campus: this.canteen.campus || '',
        coverUrl: this.canteen.coverUrl || ''
      };
    } else {
      console.error('加载食堂失败');
    }
  }

  build() {
    NavDestination() {
      Column() {
        PageTitle({ title: "编辑食堂" })

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

        Row() {
          Button('保存')
            .onClick(async () => {
              await CanteenUtils.updateCanteen(this.canteenId, this.form)
              emitter.emit(EMITTER_ID);
              this.pathStack.pop()
            })
        }
        .padding({ top: 16 })
      }
      .padding(16)
    }
    .onReady((context: NavDestinationContext) => {
      const params: CanteenParams = context.pathInfo.param as CanteenParams;
      this.canteen = params?.canteen;
      this.canteenId = this.canteen.id;
      this.loadCanteen()
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }
}