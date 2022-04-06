import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'song_list_logic.dart';

class SongListPage extends GetView<SongListLogic> {
  const SongListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.depth == 0) {
            //滚动且是列表滚动的时候
            controller.onScroll(scrollNotification.metrics.pixels);
          }
          return true;
        },
        child: NestedScrollView(
          headerSliverBuilder: _buildHeader,
          body: Obx(() {
            return Stack(
                children: [
                  ListView.separated(itemBuilder: _buildSongItem,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container();
                  }, itemCount: controller.state.songs.length),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: null,
                    ),
                  ),
                ],
            );
          }),
        ),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        floating: false,
        primary: false,
        expandedHeight: 400,
        backgroundColor: Colors.white,
        leadingWidth: 0,
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        toolbarHeight: 80,
        title: Obx(() {
          return Opacity(
            opacity: controller.state.appBarAlpha.value,
            child: AppBar(
              title: Text(
                controller.state.title.value,
              ),
            ),
          );
        }),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Container(
                                  height: 400,
                                  child: Obx(() {
                                    if (controller.state.image.value == "") {
                                      return SizedBox(height: 400,);
                                    }
                                    return Image.network(
                                      controller.state.image.value,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                                )
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )),
        ),
      )
    ];
  }

  Widget _buildSongItem(BuildContext context, int index) {
    return InkWell(
      onTap: () => controller.onSongClick(index),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        height: 70,
        child: Row(
          children: [
            Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(controller.state.songs[index]["img_url"],
                  fit: BoxFit.cover),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.state.songs[index]["title"],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(controller.state.songs[index]["artist"],
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45
                      ),),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
