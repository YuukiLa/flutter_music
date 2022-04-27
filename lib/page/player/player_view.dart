import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'player_logic.dart';

class PlayerPage extends GetView<PlayerLogic> {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          controller.state.currsong.id.isEmpty
              ? Image.asset(
                  controller.state.currsong.imgUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                )
              : Image.network(
                  controller.state.currsong.imgUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
          ClipRect(
            // 这个必须有不然会全部模糊
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 50,
                sigmaX: 50,
              ),
              child: Container(),
            ),
          ),
          AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  controller.state.currsong.title,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  controller.state.currsong.artist,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Obx(() {
            return Container(
                margin: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top),
                child: Column(
                  children: [
                    // 中间部分 分封页和歌词页
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: controller.changeSwitchIndex,
                        child: IndexedStack(
                          index: controller.state.switchIndex.value,
                          children: [
                            // 封面
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      margin: EdgeInsets.only(top: 100),
                                      alignment: Alignment.center,
                                      height: 260,
                                      width: 260,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child:
                                            controller.state.showplanet.value
                                                ? SizedBox()
                                                : SizedBox(),
                                          ),
                                          RotationTransition(
                                            turns: controller.animationController,
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                  'images/common/bet.png',
                                                  width: 260,
                                                  height: 260,
                                                ),
                                                Container(
                                                    width: 260,
                                                    height: 260,
                                                    alignment: Alignment.center,
                                                    child: Hero(
                                                      tag: "playing",
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            260),
                                                        child: controller
                                                            .state
                                                            .currsong
                                                            .id
                                                            .isEmpty
                                                            ? SizedBox()
                                                            : Image.network(
                                                            controller
                                                                .state
                                                                .currsong
                                                                .imgUrl,
                                                            width: 180,
                                                            height: 180,
                                                            fit:
                                                            BoxFit.cover),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                            // 歌词页
                            Container(
                              child: Text("歌词"),
                            )
                            // LyricPage(model),
                          ],
                        ),
                      ),
                      // flex: 1,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: 0, left: 15, right: 15, bottom: 15),
                    //   child: SongProgressWidget(model),
                    // ),
                    // PlayBottomMenuWidget(model),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              // height: 400,
              // color: Colors.black,
            );
          })

        ],
      ),
    );
  }
}
