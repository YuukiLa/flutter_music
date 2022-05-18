import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/user.dart';
import 'package:unknown/common/utils/dialog.dart';

import 'account_logic.dart';

class AccountPage extends GetView<AccountLogic> {
  @override
  Widget build(BuildContext context) {
    // return Obx((){
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.refreshUserInfo();
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.refresh),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            _accountWidget(context, Platform.Netease),
            const SizedBox(
              height: 40,
            ),
            _accountWidget(context, Platform.QQ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "本地歌单",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
            _localPlaylist(context),
          ],
        ));
    // });
  }

  _showDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("创建歌单"),
          contentPadding: EdgeInsets.only(left: 25),
          children: [
            Container(
              child: TextField(
                controller: controller.textEditingController,
                onChanged: controller.onTextChange,
                cursorColor: Theme.of(context).primaryColor,
                autofocus: true,
                // keyboardType: TextInputType.text,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    border: InputBorder.none,
                    hintText: "歌单名"),
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
                TextButton(
                    onPressed: () {
                      controller.createPlaylist(context);
                    },
                    child: Text(
                      "确定",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            )
          ],
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.bounceInOut,
      duration: Duration(seconds: 1),
    );
  }

  Widget _localPlaylist(BuildContext context) {
    return Obx(() {
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15,bottom: 10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.black12,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
              children: controller.state.localPlaylist.map((playlist) {
            return InkWell(
              onTap: () {
                controller.gotoLocalPlaylist(playlist.id, playlist.title);
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
                    GestureDetector(
                        onTapDown: (TapDownDetails detail) {
                          DialogUtil.showPopupMenu(context, detail.globalPosition.dx, detail.globalPosition.dy, ["删除歌单"], (int index) {

                          });
                        },
                        child:  Icon(Icons.more_vert_sharp)
                    )
                  ],
                ),
              ),
            );
          }).toList()));
    });
  }

  Widget _accountWidget(BuildContext context, String source) {
    return Obx(() {
      UserModel user = source == Platform.Netease
          ? controller.state.neteaseUser.value
          : controller.state.qqUser.value;
      bool isLogin = user.id != "";
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
          padding: const EdgeInsets.only(left: 5, right: 5),
          height: isLogin ? 130 : 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.black12,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    margin: const EdgeInsets.only(right: 5, left: 10),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(244, 240, 242, 1),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(width: 1, color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 1,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: isLogin
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.avatar,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          )
                        : Image.asset(
                            "images/common/${source}.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                      controller.goto(source);
                    },
                    child: isLogin
                        ? Text(
                            user.nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$source-未登录",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                            ],
                          ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
              ),
              isLogin
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.gotoRecommand(source);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.recommend,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Text("日推")
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      controller.gotoPlaylist(source);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.queue_music_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text("歌单")
                                      ],
                                    )),
                                flex: 1),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ));
    });
  }
}
