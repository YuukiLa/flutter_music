import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/page/play_list/play_list_index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class PlaylistWidget extends StatefulWidget {
  const PlaylistWidget({Key? key}) : super(key: key);

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  final controller = Get.find<PlayListLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            enablePullUp: true,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                      child: ListView.separated(
                        itemBuilder: _buildTag,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.filter.recommend.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const VerticalDivider(
                            width: 10,
                            color: Colors.transparent,
                          );
                        },
                      ),
                    )
                ),

                // if (controller.state.playlist.isEmpty) {
                //   return SliverToBoxAdapter(
                //     child: Container(
                //       child: Text("这里放标签"),
                //     ),
                //   );
                // }
                SliverWaterfallFlow(
                  delegate: SliverChildBuilderDelegate(_buildItem,
                      childCount: controller.state.playlist.length),
                  gridDelegate:
                  const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),

                )
              ],
            )),
      );
    });
  }
  Widget _buildTag(BuildContext context, int index) {
    return Obx(() {
      return ChoiceChip(
        label: Text(controller.filter.recommend[index].name),
        selected: controller.state.currFilter.value==index,
        onSelected: (bool value) { controller.state.currFilter.value=index; },);
    });
  }
  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: ()=> controller.onPlaylistTap(index),
        child: Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Card(
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: Image.network(controller.state.playlist[index].coverImgUrl,
                fit: BoxFit.cover),
          ),
          Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            // clipBehavior: Clip.antiAlias,
            child: Text(
              controller.state.playlist[index].title,
              style: const TextStyle(color: Colors.black38, fontSize: 12),
            ),
          )
        ],
      ),
    ));
  }
}
