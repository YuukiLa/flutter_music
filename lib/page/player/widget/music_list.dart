import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unknown/page/player/player_index.dart';

import '../../../common/model/song.dart';

class MusicList extends GetView<PlayerLogic> {
  const MusicList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '当前播放',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  TextSpan(
                    text: '(${controller.state.listLen.value})',
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
            Container(
                width: double.infinity,
                height: 30,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.repeat,
                              color: Colors.black38,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '列表循环',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: const Icon(
                              Icons.library_add,
                              color: Colors.black38,
                              size: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.black38,
                              size: 18,
                            ),
                          ),
                        ],
                      )
                    ])),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _createListItem(index);
                  },
                  itemCount: controller.state.listLen.value,
                ),
              flex: 1,
            )
          ],
        );
      }),
    );
  }

  Widget _createListItem(int index) {
    return Obx(() {
      Song song = controller.state.list[index];
      bool isPlay = song.id == controller.state.currsong.value.id;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 下标跳转
          controller.playIndex(index);
        },
        child: Container(
          width: double.infinity,
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    isPlay
                        ? Container(
                      height: 20,
                      width: 20,
                      margin: const EdgeInsets.only(right: 5),
                      child: const LoadingIndicator(
                        indicatorType: Indicator.lineScaleParty,
                        colors: [Colors.red],
                      ),
                    )
                        : const SizedBox(),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: song.title,
                              style: TextStyle(
                                color: isPlay ? Colors.red : Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: ' - ${song.artist}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isPlay ? Colors.red : Colors.black38,
                              ),
                            )
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      flex: 1,
                    )
                  ],
                ),
                flex: 1,
              ),
              const InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.black38,
                  size: 18,
                ),
              ),
            ],
          ),

        ),
      );
    });

  }
}
