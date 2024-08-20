import 'package:drawinglots/model/user_struct2.dart';
import 'package:get/get.dart';

class Global_stState {
  /**
   * 所有用户列表 = 已中签用户列表 + 剩余用户列表
   * 剩余用户列表 = 可选用户列表 + 取消标签用户标签
   */
  // 加载的所有用户列表
  List<UserStruct2> _userList = [];

  // 已中签用户列表
  List<UserStruct2> _selectedUserList = [];

  // 剩余用户信息列表 = 加载的所有用户列表 - 已中签用户列表
  List<UserStruct2> _leftUserList = [];

  // 可选用户列表 = 剩余用户信息列表 - 取消标签用户标签
  List<UserStruct2> _couldChosenList = [];

  // 所有用户Tag标签
  // Set<String> _tagSet = {};
  RxSet<String> _tagSet = RxSet<String>();

  //已中用户标签
  RxSet<String> _selectedTagSet = RxSet<String>();

  // 剩余用户Tag标签集合
  // Set<String> _leftTagSet = {};
  RxSet<String> _leftTagSet = RxSet<String>();

  // 取消选择的标签
  RxSet<String> _cancelTagSet = RxSet<String>();

  //可用用户标签
  RxSet<String> _couldChosenTagSet = RxSet<String>();

  Global_stState() {
    ///Initialize variables
  }

  // ---------------------get&set--------------------------

  List<UserStruct2> get userList => _userList;

  set userList(List<UserStruct2> value) {
    _userList = value;
  }

  Set<String> get tagSet => _tagSet;

  set tagSet(Set<String> value) {
    _tagSet.value = value;
  }

  List<UserStruct2> get leftUserList => _leftUserList;

  set leftUserList(List<UserStruct2> value) {
    _leftUserList = value;
  }

  Set<String> get leftTagSet => _leftTagSet;

  set leftTagSet(Set<String> value) {
    _leftTagSet.value = value;
  }

  List<UserStruct2> get selectedUserList => _selectedUserList;

  set selectedUserList(List<UserStruct2> value) {
    _selectedUserList = value;
  }



  Set<String> get cancelTagSet => _cancelTagSet;

  set cancelTagSet(Set<String> value) {
    _cancelTagSet.value = value;
  }

  RxSet<String> get selectedTagSet => _selectedTagSet;

  set selectedTagSet(RxSet<String> value) {
    _selectedTagSet = value;
  }

  RxSet<String> get couldChosenTagSet => _couldChosenTagSet;

  set couldChosenTagSet(RxSet<String> value) {
    _couldChosenTagSet = value;
  }

  List<UserStruct2> get couldChosenList => _couldChosenList;

  set couldChosenList(List<UserStruct2> value) {
    _couldChosenList = value;
  }
}
