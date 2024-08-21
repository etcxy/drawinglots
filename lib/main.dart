import 'package:drawinglots/pages/dlhome/dlhome_binding.dart';
import 'package:drawinglots/pages/dlhome/dlhome_view.dart';
import 'package:drawinglots/pages/draw/draw_binding.dart';
import 'package:drawinglots/pages/draw/draw_view.dart';
import 'package:drawinglots/state/global_st_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import 'components/randomtext/random_text_logic.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

Future<void> main() async {
  await GetStorage.init();

  // Random_textLogic appController = await Get.putAsync<Random_textLogic>(
  //     () async => Random_textLogic(),
  //     permanent: true);

  runApp(GetMaterialApp(
    //绑定一个全局的GetxController
    initialBinding: Global_stBinding(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    themeMode: ThemeMode.light,
    theme: ThemeData.light(),
    defaultTransition: Transition.fade,
    getPages: [
      GetPage(
          name: '/',
          page: () => DlhomePage(),
          transition: Transition.rightToLeft,
          binding: DlhomeBinding()),
      GetPage(
          name: '/draw',
          page: () => DrawPage(),
          transition: Transition.rightToLeft,
          binding: DrawBinding()),
    ],
    // home: DlhomePage(),
  ));
}
