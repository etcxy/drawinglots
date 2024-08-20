import 'package:get/get.dart';

import 'dlhome_logic.dart';

class DlhomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DlhomeLogic());
  }
}
