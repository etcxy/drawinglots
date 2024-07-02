// lib/main.dart

import 'package:drawinglots/page/home.dart';
import 'package:drawinglots/page/import.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

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

final Map<String, List<String>> studentColl = {};

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  Map<String, List<String>> get studentColl => _studentColl;

  void add(String name, List<String> list) {
    _studentColl[name] = list;
    notifyListeners();
  }
}

class StuReady with ChangeNotifier {
  bool _isShow = true;
  int _rollDuration = 2;

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
