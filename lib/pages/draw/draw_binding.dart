import 'package:get/get.dart';

import 'draw_logic.dart';

class DrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DrawLogic());
  }
}
