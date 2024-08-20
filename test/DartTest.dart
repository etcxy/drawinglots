import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drawinglots/model/user_struct.dart';
import 'package:drawinglots/model/user_struct2.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

void main2() {
  print("Hello World");

  File file = File(r'D:\abc.txt');

  String content = file.readAsStringSync();
  print('文件内容：');
  print(content);

  print("=========");

  var bytes = File(r"D:\aa.xlsx").readAsBytesSync();
}

void main1() {
  var file = r"D:\s1.xlsx";
  var bytes = File(file).readAsBytesSync();
  var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

  for (var table in decoder.tables.keys) {
    if (decoder.tables[table]!.maxRows < 1) {
      continue;
    }

    print(table);

    for (var row in decoder.tables[table]!.rows) {
      // print('${row.first}');
      print('${row[0]}');
      print('${row[1]}');
    }
  }
}

void main32() {
  Map<String, List<String>> map = {
    "hello": ["world", "world2"]
  };
  GetStorage.init();

  var box = GetStorage();
  box.write("key", jsonEncode(map));

  var str = box.read("key");
  Map<String, List<String>> emptyMap = {};

  Map<String, dynamic>.from(jsonDecode(str)).forEach((key, value) {
    emptyMap[key] = List<String>.from(value);
  });

  print(emptyMap);
}

//随机生成一堆学生对象
List<UserStruct> generateRandomStudents(int count) {
  List<UserStruct> list = [];

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

  for (int i = 0; i < count; i++) {
    list.add(UserStruct(groupList[r.nextInt(groupList.length)], '${count + i}',
        nameList[r.nextInt(nameList.length)]));
  }

  return list;
}

void maidfn() {
  var list = generateRandomStudents(2);
  GetStorage.init();

  var box = GetStorage();
  box.write("key", jsonEncode(list));

  var str = box.read("key");
  List<dynamic> emptyList = List<dynamic>.from(jsonDecode(str));
  var list2 =
      emptyList.map((userJson) => UserStruct.fromJson(userJson)).toList();
  print(list2);
}

void main() {
  // Set<String> set = {'1','33'};
  // Set<String> set2 = {'3','2'};
  //
  // print(set.intersection(set2).length);
  //
  // RxSet<String> names = RxSet<String>();
  // names.clear();
  // var set3 = names.toSet();
  //
  // print(set3);

  // List<UserStruct2> list = [];
  // Set<String> tags = {};
  //
  // list.add(UserStruct2('1', 'tom', ['1', '2', '3'].toSet()));
  // list.add(UserStruct2('2', 'tomas', ['4', '2', '3'].toSet()));
  // list.add(UserStruct2('3', 'tomasLee', ['51', '16', '3'].toSet()));
  //
  // list.map((e) => e.userTags).forEach((e) => tags.addAll(e));
  // print('$tags');

  Set<String> set1 = {'1','2','3','4'};
  Set<String> set2 = {'1','6'};

  print(set2.difference(set1));

}

void main3() {
//   DateTime now = DateTime.now();
//
// // 提取年、月、日
//   int year = now.year;
//   int month = now.month;
//   int day = now.day;
//
//   String current = '$year-$month-$day';
//
//   if(current=='2024-7-11'){
//     print('ok');
//   }

  // int min = 1;
  // int max = 10;
  // List<int> weights = [5, 5, 0, 1, 0, 0, 0, 0, 0, 0]; // 权重列表
  //
  // int randomNumber = getWeightedRandomNumber(min, max, weights);
  // print('生成的随机数: $randomNumber');

  Map<String, bool> map = {"hello": true, "world": false};
}

int getWeightedRandomNumber(int min, int max, List<int> weights) {
  Random random = Random();
  int totalWeight = weights.fold(0, (sum, weight) => sum + weight);
  int randomIndex = random.nextInt(totalWeight);
  for (int i = 0; i < max - min + 1; i++) {
    if (randomIndex < weights[i]) {
      return i + min;
    }
    randomIndex -= weights[i];
  }
  return min; // 如果没有找到随机数，默认返回最小值
}
