// lib/main.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  //数据持久化 初始化

  // runApp(const MainApp());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // 中文简体
        Locale('en', 'US'), // 美国英语
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        // 默认字体: 这里使用的是 pubspec.yaml 文件中，自定义的字体
        fontFamily: 'HanSansCN',
        // 当默认字体中不包含对应文字时，会按顺序使用fallback中的字体渲染
        fontFamilyFallback: const [
          'MiSans',
          'Helvetica Neue',
          'PingFang SC',
          'Source Han Sans SC',
          'Noto Sans CJK SC'
        ],
      ),
      home: const MyHomePage(title: 'Flutter 中文测试'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(height: 1.5, fontSize: 18),
          locale: const Locale.fromSubtags(
              languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flutter 中文测试 如下是你点击按钮的次数:',
            ),
            const Text(
              '雷电将军',
            ),
            TextButton(
                onPressed: () => debugPrint('123'), child: const Text('角色按钮')),
            ElevatedButton(
                onPressed: () => debugPrint('123'), child: const Text('甘雨')),
            const Text('固件升级123'),
            const Text(
              'abc经营统计123！。；.;',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
