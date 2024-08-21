import 'package:drawinglots/model/user_entity.dart';
import 'package:get/get.dart';

class Random_textState {

  Rx<UserEntity> userEntity = UserEntity('ID', "用户名", {'用户标签'}).obs;

  var isShow = false.obs;

  Random_textState() {
    ///Initialize variables
  }
}
