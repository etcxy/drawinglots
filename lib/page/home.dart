import 'dart:math';

import 'package:drawinglots/components/combination_widget.dart';
import 'package:drawinglots/constants.dart';
import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/user_struct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserStruct _thisStu = UserStruct("group", "id", 'name');

  final Random _random = Random();

  final List<UserStruct> _easyList = [];
  late StudentCollection _stuColl;

  List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    _stuColl = context.read<StudentCollection>();
  }

  /// 随机名单
  void randomStu() {
    int r = _random.nextInt(_easyList.length);
    _thisStu = _easyList[r];

    _stuColl.add2TodayChosenMap(_thisStu);
    _easyList.remove(_thisStu);

    setState(() {});
  }

  /// 重置easylist列表
  void resetEasyList() {
    _easyList.clear();
    Map<String, List<UserStruct>> allMap = _stuColl.stuAll;
    Map<String, List<UserStruct>> todayChosenMap = _stuColl.todayChosenMap;

    allMap.forEach((key, value) {
      for (var element in value) {
        _easyList.add(element);
      }
    });

    todayChosenMap.forEach((key, value) {
      for (var element in value) {
        _easyList.remove(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //每次进入页面，都重新初始化easylist列表
    resetEasyList();

    if (GlobalVariable.NEED_TIMPS) {
      Future.delayed(
          const Duration(seconds: 1),
          () => {
                toastification.show(
                  context: context,
                  // optional if you use ToastificationWrapper
                  title: const Text('长按按钮，可重置被选中的名单'),
                  autoCloseDuration: const Duration(seconds: 3),
                  type: ToastificationType.info,
                  style: ToastificationStyle.flat,
                )
              });
      GlobalVariable.NEED_TIMPS = false;
    }

    var groupList = _stuColl.selected.keys.toList();
    _selected = List.from(_stuColl.selected.values);

    logger.d(groupList);
    logger.d(_stuColl.selected);


    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.bottomCenter, //指定未定位或部分定位widget的对齐方式
        children: <Widget>[
          const Text(
            'designer by 1000000000',
            // style: TextStyle(fontFamily: 'MiSans'),
          ),
          Positioned(
            right: 8.0,
            bottom: 12,
            child: ToggleButtons(
              selectedColor: Colors.black,
              fillColor: Colors.blue,
              renderBorder: true,
              borderRadius: BorderRadius.circular(25),
              hoverColor: Colors.blueGrey,
              isSelected: _selected,
              onPressed: (index) {
                setState(() {
                  _selected[index] = !_selected[index];
                  _stuColl.selected[groupList[index]] = _selected[index];
                });
              },
              children: _getChildList(groupList),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CombinationWidget(
                    model: _thisStu,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: const Divider(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_easyList.isEmpty) {
                          toastification.show(
                            context: context,
                            title: const Text(
                              '全部都抽过一遍啦',
                              style: TextStyle(fontFamily: 'HanSansCN'),
                            ),
                            autoCloseDuration: const Duration(seconds: 3),
                            type: ToastificationType.success,
                            style: ToastificationStyle.minimal,
                          );
                          return;
                        }
                        // setTask(100);
                        randomStu();
                        context.read<StuReady>().inVisible();
                        globalKey.currentState?.play();

                        Future.delayed(
                            Duration(
                                milliseconds:
                                    context.read<StuReady>().rollDuration *
                                            1000 +
                                        20),
                            () => {
                                  setState(() {
                                    context.read<StuReady>().visible();
                                  }),
                                });
                      },
                      onLongPress: () {
                        toastification.show(
                          context: context,
                          // optional if you use ToastificationWrapper
                          title: const Text('被选中的名单已重置'),
                          autoCloseDuration: const Duration(seconds: 3),
                          type: ToastificationType.success,
                          style: ToastificationStyle.flat,
                        );
                        _stuColl.resetTodayChosenMap();
                        resetEasyList();
                      },
                      child: const Text('Go!')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getChildList(List<String> groupName) {
    List<Widget> list = [];
    for (var element in groupName) {
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: Text(element)));
    }
    return list;
  }
}
