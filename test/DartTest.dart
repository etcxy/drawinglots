import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drawinglots/model/user_struct.dart';
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

void main() {
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
