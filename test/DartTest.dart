import 'dart:io';

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

void main() {

  Map<String,dynamic> map2 = {};
  map2 = {"hello": ["1","2","3","4"]};

  map2["world"]=[];

  map2['hello']?.add("5");

  GetStorage.init();

  var box = GetStorage();
  box.write("key", {"hello": ["world","world2"]});

  Map<String,List<String>> mx = box.read("key");

  mx.forEach((key, value) {
    print("key:$key");
    value.forEach((element) {
      print("element:$element");
    });
  });


  print(mx);


}