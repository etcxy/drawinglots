import 'package:drawinglots/components/randomtext/random_text_logic.dart';
import 'package:get/get.dart';

import 'draw_logic.dart';

class DrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Random_textLogic());
    Get.lazyPut(() => DrawLogic());
  }
}
