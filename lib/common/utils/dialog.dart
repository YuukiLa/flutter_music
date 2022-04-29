import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DialogUtil {
  static showLoading() {
    EasyLoading.showProgress(0.3,
        status: '加载中...', maskType: EasyLoadingMaskType.black);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static toast(String text) {
    EasyLoading.showToast(text, toastPosition: EasyLoadingToastPosition.bottom);
  }

  static showPopupMenu(BuildContext context, double x, double y,
      List<String> items, Function callback) {
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    RelativeRect position = RelativeRect.fromRect(
        Rect.fromLTRB(x, y, x + 50, y - 50), Offset.zero & overlay.size);
    var popupMenuItems = <PopupMenuItem>[];
    for (var i = 0; i < items.length; i++) {
      popupMenuItems.add(PopupMenuItem(
        child: Text(items[i]),
        value: i,
      ));
    }
    showMenu(context: context, position: position, items: popupMenuItems).then(
      (value) {
        print(value);
        callback(value);
      },
    );
  }
}
