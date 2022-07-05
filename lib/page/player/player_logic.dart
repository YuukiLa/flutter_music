import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/play_state.dart';
import 'package:unknown/common/service/player_service.dart';

import 'player_state.dart';

class PlayerLogic extends GetxController with GetTickerProviderStateMixin {
  final PlayerState state = PlayerState();

  final lyricUI = UINetease();
  late AnimationController animationController;
  late StreamSubscription<Duration> listener;
  late LyricsReaderModel lyricModel;

  @override
  void onInit() {
    state.currsong.value = PlayerService.instance.audioHandler.currPlaying;
    animationController =
        AnimationController(duration: Duration(seconds: 20), vsync: this);
    animationController.addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        // 如果转完一圈过后继续转
        animationController.reset();
        animationController.forward();
      }
    });
    state.listLen.value = PlayerService.instance.audioHandler.songsLen;
    state.list.addAll(PlayerService.instance.audioHandler.songList);
    state.isPlaying.value = PlayerService.instance.audioHandler.isPlaying;
    if (state.isPlaying.value) {
      animationController.forward();
    }
    state.currPosition.value = PlayerService.instance.audioHandler.playPosition;
    //监听播放进度
    listener = PlayerService.instance.addPlayingListener((Duration position) {
      // print("${position.inMilliseconds}---${state.currsong.value.time}");
      if (position.inMilliseconds > state.currsong.value.time) {
        state.currPosition.value = state.currsong.value.time;
        return;
      }
      state.currPosition.value = position.inMilliseconds;
    });
    //歌词模型
    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(PlayerService.instance.lyric.value)
        .getModel();
    super.onInit();
  }

  changeSwitchIndex() {
    state.switchIndex.value = state.switchIndex.value == 0 ? 1 : 0;
  }

  //拖动进度条
  progressChange(double data) {
    print(data);
    PlayerService.instance.seek(data);
  }

  skip(bool isNext) {
    isNext ? PlayerService.instance.next() : PlayerService.instance.previous();
    state.currsong.value =
        state.list[PlayerService.instance.audioHandler.curIndex];
  }

  //切换播放状态
  changePlayState() {
    if (state.currsong.value.url == '') {
      return;
    }
    if (PlayerService.instance.playState.value == PlayState.PALYING) {
      PlayerService.instance.pause();
      animationController.stop();
    } else {
      PlayerService.instance.resume();
      animationController.forward();
    }
  }

  //播放指定下标
  playIndex(int index) {
    PlayerService.instance.playIndex(index);
    state.currsong.value = state.list[index];
  }

  @override
  void onClose() {
    animationController.dispose();
    PlayerService.instance.removePlayingListener(listener);
    super.onClose();
  }
}
