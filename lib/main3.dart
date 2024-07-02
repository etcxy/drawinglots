// lib/main.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/diy.dart';
import 'components/random_text_reveal.dart';

void main() async {
  //数据持久化 初始化

  // runApp(const MainApp());
  runApp(const MyApp());
}

final GlobalKey<RandomTextRevealState> globalKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? tmpStr = '';
  Random r = new Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      // theme: ThemeData(
      //   primarySwatch: Colors.green,
      //   scaffoldBackgroundColor: Colors.black,
      // ),
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: RandomTextReveal(
            key: globalKey,
            initialText: 'adsfavadfasdf',
            shouldPlayOnStart: false,
            text: 'password',
            duration: const Duration(seconds: 1),
            style: GoogleFonts.notoSansHk(
              textStyle: const TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            randomString: Source.alphabets,
            onFinished: () {
              debugPrint('Password cracked successfully');
            },
            curve: Curves.easeIn,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {
            setState(() {
              // var x = r.nextInt(1000).toString();
              // print(x);
              // tmpStr = x;
            });
            globalKey.currentState?.play();
          },
        ),
      ),
    );
  }
}

class AnimatedContainerPage extends StatefulWidget {
  @override
  _AnimatedContainerPageState createState() => _AnimatedContainerPageState();
}

class _AnimatedContainerPageState extends State<AnimatedContainerPage> {
//初始的属性值
  double size = 100;
  double raidus = 25;
  Color color = Colors.yellow;

  void _animate() {
    //改变属性值
    setState(() {
      size = size == 100 ? 200 : 100;
      raidus = raidus == 25 ? 100 : 25;
      color = color == Colors.yellow ? Colors.greenAccent : Colors.yellow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedContainer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RandomTextReveal(
              key: globalKey,
              initialText: 'adsfavadfasdf',
              shouldPlayOnStart: false,
              text: 'password',
              duration: const Duration(seconds: 2),
              style: GoogleFonts.notoSansHk(
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              randomString: Source.alphabets,
              onFinished: () {
                debugPrint('Password cracked successfully');
              },
              curve: Curves.easeIn,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            //在AnimatedContainer上应用属性值
            AnimatedContainer(
              width: size,
              height: size,
              curve: Curves.easeIn,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(raidus),
              ),
              duration: Duration(seconds: 1),
              child: FlutterLogo(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animate,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
