import 'dart:convert';

import 'package:drawinglots/model/user_entity.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'global_st_state.dart';

class Global_stLogic extends GetxController {
  final Global_stState state = Global_stState();

  //-----------------------逻辑层方法区-----------------------------------
  @override
  void onReady() {
    recoverFromLocalStorage();
    super.onReady();
  }

  @override
  void onClose() {
    saveToLocalStorage();
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
    // print("selectedTagSet: ${state.selectedTagSet}");
    print("leftTagSet: ${state.leftTagSet}");
  }

  //保存所有集合数据
  void saveToLocalStorage() {
    final box = GetStorage();

    box.write('userList', jsonEncode(state.userList));
    box.write('selectedUserList', jsonEncode(state.selectedUserList));
    box.write('leftUserList', jsonEncode(state.leftUserList));
    box.write('last_time', DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  //从本地恢复所有集合数据
  void recoverFromLocalStorage() {
    final box = GetStorage();

    state.userList = (jsonDecode(box.read('userList')) as List)
        .map((e) => UserEntity.fromJson(e))
        .toList();

    if (box.read('last_time') ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      state.selectedUserList =
          (jsonDecode(box.read('selectedUserList')) as List)
              .map((e) => UserEntity.fromJson(e))
              .toList();
      state.leftUserList = (jsonDecode(box.read('leftUserList')) as List)
          .map((e) => UserEntity.fromJson(e))
          .toList();
      flushAllTags();
    }
  }
}
