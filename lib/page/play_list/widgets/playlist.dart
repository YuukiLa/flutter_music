import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/page/play_list/play_list_index.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class PlaylistWidget extends StatefulWidget {
  late String platform;
  late int index;
  PlaylistWidget({Key? key,required this.platform,required this.index}) : super(key: key);

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetState(platform,index);
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  final controller = Get.find<PlayListLogic>();
  late String platform;
  late int index;
  _PlaylistWidgetState(this.platform,this.index);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: SmartRefresher(
            controller: controller.refreshControllerMap[platform]??RefreshController(),
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
                        itemCount: controller.state.filter.isEmpty? 0 :controller.state.filter[index].recommend.length,
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
                      childCount: controller.state.playlist[index].length),
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
  Widget _buildTag(BuildContext context, int itemIndex) {
    return Obx(() {
      return ChoiceChip(
        label: Text(controller.state.filter[index].recommend[itemIndex].name),
        selected: controller.state.currFilter[index]==itemIndex,
        onSelected: (bool value) { controller.state.currFilter[index]=itemIndex; },);
    });
  }
  Widget _buildItem(BuildContext context, int itemIndex) {
    return GestureDetector(
      onTap: ()=> controller.onPlaylistTap(itemIndex),
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
            child: CachedNetworkImage(imageUrl:controller.state.playlist[index][itemIndex].coverImgUrl,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover),
          ),
          Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            // clipBehavior: Clip.antiAlias,
            child: Text(
              controller.state.playlist[index][itemIndex].title,
              style: const TextStyle(color: Colors.black38, fontSize: 12),
            ),
          )
        ],
      ),
    ));
  }
}
