// pages/Canteen.ets
import canteenUtils from '../utils/CanteenUtils';
import { Canteen } from '../types/canteen';
import { CanteenCard } from '../components/CanteenCard';
import router from '@ohos.router';
import MockUtils from '../utils/MockUtils'
import { AppStorageV2 } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';


@Preview
@Component
export struct CanteenPage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  @State canteens: Canteen[] = [];
  @State filteredCanteens: Canteen[] = [];
  @State searchKeyword: string = '';
  @State campusFilter: string = ''; // 可选：默认空表示全部

  aboutToAppear() {
    this.loadCanteens();
    emitter.on("refreshCanteen", () => this.loadCanteens());
  }

  aboutToDisappear(): void {
    emitter.off("refreshCanteen");
  }

  private async loadCanteens() {
    const data = await canteenUtils.getAllCanteens();
    this.canteens = data ? data : MockUtils.mockCanteens()
    this.applyFilter();
  }

  private applyFilter() {
    let result = this.canteens;
    console.info(JSON.stringify(this.canteens))

    // 按校区过滤（可选）
    if (this.campusFilter) {
      result = result.filter(c => c.campus?.includes(this.campusFilter));
    }

    // 按关键词搜索
    if (this.searchKeyword) {
      console.info(this.searchKeyword)
      const k = this.searchKeyword.toLowerCase();
      result = result.filter(c =>
      (c.canteenName?.toLowerCase().includes(k)) ||
        (c.location?.toLowerCase().includes(k)) ||
        (c.description?.toLowerCase().includes(k)) ||
        (c.campus?.toLowerCase().includes(k)) ||
        (c.recommendation?.toLowerCase().includes(k))
      );
    }

    this.filteredCanteens = result;
  }

  private onSearchChange(value: string) {
    this.searchKeyword = value;
    this.applyFilter();
  }

  build() {
    Column() {
      // 搜索栏 + 添加按钮
      Row() {
        TextInput({
          placeholder: '搜索食堂名称、位置、校区...',
          text: this.searchKeyword
        })
          .onChange((value: string) => {
            this.onSearchChange(value);
          })
          .width('80%')
          .margin({ right: 20 })

        Button('+')
          .fontSize(24)
          .width(40)
          .height(40)
          .backgroundColor('#4A90E2')
          .fontColor(Color.White)
          .borderRadius(20)
          .borderWidth(0)
          .padding(0)
          .onClick(() => {
            this.pathStack.pushPathByName('AddCanteen', null, false)
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 食堂列表
      if (this.filteredCanteens.length === 0) {
        Text('暂无食堂数据')
          .fontColor('#999')
          .margin({ top: 50 })
      } else {
        List() {
          ForEach(this.filteredCanteens, (item: Canteen) => {
            ListItem() {
              CanteenCard({ canteen: item })
            }
          })
        }
        .width('90%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10 })
    .backgroundColor('#F5F5F5')
  }
}