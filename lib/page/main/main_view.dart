import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/page/play_list/play_list_index.dart';

import 'main_logic.dart';

class MainPage extends GetView<MainLogic> {
  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return Scaffold(
        appBar: AppBar(title: const Text("Yuuki"),elevation: 0,),
        body: PageView(
          children: [
            PlayListPage(),
            Center(child: Text("2"),),
            Center(child: Text("3"),),
          ],
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onPageChange,

        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: ""
            ), BottomNavigationBarItem(
                icon: Icon(Icons.apple),
                label: ""
            ),BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: ""
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.state.currPage,
          onTap: controller.onBottomTap,
        ),
      );
    });
  }
}