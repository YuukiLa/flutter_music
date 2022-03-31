import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/route/app_pages.dart';
import 'package:unknown/common/route/app_routes.dart';

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
    return RefreshConfiguration(
        headerBuilder: () => const ClassicHeader(),
        footerBuilder: () => const ClassicFooter(),
        hideFooterWhenNotFull: true,
        headerTriggerDistance: 80,
        maxOverScrollExtent: 100,
        footerTriggerDistance: 150,
        child: GetMaterialApp(
          title: 'unknown',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
          ],
          locale: const Locale('zh', 'CN'),
          // localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          //   //print("change language");
          //   return locale;
          // },
          getPages: AppPages.pages(),
          initialRoute: AppRoutes.INITIAL,
          theme:
              ThemeData(primaryColor: const Color.fromARGB(255, 250, 199, 59)),
          themeMode: ThemeMode.system,
          builder: EasyLoading.init(),
        ));
  }
}
