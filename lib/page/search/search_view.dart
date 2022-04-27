// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/widget/song_item.dart';
import 'package:unknown/page/search/search_index.dart';

class SearchPage extends GetView<SearchLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("搜索"),
      //   elevation: 0,
      // ),
      body: Column(
        children: [
          Container(
            height: 84,
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      width: 700,
                      height: 44,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.search),
                            Expanded(
                                child: TextField(
                              controller: controller.textEditingController,
                              onChanged: controller.onTextChange,
                              onSubmitted: controller.onSearch,
                              cursorColor: Theme.of(context).primaryColor,
                              autofocus: true,
                              // keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 5, bottom: 10),
                                  border: InputBorder.none,
                                  hintText: "搜索"),
                            )),
                            Obx(() {
                              return controller.state.keyword == ""
                                  ? Container()
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: controller.onClear,
                                    );
                            })
                          ]),
                    )),
                    GestureDetector(
                        onTap: controller.onCancel,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: const Text("取消"),
                        ))
                  ],
                ),
              )
            ]),
          ),
          TabBar(
            isScrollable: true,
            tabs: controller.tabs,
            indicatorColor: Theme.of(context).primaryColor,
            controller: controller.tabController,
          ),
          Expanded(
              child:
                  TabBarView(controller: controller.tabController, children: [
            Obx(() {
              return SmartRefresher(
                  controller: controller.refreshControllers[0],
                  enablePullDown: false,
                  enablePullUp: true,
                  onLoading: controller.onLoad,
                  child: ListView.separated(
                      itemBuilder: ((context, index) {
                        return _buildSongItem(context, index, 0);
                      }),
                      separatorBuilder: (BuildContext context, int index) {
                        return Container();
                      },
                      itemCount: controller.state.songs[0].length));
            }),
            Obx(() {
              return SmartRefresher(
                controller: controller.refreshControllers[1],
                enablePullDown: false,
                enablePullUp: true,
                onLoading: controller.onLoad,
                child: ListView.separated(
                    itemBuilder: ((context, index) {
                      return _buildSongItem(context, index, 1);
                    }),
                    separatorBuilder: (BuildContext context, int index) {
                      return Container();
                    },
                    itemCount: controller.state.songs[1].length),
              );
            })
          ]))
        ],
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, int index, int type) {
    return InkWell(
        onTap: () {
          controller.playSong(controller.state.songs[type][index]);
        },
        child: SongItem(
          song: controller.state.songs[type][index],
        ));
  }
}
