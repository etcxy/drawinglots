import 'dart:io';
import 'dart:math';

import 'package:drawinglots/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:toastification/toastification.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  Map<String, List<String>> iStuAllMap = {
    'aa': ['11', '22', '33'],
    'bb': ['44', '55', '66']
  };
  Random r = new Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StudentCollection _readStuColl = context.read<StudentCollection>();
    logger.d(iStuAllMap);
    // iStuAllMap.addAll(_readStuColl.stuAll);
    // logger.d(iStuAllMap);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 57,
      width: double.infinity,
      child: Column(children: [
        ElevatedButton(
            onPressed: () {
              importFileList(context, _readStuColl).then((isComplete) => {
                    if (isComplete)
                      {
                        setState(() {
                          iStuAllMap.clear();
                          _readStuColl.stuAll.forEach((key, value) async {
                            iStuAllMap[key] = value;
                          });
                        })
                      }
                  });
            },
            child: const Text('Import')),
        ElevatedButton(
            onPressed: () {
              setState(() {
                iStuAllMap.remove('aa');
              });
            },
            child: Text('clear')),
        Flexible(
            child: ScrollableListTabScroller(
          itemCount: iStuAllMap.length,
          earlyChangePositionOffset: 30,
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                        // title: Text('${value.split('&')[1]} (${value.split('&')[0]})'),
                        title: Text('$value'),
                      ),
                    ),
                  )
                  .values
            ],
          ),
          tabChanged: (int x) {},
        ))
      ]),
    );
  }

  // Widget build(BuildContext context) {
  //   StudentCollection _readStuColl = context.read<StudentCollection>();
  //   logger.d(iStuAllMap);
  //   // iStuAllMap.addAll(_readStuColl.stuAll);
  //   // logger.d(iStuAllMap);
  //
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height - 57,
  //     width: double.infinity,
  //     child: Center(
  //         child: Scaffold(
  //       body: ScrollableListTabScroller(
  //         itemCount: iStuAllMap.length,
  //         earlyChangePositionOffset: 30,
  //         tabBuilder: (BuildContext context, int index, bool active) => Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Text(
  //             iStuAllMap.keys.elementAt(index),
  //             style: !active
  //                 ? null
  //                 : const TextStyle(
  //                     fontWeight: FontWeight.bold, color: Colors.green),
  //           ),
  //         ),
  //         itemBuilder: (BuildContext context, int index) => Column(
  //           children: [
  //             Text(
  //               iStuAllMap.keys.elementAt(index),
  //               style:
  //                   const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //             ),
  //             ...iStuAllMap.values
  //                 .elementAt(index)
  //                 .asMap()
  //                 .map(
  //                   (index, value) => MapEntry(
  //                     index,
  //                     ListTile(
  //                       leading: Container(
  //                         height: 40,
  //                         width: 40,
  //                         decoration: const BoxDecoration(
  //                             shape: BoxShape.circle, color: Colors.grey),
  //                         alignment: Alignment.center,
  //                         child: Text(index.toString()),
  //                       ),
  //                       title: Text(
  //                           '${value.split('&')[1]} (${value.split('&')[0]})'),
  //                     ),
  //                   ),
  //                 )
  //                 .values
  //           ],
  //         ),
  //       ),
  //       floatingActionButton: FloatingActionButton.extended(
  //         onPressed: () {
  //           importFileList(context, _readStuColl).then((isComplete) => {
  //                 if (isComplete)
  //                   {
  //                     setState(() {
  //                       iStuAllMap.clear();
  //                       _readStuColl.stuAll.forEach((key, value) {
  //                         iStuAllMap[key] = value;
  //                       });
  //                     })
  //                   }
  //               });
  //         },
  //         shape: const StadiumBorder(),
  //         icon: const Icon(
  //           Icons.import_export,
  //           color: Colors.blue,
  //           shadows: [],
  //           size: 30,
  //         ),
  //         label: const Text("导入"),
  //       ),
  //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  //     )),
  //   );
  // }

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
        toastification.show(
          context: context,
          // optional if you use ToastificationWrapper
          title: const Text('表格为空，导入失败'),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.minimal,
        );
        return false;
      }

      Map<String, List<String>> readListFromFile = {};
      //嵌套循环读取
      for (var sheet in decoder.tables.keys) {
        if (decoder.tables[sheet]!.maxRows < 1) {
          continue;
        }
        List<String> pageList = [];
        for (var row in decoder.tables[sheet]!.rows) {
          if (row[0] == "姓名" || row[0] == "学号") {
            continue;
          }
          pageList.add('${row[0]}&${row[1]}');
        }
        readListFromFile[sheet] = pageList;
      }

      //全局导入
      _readStuColl.importMap(readListFromFile);
      return true;
    } else {
      toastification.show(
        context: context,
        // optional if you use ToastificationWrapper
        title: const Text('取消导入'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.info,
        style: ToastificationStyle.minimal,
      );
      return false;
    }
  }
}
