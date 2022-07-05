import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/play_state.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/utils/format.dart';
import 'package:unknown/page/player/player_logic.dart';

class Lyric extends GetView<PlayerLogic> {
  const Lyric({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LyricsReader(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        model: LyricsModelBuilder.create()
            .bindLyricToMain(PlayerService.instance.lyric.value)
            .getModel(),
        position: controller.state.currPosition.value,
        lyricUi: controller.lyricUI,
        playing: PlayerService.instance.playState.value == PlayState.PALYING,
        size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
        emptyBuilder: () => Center(
          child: Text(
            "没找到歌词",
            style: controller.lyricUI.getOtherMainTextStyle(),
          ),
        ),
        selectLineBuilder: (progress, confirm) {
          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    print("点击事件");
                    confirm.call();
                    controller.progressChange(progress.toDouble());
                    // setState(() {
                    //   audioPlayer?.seek(Duration(milliseconds: progress));
                    // });
                  },
                  icon: Icon(Icons.play_arrow,
                      color: Theme.of(context).primaryColor)),
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  height: 1,
                  width: double.infinity,
                ),
              ),
              Text(
                TimeFormatUtil.timeFormat(progress),
                style: TextStyle(color: Theme.of(context).primaryColor),
              )
            ],
          );
        },
      ),
    );
  }
}
