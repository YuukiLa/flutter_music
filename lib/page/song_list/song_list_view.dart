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
          body: Container(),
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
        expandedHeight: 650,
        backgroundColor: Colors.white,
        leadingWidth: 0,
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        toolbarHeight: 100,
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
                              child: Obx((){
                                if(controller.state.image.value=="") {
                                  return SizedBox(height: 400,);
                                }
                                return Image.network(
                                  controller.state.image.value,
                                  fit: BoxFit.cover,
                                );
                              }),
                            )
                          ],
                        ))
                      ],
                    ),
                  )
                ],
              )),
        ),
      )
    ];
  }
}
