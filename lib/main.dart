// lib/main.dart

import 'package:drawinglots/page/home.dart';
import 'package:drawinglots/page/import.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() async {
  loggerNoStack.i('Info message');

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
  bool _isShow = true;
  int _itermPage = 1;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    box.erase();
    //初始化数据
    if (!box.hasData('allMap')) {
      box.write('allMap', {
        "计算机一班": ["202101&张三", "202102&李四", "202103&王五", "202104&赵六"],
        "计算机二班": ["202111&张1", "202112&李2", "202113&王3", "202114&赵4"],
      });
    }

    if (!box.hasData('todayChosenMap')) {
      box.write('todayChosenMap', {
        "计算机一班": ["202104&赵六"],
      });
    }

    StudentCollection stu =
        Provider.of<StudentCollection>(context, listen: false);
    stu.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'HanSansCN'),
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: ,
          title: const Text('biubiubiu'),
          //标题居中
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.home),
            selectedIcon: const Icon(Icons.home_max),
            tooltip: "主页",
            onPressed: () {
              setState(() {
                _itermPage = 1;
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
                  _itermPage = 2;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.import_contacts_sharp),
              tooltip: "导入",
              onPressed: () {
                setState(() {
                  _itermPage = 3;
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
            child: _itermPage == 1
                ? const HomePage()
                : _itermPage == 2
                    ? const ImportPage()
                    : Container()),
      ),
    );
  }
}

class StudentCollection with ChangeNotifier {
  Map<String, List<String>> _studentColl = {};

  //所有
  Map<String, List<String>> _stuAll = {};

  //选过
  Map<String, List<String>> _todayChosenMap = {};

  Map<String, List<String>> get studentColl => _studentColl;

  Map<String, List<String>> get stuAll => _stuAll;

  Map<String, List<String>> get todayChosenMap => _todayChosenMap;

  final box = GetStorage();

  void init() {
    if (box.hasData('allMap')) {
      _stuAll = box.read('allMap');
    }
    if (box.hasData('todayChosenMap')) {
      _todayChosenMap = box.read('todayChosenMap');
    }
    // notifyListeners();
  }

  /// 导入功能:
  /// 1. 导入数据
  /// 2. 清空todayChosenMap
  Future<void> importMap(Map<String, List<String>> map) async {
    _stuAll = map;
    _todayChosenMap.clear();
    notifyListeners();
  }

  /// 清空所有map
  void eraseMap() {
    _stuAll.clear();
    _todayChosenMap.clear();
    notifyListeners();
  }

  /// 往allMap里添加
  void add2Map(String className, String stuName) {}

  /// 往todayChosenMap里添加
  void add2TodayChosenMap(String className, String stuName) {
    if (_todayChosenMap.containsKey(className)) {
      _todayChosenMap[className]?.add(stuName);
    } else {
      _todayChosenMap[className] = [stuName];
    }
    // notifyListeners();
  }

  /// 删除todayChosenMap里的数据
  void deleteFromTodayChosenMap(String className, String stuName) {
    _todayChosenMap[className]?.remove(stuName);
  }

  /// 重置todayChosenMap里的数据
  void resetTodayChosenMap() {
    _todayChosenMap.clear();
    box.write('todayChosenMap', _todayChosenMap);
  }

  /// 保存数据到本地
  void flushChosenMap() {
    box.write('todayChosenMap', _todayChosenMap);
  }

  void flushAllMap() {
    box.write('allMap', _stuAll);
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
