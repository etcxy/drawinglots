import 'dart:io';
import 'dart:math';

import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/user_struct.dart';
import 'package:drawinglots/oldmain/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
// import 'package:toastification/toastification.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  Map<String, List<UserStruct>> iStuAllMap = {};

  Widget build(BuildContext context) {
    StudentCollection _readStuColl = context.read<StudentCollection>();
    iStuAllMap = _readStuColl.stuAll;

    return Scaffold(
      key: UniqueKey(),
      body: ScrollableListTabScroller(
        earlyChangePositionOffset: 30,
        itemCount: iStuAllMap.length,
        tabBuilder: (BuildContext context, int index, bool active) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            iStuAllMap.keys.elementAt(index),
            style: !active
                ? null
                : const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            Text(
              iStuAllMap.keys.elementAt(index),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ...iStuAllMap.values
                .elementAt(index)
                .asMap()
                .map(
                  (index, value) => MapEntry(
                    index,
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        alignment: Alignment.center,
                        child: Text(index.toString()),
                      ),
                      title: Text(
                        '${value.userName}(${value.userGroup})',
                      ),
                    ),
                  ),
                )
                .values
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await importFileList(context, _readStuColl);
          iStuAllMap = {};
          _readStuColl.stuAll.forEach((key, value) {
            iStuAllMap[key] = value;
          });
          setState(() {});
        },
        shape: const StadiumBorder(),
        icon: const Icon(
          Icons.import_export,
          color: Colors.blue,
          shadows: [],
          size: 30,
        ),
        label: const Text("导入"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  ///导入文件，并同步全局AllMap集合对象中
  Future<bool> importFileList(
      BuildContext context, StudentCollection _readStuColl) async {
    // 打开文件选择器
    FilePickerResult? listFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );

    if (listFile != null) {
      File file = File(listFile.files.single.path!);

      var bytes = file.readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

      if (decoder.tables.keys.isEmpty) {
        //判断excel为空，则退出后续逻辑
        // toastification.show(
        //   context: context,
        //   // optional if you use ToastificationWrapper
        //   title: const Text('表格为空，导入失败'),
        //   autoCloseDuration: const Duration(seconds: 3),
        //   type: ToastificationType.error,
        //   style: ToastificationStyle.minimal,
        // );
        return false;
      }

      Map<String, List<UserStruct>> readListFromFile = {};
      //嵌套循环读取
      for (var sheet in decoder.tables.keys) {
        if (decoder.tables[sheet]!.maxRows < 1) {
          continue;
        }
        List<UserStruct> pageList = [];
        for (var row in decoder.tables[sheet]!.rows) {
          if (row[0] == "姓名" || row[0] == "学号") {
            continue;
          }
          pageList.add(UserStruct(sheet, '${row[0]}', '${row[1]}'));
        }
        readListFromFile[sheet] = pageList;
      }

      //全局导入
      _readStuColl.importMap(readListFromFile);
      return true;
    } else {
      // toastification.show(
      //   context: context,
      //   // optional if you use ToastificationWrapper
      //   title: const Text('取消导入'),
      //   autoCloseDuration: const Duration(seconds: 3),
      //   type: ToastificationType.info,
      //   style: ToastificationStyle.minimal,
      // );
      return false;
    }
  }
}
