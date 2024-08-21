import 'package:drawinglots/components/random_text_reveal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'random_text_state.dart';

class Random_textLogic extends GetxController {
  final Random_textState state = Random_textState();
  final GlobalKey<RandomTextRevealState> globalKey = GlobalKey();
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

  void doActionText(){
    state.isShow.value = false;
    globalKey.currentState?.play();
    // 设置一个定时器，10秒后调用doActionText()方法
    Future.delayed(const Duration(seconds: 2), () {
      state.isShow.value = true;
    });
  }

}
