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
    return Container(
      child: SmartRefresher(
          controller: controller.refreshController,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  child: Text("这里放标签"),
                ),
              ),
              Obx(() {
                if (controller.state.playlist.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      child: Text("这里放标签"),
                    ),
                  );
                }
                return SliverWaterfallFlow(
                  delegate: SliverChildBuilderDelegate(_buildItem),
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    collectGarbage: (List<int> garbages) {
                      print('collect garbage : $garbages');
                    },
                    viewportBuilder: (int firstIndex, int lastIndex) {
                      print('viewport : [$firstIndex,$lastIndex]');
                    },
                  ),
                );
              })
            ],
          )),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
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
