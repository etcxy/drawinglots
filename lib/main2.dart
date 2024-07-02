// lib/main.dart

import 'package:flutter/material.dart';

import 'components/diy.dart';

void main() async {
  //数据持久化 初始化

  // runApp(const MainApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomDemo1(),
    );
  }
}

