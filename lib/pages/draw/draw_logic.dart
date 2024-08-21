import 'dart:math';

import 'package:drawinglots/components/randomtext/random_text_logic.dart';
import 'package:drawinglots/model/user_entity.dart';
import 'package:drawinglots/state/global_st_logic.dart';
import 'package:get/get.dart';

import 'draw_state.dart';

class DrawLogic extends GetxController {
  final DrawState state = DrawState();

  final glb_stLogic = Get.find<Global_stLogic>();
  var randomComponentLogic = Get.find<Random_textLogic>();

  @override
  void onReady() {
    glb_stLogic.recoverFromLocalStorage();
    glb_stLogic.debugPrintAll();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  UserEntity getRandomUser() {
    if (glb_stLogic.state.leftUserList.isEmpty) {
      throw Exception('列表为空');
    }

    var user = randomUser();
    glb_stLogic.state.selectedUserList.add(user);

    glb_stLogic.flushAllCollections();
    glb_stLogic.flushAllTags();
    glb_stLogic.debugPrintAll();

    randomComponentLogic.state.userEntity.value = user;
    randomComponentLogic.doActionText();

    return user;
  }

  // 随机获取一个用户
  UserEntity randomUser() {
    return glb_stLogic.state
        .leftUserList[Random().nextInt(glb_stLogic.state.leftUserList.length)];
  }
}
