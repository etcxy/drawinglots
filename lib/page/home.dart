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
  StuModel thisStu = StuModel(stuGroup: "group", stuID: "id", stuName: 'name');

  final Random random = Random();

  List<String> easyList = [];
  late StudentCollection stuColl;

  @override
  void initState() {
    super.initState();
    luckyStuInfo = "lucky";

    stuColl = context.read<StudentCollection>();
    Map<String, List<String>> allMap = stuColl.stuAll;
    Map<String, List<String>> todayChosenMap = stuColl.todayChosenMap;

    allMap.forEach((key, value) {
      for (var element in value) {
        easyList.add('$key|$element');
      }
    });

    todayChosenMap.forEach((key, value) {
      for (var element in value) {
        easyList.remove('$key|$element');
      }
    });
  }

  void randomStu() {
    int r = random.nextInt(easyList.length);
    luckyStuInfo = easyList[r];

    String? className = luckyStuInfo?.split('|')[0];
    String? idAndName = luckyStuInfo?.split('|')[1];
    String? id = idAndName?.split('&')[0];
    String? stuName = idAndName?.split('&')[1];

    stuColl.add2TodayChosenMap(className!, idAndName!);
    easyList.remove(luckyStuInfo);

    print('===========');
    print('easyList:$easyList');
    print('stuColl.todayChosenMap:${stuColl.todayChosenMap}');
    print('===========');

    setState(() {
      thisStu = StuModel(stuGroup: className, stuID: id!, stuName: stuName!);
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
              model: thisStu,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: const Divider(),
            ),
            ElevatedButton(
                onPressed: () {
                  if (easyList.isEmpty) {
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
                child: const Text('Go!'))
          ],
        ),
      ),
    );
  }
}
