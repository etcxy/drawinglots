import 'dart:math';

import 'package:drawinglots/components/combination_widget.dart';
import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/stu_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool _tipVisible = true;

  @override
  void initState() {
    super.initState();
    luckyStuInfo = "lucky";

    _stuColl = context.read<StudentCollection>();
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

    Future.delayed(
        const Duration(seconds: 2),
        () => {
              setState(() {
                _tipVisible = false;
              }),
            });
  }

  void randomStu() {
    int r = _random.nextInt(_easyList.length);
    luckyStuInfo = _easyList[r];

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

  @override
  Widget build(BuildContext context) {
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
                    //todo 提示剩余列表为空
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
                  _stuColl.resetTodayChosenMap();
                },
                child: const Text('Go!')),
            Visibility(
                visible: _tipVisible,
                child: const Text(
                  'tips:长按按钮，\n可重置被选中的名单',
                  style: TextStyle(
                      fontSize: 9,
                      color: Colors.black26,
                      textBaseline: TextBaseline.ideographic),
                )),
          ],
        ),
      ),
    );
  }
}
