
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Dialog {
  static showLoading() {
    EasyLoading.showProgress(0.3, status: '加载中...',maskType: EasyLoadingMaskType.black);
  }


  static dismiss() {
    EasyLoading.dismiss();
  }
}