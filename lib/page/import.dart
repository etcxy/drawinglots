import 'dart:io';

import 'package:drawinglots/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  var data = {
    "计算机一班": [
      "202101 (张三)",
      "202102 (李四)",
      "202103 (王五)",
      "202104 (赵六)",
    ],
    "计算机二班": [
      "Item 1 (B)",
      "Item 2 (B)",
    ],
    "数学一班": [
      "Item 1 (C)",
      "Item 2 (C)",
      "Item 3 (C)",
      "Item 4 (C)",
      "Item 5 (C)",
    ],
    "数学二班": [
      "Item 1 (D)",
      "Item 2 (D)",
      "Item 3 (D)",
      "Item 4 (D)",
      "Item 5 (D)",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: MediaQuery.of(context).size.height-57,
        width: double.infinity,
        child: Center(
          child:Scaffold(
            // backgroundColor: Colors.blue,
            // appBar: AppBar(title: Text('点了么'),),

            body: ScrollableListTabScroller(
              itemCount: data.length,
              earlyChangePositionOffset: 30,
              tabBuilder: (BuildContext context, int index, bool active) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data.keys.elementAt(index),
                  style: !active
                      ? null
                      : TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
              itemBuilder: (BuildContext context, int index) => Column(
                children: [
                  Text(
                    data.keys.elementAt(index),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ...data.values
                      .elementAt(index)
                      .asMap()
                      .map(
                        (index, value) => MapEntry(
                      index,
                      ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text(value),
                      ),
                    ),
                  )
                      .values
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                // 打开文件选择器
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv', 'xlsx'],
                );

                if (result != null) {
                  File file = File(result.files.single.path!);

                  // var file = r"D:\s1.xlsx";
                  var bytes = file.readAsBytesSync();
                  var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

                  if (decoder.tables.keys.isEmpty) {
                    //判断excel为空，则退出后续逻辑
                    return;
                  }
                  data.clear();

                  Map<String, List<String>> map;

                  for (var table in decoder.tables.keys) {
                    if (decoder.tables[table]!.maxRows < 1) {
                      continue;
                    }

                    List<String> tmpList = [];

                    for (var row in decoder.tables[table]!.rows) {
                      // print('${row.first}');
                      if(row[0]=="姓名" || row[0]=="学号"){
                        continue;
                      }
                      tmpList.add('${row[0]} ${row[1]}');
                    }


                    setState(() {
                      data[table] = tmpList;
                    });

                    // context.read<StudentCollection>().update(data);
                  }
                } else {
                  // User canceled the picker
                  //TODO:提示-取消导入
                }
              },
              shape: StadiumBorder(),
              icon: Icon(
                Icons.import_export,
                color: Colors.blue,
                shadows: [],
                size: 30,
              ),
              label: Text("导入"),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          )
        ),
      );
      ;
  }
}
