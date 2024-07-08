import 'dart:math';

import 'package:drawinglots/components/combination_widget.dart';
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
  bool _isFirst = false; // 是否是第一次进入

  @override
  void initState() {
    //TODO 调查清楚为什么这里会多次被调用，按理说init方法只会被调用一次
    // logger.d('执行initstate');
    // _isFirst = false;
    super.initState();

    _stuColl = context.read<StudentCollection>();

    // 初始化easylist
    resetEasyList();
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

    // logger.d(_easyList);
    // logger.d(_stuColl.stuAll);
    // logger.d(_stuColl.todayChosenMap);

    if (_isFirst) {
      Future.delayed(
          Duration(seconds: 1),
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
      _isFirst = false;
    }

    return SizedBox(
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
                              context.read<StuReady>().rollDuration * 1000 +
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
    );
  }
}
