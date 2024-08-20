// lib/main.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/diy.dart';
import '../components/random_text_reveal.dart';

void main() async {
  //数据持久化 初始化

  // runApp(const MainApp());
  runApp(ChangeNotifierProvider(
    create: (_) => ToData(),
    child: const MyApp(),
  ));
}

class ToData with ChangeNotifier {
  Map<String, bool> _isSelected = {"demo1": true};

  Map<String, bool> get isSelected => _isSelected;
  int _currentIndex = 0;

  void addOne() {
    _currentIndex++;
    _isSelected["tomas$_currentIndex"] = true;
    notifyListeners();
  }

  void reverseOne(int index) {
    String groupName = _isSelected.keys.elementAt(index);
    _isSelected[groupName] = !_isSelected[groupName]!;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("hello"),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.bottomCenter, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<ToData>(context, listen: false).addOne();
                    });
                  },
                  child: const Text("add")),
              Positioned(
                  right: 8.0,
                  bottom: 12,
                  child: Consumer(builder:
                      (BuildContext context, ToData todata, Widget? child) {
                    return ToggleButtons(
                      selectedColor: Colors.orange,
                      fillColor: Colors.red,
                      renderBorder: false,
                      borderRadius: BorderRadius.circular(10),
                      hoverColor: Colors.cyan,
                      isSelected: todata.isSelected.values.toList(),
                      onPressed: (index) {
                        setState(() {
                          todata.reverseOne(index);
                        });
                      },
                      children: _getChildList(todata.isSelected.keys.toList()),
                    );
                  })),
              // Positioned(
              //     right: 8.0,
              //     bottom: 12,
              //     child: Consumer(builder:
              //         (BuildContext context, ToData todata, Widget? child) {
              //       return const Text("hello");
              //     })),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Divider(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

List<Widget> _getChildList(List<String> listx) {
  List<Widget> list = [];
  listx.forEach((element) {
    list.add(Text(element));
  });
  return list;
}
