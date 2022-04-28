import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:unknown/common/utils/format.dart';
import 'package:unknown/page/player/player_index.dart';

class SongProgressWidget extends GetView<PlayerLogic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Obx(() {
        return Row(
          children: [
            Text(
              "${TimeFormatUtil.timeFormat(controller.state.currPosition.value)}",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            Expanded(
              child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                  ),
                  child: Slider(
                    value: controller.state.currPosition.value.toDouble(),
                    onChanged: (data) {},
                    onChangeStart: (data) {},
                    onChangeEnd: (data) {},
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    min: 0,
                    max: controller.state.currsong.time.toDouble(),
                  )),
            ),
            Text(
              TimeFormatUtil.timeFormat(controller.state.currsong.time),
              style: const TextStyle(fontSize: 12, color: Colors.white30),
            ),
          ],
        );
      }),
    );
  }
}
