import 'dart:math';

import 'package:drawinglots/components/combination_widget.dart';
import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/stu_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

/**
 * 每次提交后，flush
 */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  StuModel thisStu = StuModel(stuGroup: "group", stuID: "id", stuName: 'name');

  final Random random = Random();
  final box = GetStorage();

  Map<String, List<String>>? allMap = {};
  Map<String, List<String>>? todayChosenMap = {};

  List<String> easyList = [];

  @override
  void initState() {
    super.initState();
    name = "unknown";
    if (box.hasData('latest_list')) {
      name = box.read('latest_list');
    }
    if (box.hasData('allMap')) {
      allMap = box.read('allMap');
    }
    if (box.hasData('todayChosenMap')) {
      todayChosenMap = box.read('todayChosenMap');
    }
    updatePool();
  }

  void updatePool() {
    allMap?.forEach((key, value) {
      for (var element in value) {
        easyList.add('$key|$element');
      }
    });

    todayChosenMap?.forEach((key, value) {
      for (var element in value) {
        easyList.remove('$key|$element');
      }
    });
  }

  void randomStu() {
    int r = random.nextInt(easyList.length);
    name = easyList[r];

    String? className = name?.split('|')[0];
    String? idAndName = name?.split('|')[1];
    String? id = idAndName?.split('&')[0];
    String? stuName = idAndName?.split('&')[1];

    if (todayChosenMap?[className] == null) {
      todayChosenMap?[className!] = [];
    }
    todayChosenMap?[className]?.add(idAndName!);
    print('chosenMap:${todayChosenMap}');
    easyList.remove(name);

    box.write('todayChosenMap', todayChosenMap);
    print('todayChosenMap****:${box.read('todayChosenMap')}');

    setState(() {
      thisStu = StuModel(stuGroup: className!, stuID: id!, stuName: stuName!);
    });
  }

  @Deprecated('用不到了')
  void setTask(int times) {
    if (times > 70) {
      times -= 2;
    } else if (times > 40 && times <= 70) {
      times = times - 4;
    } else if (times <= 40 && times > 0) {
      times -= 8;
    } else {
      print('name:$name');
      String? className = name?.split('|')[0];
      String? idAndName = name?.split('|')[1];
      String? id = idAndName?.split('&')[0];
      String? stuName = idAndName?.split('&')[1];

      if (todayChosenMap?[className] == null) {
        todayChosenMap?[className!] = [];
      }
      todayChosenMap?[className]?.add(idAndName!);
      print('chosenMap:${todayChosenMap}');
      easyList.remove(name);

      box.write('todayChosenMap', todayChosenMap);
      print('todayChosenMap****:${box.read('todayChosenMap')}');

      return;
    }
    //异步执行 https://juejin.cn/post/6844903769793118215
    Future.delayed(
        Duration(milliseconds: (200 - times)),
        () => {
              // print('当前时间：${DateTime.now()}'),
              setState(() {
                int r = random.nextInt(easyList.length);
                name = easyList[r];
              }),
              setTask(times),
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
                          milliseconds: context.read<StuReady>().rollDuration*1000 + 20),
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
