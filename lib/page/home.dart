import 'dart:math';

import 'package:drawinglots/components/combination_widget.dart';
import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/stu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? luckyStuInfo;
  StuModel _thisStu = StuModel(stuGroup: "group", stuID: "id", stuName: 'name');

  final Random _random = Random();

  final List<String> _easyList = [];
  late StudentCollection _stuColl;
  bool _isFirst = false; // 是否是第一次进入

  @override
  void initState() {
    //TODO 调查清楚为什么这里会多次被调用，按理说init方法只会被调用一次
    // logger.d('执行initstate');
    // _isFirst = false;
    super.initState();
    luckyStuInfo = "lucky";
    loggerNoStack.i('Info message home');

    _stuColl = context.read<StudentCollection>();

    // 初始化easylist
    resetEasyList();
  }

  /// 随机名单
  void randomStu() {
    int r = _random.nextInt(_easyList.length);
    luckyStuInfo = _easyList[r];
    logger.d(luckyStuInfo);

    String? className = luckyStuInfo?.split('|')[0];
    String? idAndName = luckyStuInfo?.split('|')[1];
    String? id = idAndName?.split('&')[0];
    String? stuName = idAndName?.split('&')[1];

    _stuColl.add2TodayChosenMap(className!, idAndName!);
    _easyList.remove(luckyStuInfo);

    setState(() {
      _thisStu = StuModel(stuGroup: className, stuID: id!, stuName: stuName!);
    });
  }

  /// 重置easylist列表
  void resetEasyList() {
    _easyList.clear();
    Map<String, List<String>> allMap = _stuColl.stuAll;
    Map<String, List<String>> todayChosenMap = _stuColl.todayChosenMap;

    allMap.forEach((key, value) {
      for (var element in value) {
        _easyList.add('$key|$element');
      }
    });

    todayChosenMap.forEach((key, value) {
      for (var element in value) {
        _easyList.remove('$key|$element');
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
                      title: const Text('全部都抽过一遍啦',style: TextStyle(fontFamily: 'HanSansCN'),),
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
