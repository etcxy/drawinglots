import 'package:drawinglots/model/user_struct2.dart';
import 'package:get/get.dart';

import 'global_st_state.dart';

class Global_stLogic extends GetxController {
  final Global_stState state = Global_stState();

  //-----------------------逻辑层方法区-----------------------------------
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //刷新所有list集合
  void flushAllCollections() {
    // 所有用户列表
    state.userList;
    // 已中签用户列表
    state.selectedUserList;
    // 剩余用户列表
    state.leftUserList = state.userList
        .where((element) => !state.selectedUserList.contains(element))
        .toList();
    // 可用用户列表
    state.couldChosenList.clear();
    state.leftUserList.forEach((leftUser) {
      leftUser.userTags.forEach((leftUserTag) {
        if (!state.cancelTagSet.contains(leftUserTag)) {
          if (!state.couldChosenList.contains(leftUser)) {
            state.couldChosenList.add(leftUser);
          }
        }
      });
    });
  }

  // 刷新所有标签
  void flushAllTags() {
    //1. 刷新<全体用户标签>
    state.tagSet.clear();
    state.userList
        .map((e) => e.userTags)
        .forEach((e) => state.tagSet.addAll(e));
    //2. 刷新<已中用户标签>
    // state.selectedUserList
    //     .map((e) => e.userTags)
    //     .forEach((e) => state.selectedTagSet.addAll(e));
    //3. <取消标签用户>
    state.cancelTagSet;
    //4. <剩余用户标签>
    state.leftTagSet.clear();
    state.leftUserList
        .map((e) => e.userTags)
        .forEach((e) => state.leftTagSet.addAll(e));
    //5. <可用用户标签>
    state.couldChosenTagSet.clear();
    state.leftUserList
        .map((e) => e.userTags)
        .forEach((e) => state.couldChosenTagSet.addAll(e));
  }

  // 打印所有变量
  void debugPrintAll() {
    print("userList: ${state.userList}");
    print("selectUserList: ${state.selectedUserList}");
    print("leftUserList: ${state.leftUserList}");

    print("tagSet: ${state.tagSet}");
    print("cancelTagSet: ${state.cancelTagSet}");
    print("selectedTagSet: ${state.selectedTagSet}");
    print("leftTagSet: ${state.leftTagSet}");
  }
}
