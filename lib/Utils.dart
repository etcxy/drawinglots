import 'dart:convert';
import 'dart:math';

import 'package:get_storage/get_storage.dart';

import 'model/user_struct.dart';

class Utils {
  static List<UserStruct> generateRandomStudents(
      GetStorage box, int generateCount, int selectedCount) {
    //初始化数据
    box.erase();

    List<UserStruct> generateList = [];
    Set<UserStruct> selectedList = {};

    List<String> groupList = [
      '计算机一班',
      '计算机二班',
      '计算机三班',
      '计算机四班',
      '计算机五班',
      '计算机六班',
      '计算机七班',
      '计算机八班',
      '计算机九班',
      '计算机十班',
      '计算机十一班',
      '计算机十二班',
      '计算机十三班',
      '计算机十四班',
      '计算机十五班',
      '计算机十六班',
      '计算机十七班',
      '计算机十八班'
    ];

    var nameList = [
      '张三',
      '李四',
      '王五',
      '赵六',
      '田七',
      '周八',
      '吴九',
      '郑十',
      '冯十一',
      '陈十二',
      '褚十三',
      '卫十四',
      '蒋十五',
      '沈十六',
    ];

    Random r = Random();

    for (int i = 0; i < generateCount; i++) {
      generateList.add(UserStruct(groupList[r.nextInt(groupList.length)],
          '${generateCount + i}', nameList[r.nextInt(nameList.length)]));
    }
    box.write('allMap', jsonEncode(generateList));

    for (int i = 0; selectedList.length < selectedCount; i++) {
      selectedList.add(generateList[r.nextInt(generateList.length)]);
    }

    box.write('todayChosenMap', jsonEncode(selectedList.toList()));

    return generateList;
  }

  @deprecated
  static bool generateRandomStudentsAndSave2Box(GetStorage _box, int count) {
    List<UserStruct> list = generateRandomStudents(_box, count, 1);
    //list to Map<String, List<UserStruct>> 其中key为group，value为UserStruct类
    Map<String, List<UserStruct>> resultMap = {};
    list.forEach((element) {
      if (!resultMap.containsKey(element.userGroup)) {
        resultMap[element.userGroup] = [];
        resultMap[element.userGroup]!.add(
            UserStruct(element.userGroup, element.userID, element.userName));
      } else {
        resultMap[element.userGroup]!.add(
            UserStruct(element.userGroup, element.userID, element.userName));
      }
    });

    _box.write('allMap', jsonEncode(resultMap));

    return true;
  }

  static void debugGenerateMap(GetStorage _box) {
    _box.erase();
    //初始化数据
    if (!_box.hasData('allMap')) {
      var tmpData = {
        "计算机一班": ["202101&张三", "202102&李四", "202103&王五", "202104&赵六"],
        "计算机二班": ["202111&张1", "202112&李2", "202113&王3", "202114&赵4"],
      };
      _box.write('allMap', jsonEncode(tmpData));
    }

    if (!_box.hasData('todayChosenMap')) {
      var tmpData = {
        "计算机一班": ["202104&赵六"],
      };

      _box.write('todayChosenMap', jsonEncode(tmpData));
    }
  }
}
