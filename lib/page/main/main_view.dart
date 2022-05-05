import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/widget/keep_alive_wrapper.dart';
import 'package:unknown/page/account/account_index.dart';
import 'package:unknown/page/play_list/play_list_index.dart';
import 'package:unknown/page/player/player_index.dart';

import 'main_logic.dart';

class MainPage extends GetView<MainLogic> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Unknown"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => {controller.gotoSearch()},
                icon: const Icon(Icons.search))
          ],
          elevation: 0,
        ),
        floatingActionButton: GestureDetector(
          onTap: controller.gotoPlayer,
          onHorizontalDragStart: controller.onHorizontalDragStart,
          onHorizontalDragUpdate: controller.onHorizontalDragUpdate,
          onHorizontalDragEnd: controller.onHorizontalDragEnd,
          child: ClipOval(
            child: PlayerService.instance.currSong.value.id == ""
                ? Image.asset(
                    PlayerService.instance.currSong.value.imgUrl,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    PlayerService.instance.currSong.value.imgUrl,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: Theme.of(context).primaryColor,
        //   child: Icon(Icons.play_arrow, color: Colors.white),
        // ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: PageView(
          children: [
            KeepAliveWrapper(PlayListPage()),
            // PlayerPage(),
            KeepAliveWrapper(AccountPage()),
          ],
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageChange,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            // BottomNavigationBarItem(icon: Icon(Icons.apple), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: controller.state.currPage,
          onTap: controller.onBottomTap,
        ),
      );
    });
  }
}
