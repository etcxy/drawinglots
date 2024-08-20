import 'package:get/get.dart';

import 'import_file_logic.dart';

class Import_fileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Import_fileLogic());
  }
}
