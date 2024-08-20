import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'import_file_logic.dart';

class Import_filePage extends StatelessWidget {
  const Import_filePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<Import_fileLogic>();
    final state = Get.find<Import_fileLogic>().state;

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Center(
          child: TDButton(
        text: '导入excel',
        icon: TDIcons.chart_bar,
        size: TDButtonSize.large,
        type: TDButtonType.fill,
        shape: TDButtonShape.rectangle,
        theme: TDButtonTheme.primary,
        onTap: () {
          logic.importFile(context);
        },
      )),
    );
  }
}
