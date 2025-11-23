import { AppStorageV2, PromptAction, UIContext } from '@kit.ArkUI';
import Logger from './Logger'

/**
 * Common operation tools.
 */
export class CommonUtils {
  /**
   * Router page
   *
   * @param {string} url page url
   */
  public routerPage(url: string): void {
    const uiContext: UIContext | undefined = AppStorage.get('uiContext');
    uiContext!.getRouter().replaceUrl({
      url: url
    }).catch((error: Error) => {
      Logger.error('CommonUtils', 'replace url error ' + JSON.stringify(error));
    });
  }

  /**
   * Show toast content.
   *
   * @param {string} content content to show
   */
  public showToastContent(content: string): void {
    const uiContext: UIContext = AppStorageV2.connect(UIContext, 'uiContext', () => new UIContext())!;
    try {
      uiContext!.getPromptAction().showToast({
        message: content,
        duration: 3000
      });
    } catch (error) {
      Logger.error('CommonUtils', `show toast failed: ${JSON.stringify(error)}`);
    }
  }
}

export default new CommonUtils();