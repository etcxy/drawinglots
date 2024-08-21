import 'dart:io';
import 'dart:math';

import 'package:drawinglots/model/user_entity.dart';
import 'package:drawinglots/model/user_struct2.dart';
import 'package:drawinglots/pages/import_file/import_file_view.dart';
import 'package:drawinglots/state/global_st_logic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'import_file_state.dart';

class Import_fileLogic extends GetxController {
  final Import_fileState state = Import_fileState();
  late Global_stLogic global_stLogic;

  @override
  void onReady() {
    global_stLogic = Get.find<Global_stLogic>();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void gen() {
    state.cardStyleData = generateItems(5);
  }

  ///导入文件，并同步全局AllMap集合对象中
  Future<bool> importFile(BuildContext context) async {
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
        TDToast.showFail("导入文件有误", context: context);
      }
      //判断excel为空，则退出后续逻辑
      Map<String, List<UserStruct2>> readListFromFile = {};
      //嵌套循环读取
      for (var sheet in decoder.tables.keys) {
        if (decoder.tables[sheet]!.maxRows < 1) {
          continue;
        }
        List<UserEntity> pageList = [];
        for (var row in decoder.tables[sheet]!.rows) {
          //TODO  excel数据开关
          if (row[0] == "姓名" || row[0] == "学号") {
            continue;
          }

          Set<String> tagsSet = {};
          tagsSet.add(sheet.trim());
          for (int i = 2; i < row.length; i++) {
            row[i].split(',').forEach((element) {
              tagsSet.add(element.trim());
            });
          }
          ;
          pageList.add(UserEntity('${row[0]}', '${row[1]}', tagsSet));
        }
        //全局导入
        global_stLogic.state.userList = pageList;

        global_stLogic.flushAllCollections();
        global_stLogic.flushAllTags();
      }
      return true;
    } else {
      TDToast.showFail("导入文件路径有误!", context: context);
      return false;
    }
  }

  List<CollapseDataItem> generateItems(int numOfItems) {
    return List.generate(numOfItems, (index) {
      Random random = Random();
      return CollapseDataItem(
        headerValue: '标题 $index ${random.nextInt(1000)}',
        expandedValue: '$index',
      );
    });
  }
}
