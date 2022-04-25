// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:unknown/page/search/search_index.dart';

class SearchPage extends GetView<SearchLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("搜索"),
      //   elevation: 0,
      // ),
      floatingActionButton: MaterialButton(onPressed: controller.showLog,child: Text("+"),),
      body: Column(
        children: [
          Container(
            height: 84,
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      width: 700,
                      height: 44,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.search),
                            Expanded(
                                child: TextField(
                              controller: controller.textEditingController,
                              onChanged: controller.onTextChange,
                              onSubmitted: controller.onSearch,
                              cursorColor: Theme.of(context).primaryColor,
                              autofocus: true,
                              // keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 5, bottom: 10),
                                  border: InputBorder.none,
                                  hintText: "搜索"),
                            )),
                            Obx(() {
                              return controller.state.keyword == ""
                                  ? Container()
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: controller.onClear,
                                    );
                            })
                          ]),
                    )),
                    GestureDetector(
                        onTap: controller.onCancel, child: Padding(padding: EdgeInsets.only(right: 10),child: const Text("取消"),))
                  ],
                ),
              )
            ]),
          ),
          TabBar(
            isScrollable: true,
            tabs: controller.tabs,
            controller: controller.tabController,
          ),
          Expanded(
              child: TabBarView(
                  controller: controller.tabController,
                  children: const [
                Text("搜索"),
                Text("搜索"),
              ]))
        ],
      ),
    );
  }
}
