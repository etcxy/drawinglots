import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'import_file_logic.dart';

class Import_filePage extends StatelessWidget {
  Import_filePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<Import_fileLogic>();
    final state = Get.find<Import_fileLogic>().state;

    if (state.cardStyleData.isEmpty) {
      logic.gen();
    }

    return Container(
      height: 100,
      color: Color.fromARGB(30, 30, 30, 30),
      width: double.infinity,
      child:
          // SizedBox(m)
          Wrap(
        //     child: TDButton(
        //   text: '导入excel',
        //   icon: TDIcons.chart_bar,
        //   size: TDButtonSize.large,
        //   type: TDButtonType.fill,
        //   shape: TDButtonShape.rectangle,
        //   theme: TDButtonTheme.primary,
        //   onTap: () {
        //     logic.importFile(context);
        //   },
        // )
        children: [
          SizedBox(
            height: 30,
            width: double.infinity,
          ),
          GetBuilder<Import_fileLogic>(
            init: Import_fileLogic(),
            builder: (context) {
              return TDCollapse(
                style: TDCollapseStyle.card,
                expansionCallback: (int index, bool isExpanded) {
                  // setState(() {
                  // _cardStyleData[index].isExpanded = !isExpanded;
                  // });
                  print('isExpanded:$isExpanded');

                  print('${state.cardStyleData[index].isExpanded}');
                  state.cardStyleData[index].isExpanded = !isExpanded;
                  print('${state.cardStyleData[index].isExpanded}');

                  logic.update();
                },
                children: state.cardStyleData.map((CollapseDataItem item) {
                  return TDCollapsePanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Text(item.headerValue);
                    },
                    isExpanded: item.isExpanded,
                    body: const Text("asdfasdfadf"),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CollapseDataItem {
  CollapseDataItem(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
}
