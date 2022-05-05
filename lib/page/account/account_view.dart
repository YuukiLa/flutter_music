import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/user.dart';

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
            _accountWidget(Platform.Netease),
            const SizedBox(
              height: 40,
            ),
            _accountWidget(Platform.QQ),
          ],
        ));
    // });
  }

  Widget _accountWidget(String source) {
    return Obx(() {
      UserModel user = source == Platform.Netease
          ? controller.state.neteaseUser.value
          : controller.state.qqUser.value;
      bool isLogin = user.id != "";
      return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
          padding: const EdgeInsets.only(left: 5, right: 5),
          height: 90,
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
                alignment: Alignment.bottomCenter,
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
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              )
            ],
          ));
    });
  }
}
