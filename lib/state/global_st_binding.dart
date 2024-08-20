import 'package:get/get.dart';

import 'global_st_logic.dart';

class Global_stBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Global_stLogic());
  }
}
