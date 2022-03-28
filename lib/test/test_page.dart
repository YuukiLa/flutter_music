import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/test/state.dart';

import 'logic.dart';

class TestPage extends StatelessWidget {
  final logic = Get.put(TestLogic());
  final state = Get.find<TestLogic>().state;

  TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("counter"),
      ),
      body: Container(
        child: GetBuilder<TestLogic>(
          builder: (logic) {
            return Text(state.count.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> logic.increase(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
