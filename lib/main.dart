import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/common/route/app_pages.dart';
import 'package:unknown/common/route/app_routes.dart';
import 'package:unknown/page/main/main_view.dart';
import 'package:unknown/test/test_page.dart';

import 'global.dart';

Future<void> main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'unknown',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages(),
      initialRoute: AppRoutes.INITIAL,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255,250,199,59)
      ),
      themeMode: ThemeMode.system,
    );
  }
}

