import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'player_logic.dart';

class PlayerPage extends GetView<PlayerLogic> {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ButtonBar(
        children: [
          MaterialButton(onPressed: ()=> controller.saveSong(),child: Text("存个数据"),),
          MaterialButton(onPressed: ()=> controller.getSong(),child: Text("取个数据"),)
        ],
      ),
    );
  }
}
