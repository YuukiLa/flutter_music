import 'package:cached_network_image/cached_network_image.dart';
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
                ListView.separated(
                    itemBuilder: _buildSongItem,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container();
                    },
                    itemCount: controller.state.songs.length),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: SizedBox(
                        width: 250,
                        height: 45,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.collections_bookmark,size: 15,),
                                      Text("收藏")
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.play_arrow,size: 15,),
                                        Text("播放全部")
                                      ],
                                    ),
                                  )
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.chair,size: 15,),
                                        Text("选择")
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      )),
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
        toolbarHeight: 90,
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: 400,
                              child: Obx(() {
                                if (controller.state.image.value == "") {
                                  return const SizedBox(
                                    height: 400,
                                  );
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
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: controller.state.songs[index]["img_url"],
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.state.songs[index]["title"],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    controller.state.songs[index]["artist"],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
