// lib/main.dart

import 'dart:convert';

import 'package:drawinglots/page/demo.dart';
import 'package:drawinglots/page/home.dart';
import 'package:drawinglots/page/import.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'Utils.dart';
import 'model/user_struct.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  //数据持久化 初始化
  await GetStorage.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StudentCollection()),
      ChangeNotifierProvider(create: (_) => StuReady()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //TODO 这玩意show 什么
  bool _isShow = true;
  int _itermPage = 0;
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    // Utils.debugGenerateMap(_box);
    Utils.generateRandomStudents(_box, 5, 1);

    StudentCollection stu =
        Provider.of<StudentCollection>(context, listen: false);
    stu.initData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'HanSansCN'),

      home: Scaffold(
        appBar: AppBar(
          title: const Text('biu-biu-biu'),
          //标题居中
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.home),
            selectedIcon: const Icon(Icons.home_max),
            tooltip: "主页",
            onPressed: () {
              setState(() {
                _itermPage = 0;
                _isShow = !_isShow;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: "设置",
              onPressed: () {
                setState(() {
                  _itermPage = 1;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.import_contacts_sharp),
              tooltip: "导入",
              onPressed: () {
                setState(() {
                  _itermPage = 1;
                  _isShow = !_isShow;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pix.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: IndexedStack(
            index: _itermPage,
            children: const [
              HomePage(),
              ImportPage(),
              DemoPage(slug: '占位用'),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentCollection with ChangeNotifier {
  //所有
  Map<String, List<UserStruct>> _stuAll = {};

  //选过
  Map<String, List<UserStruct>> _todayChosenMap = {};

  // List<bool> _selected = [];
  Map<String, bool> _selected = {};

  Map<String, List<UserStruct>> get stuAll => _stuAll;

  Map<String, List<UserStruct>> get todayChosenMap => _todayChosenMap;

  Map<String, bool> get selected => _selected;

  final box = GetStorage();

  ///初始化数据
  void initData() {
    ///初始化allMap，这里面包含了所有的学生
    if (box.hasData('allMap')) {
      var allMapStr = box.read("allMap");
      List<dynamic> allList = List<dynamic>.from(jsonDecode(allMapStr));
      allList.map((userJson) {
        var userItem = UserStruct.fromJson(userJson);
        if (!_stuAll.containsKey(userItem.userGroup)) {
          _stuAll[userItem.userGroup] = [];
          _stuAll[userItem.userGroup]!.add(userItem);
        } else {
          _stuAll[userItem.userGroup] = [userItem];
        }
        return {userItem};
      }).toList();
    }

    ///今天被选中的学生
    DateTime now = DateTime.now();

    // 提取年、月、日
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String current = '$year-$month-$day';

    if (box.hasData('latest_time') && current == box.read("latest_time")) {
      if (box.hasData('todayChosenMap')) {
        var todayChosenStr = box.read("todayChosenMap");
        List<dynamic> todayChosenList =
            List<dynamic>.from(jsonDecode(todayChosenStr));
        todayChosenList.map((userJson) {
          var userItem = UserStruct.fromJson(userJson);
          if (!_stuAll.containsKey(userItem.userGroup)) {
            _todayChosenMap[userItem.userGroup] = [];
            _todayChosenMap[userItem.userGroup]!.add(userItem);
          } else {
            _todayChosenMap[userItem.userGroup] = [userItem];
          }
        });
      }
    }

    ///初始化selected
    if (box.hasData('selected')) {
      _selected = jsonDecode(box.read("selected"));
    } else {
      _stuAll.keys.forEach((element) {
        _selected[element] = true;
      });
    }
  }

  /// 导入功能:
  /// 1. 清空所有数据结构
  /// 2. 初始化所有数据结构
  Future<void> importMap(Map<String, List<UserStruct>> map) async {
    logger.d('importMap');
    _stuAll.clear();
    _selected.clear();
    _todayChosenMap.clear();

    _stuAll.addAll(map);

    _stuAll.keys.forEach((element) {
      _selected[element] = true;
    });
    flushAllMap();

    notifyListeners();
  }

  /// 清空所有map
  void eraseMap() {
    _stuAll.clear();
    _todayChosenMap.clear();
    _selected.clear();

    notifyListeners();
  }

  /// cwasZ
  void add2Map(String className, String stuName) {}

  /// 往todayChosenMap里添加
  void add2TodayChosenMap(UserStruct user) {
    if (_todayChosenMap.containsKey(user.userGroup)) {
      _todayChosenMap[user.userGroup]?.add(user);
    } else {
      _todayChosenMap[user.userGroup] = [];
      _todayChosenMap[user.userGroup]?.add(user);
    }
  }

  /// 删除todayChosenMap里的数据
  void deleteFromTodayChosenMap(UserStruct user) {
    _todayChosenMap[user.userGroup]?.remove(user);
  }

  /// 重置todayChosenMap里的数据
  void resetTodayChosenMap() {
    _todayChosenMap.clear();
    box.write('todayChosenMap', jsonEncode(_todayChosenMap));
  }

  /// 保存数据到本地
  void flushChosenMap() {
    box.write('todayChosenMap', jsonEncode(_todayChosenMap));
  }

  void flushAllMap() {
    box.write('allMap', jsonEncode(_stuAll));
  }

  void flushSelected() {
    box.write('selected', jsonEncode(_selected));
  }
}

class StuReady with ChangeNotifier {
  bool _isShow = true;
  final int _rollDuration = 2;

  int get rollDuration => _rollDuration;

  bool get isShow => _isShow;

  void visible() {
    _isShow = true;
    notifyListeners();
  }

  void inVisible() {
    _isShow = false;
    notifyListeners();
  }
}
