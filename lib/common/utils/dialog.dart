import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/song.dart';
import '../service/storage.dart';

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

  static showCollectPlaylist(BuildContext context,Function(String id) callback) async{
    var list = await StorageService.to.getPlaylists();
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("选择歌单"),
          contentPadding: EdgeInsets.only(left: 0),
          children: [
            Container(
              child: Column(
                children: list.map((playlist)
                {
                  return InkWell(
                    onTap: () {
                      callback(playlist.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.circular(8)),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              "images/common/local_img.png",
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    playlist.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "取消",
                      style: TextStyle(color: Colors.black45),
                    )),
                // TextButton(
                //     onPressed: () {
                //
                //     },
                //     child: Text(
                //       "确定",
                //       style: TextStyle(color: Theme.of(context).primaryColor),
                //     ))
              ],
            )
          ]
          ,
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.bounceInOut,
      duration: Duration(seconds: 1),
    );
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
