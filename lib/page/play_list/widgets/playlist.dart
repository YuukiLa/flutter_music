import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:unknown/page/play_list/play_list_index.dart';

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
        child: GridView.builder(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: controller.state.playlist.length,
            itemBuilder: controller.createItem
        ),
      );
    });
  }
}

