import 'dart:math';

import 'package:drawinglots/model/user_struct2.dart';
import 'package:drawinglots/state/global_st_logic.dart';
import 'package:get/get.dart';

import 'draw_state.dart';

class DrawLogic extends GetxController {
  final DrawState state = DrawState();

  final glb_stLogic = Get.find<Global_stLogic>();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  UserStruct2? getRandomUser() {
    if (glb_stLogic.state.leftUserList.isEmpty) {
      throw Exception('列表为空');
    }

    var randomUser2 = randomUser();
    glb_stLogic.state.selectedUserList.add(randomUser2);

    glb_stLogic.flushAllCollections();
    glb_stLogic.flushAllTags();
    glb_stLogic.debugPrintAll();
    return randomUser2;
  }

  // 随机获取一个用户
  UserStruct2 randomUser() {
    return glb_stLogic.state
        .leftUserList[Random().nextInt(glb_stLogic.state.leftUserList.length)];
  }
}
