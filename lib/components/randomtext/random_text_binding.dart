import 'package:drawinglots/components/randomtext/random_text_logic.dart';
import 'package:get/get.dart';

class Random_textBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Random_textLogic());
  }
}
