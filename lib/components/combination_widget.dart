import 'package:drawinglots/components/random_text_reveal.dart';
import 'package:drawinglots/main.dart';
import 'package:drawinglots/model/stu_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../page/home.dart';
import 'base_b_widget.dart';

// class CombinationWidget extends StatelessWidget {

//
//   CombinationWidget({Key? key, required this.model, required this.onPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class CombinationWidget extends StatefulWidget {
  StuModel model; //数据模型
  final VoidCallback? onPressed;

  CombinationWidget({super.key, required this.model, this.onPressed});

  @override
  State<CombinationWidget> createState() => _CombinationWidgetState();
}

final GlobalKey<RandomTextRevealState> globalKey = GlobalKey();

class _CombinationWidgetState extends State<CombinationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RandomTextReveal(
            key: globalKey,
            initialText: 'biu~',
            shouldPlayOnStart: false,
            text: widget.model.stuName!,
            duration: Duration(seconds: context.read<StuReady>().rollDuration),
            style: GoogleFonts.notoSansHk(
              textStyle: const TextStyle(
                fontSize: 34,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            randomString: Source.alphabets,
            onFinished: () {
              // debugPrint('============');
              // context.read<StuReady>().update(true);
              // isReady.update(true);
            },
            curve: Curves.bounceIn,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          // Text(
          //   model.stuName,
          //   style: const TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //       color: Colors.black),
          // ),
          // Text(
          //   model.stuID,
          //   style: TextStyle(
          //       color: Colors.black26,
          //       fontSize: 11.0,
          //       // height: 1.2,
          //       fontFamily: "Courier",
          //       background: Paint()..color = Colors.yellow,
          //       // decoration:TextDecoration.underline,
          //       decorationStyle: TextDecorationStyle.dashed),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseBgWidget(
                borderRadius: 50.0,
                borderWidth: 1.0,
                fillDefaultColor: Colors.blue,
                borderColor: Colors.blue,
                padding: const EdgeInsets.only(
                    left: 3.0, right: 3.0, top: 1.0, bottom: 1.0),
                child: Visibility(
                  visible: context.watch<StuReady>().isShow,
                  child: Text(
                    widget.model.stuGroup!,
                    style: const TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ),
              ),
              BaseBgWidget(
                borderRadius: 50.0,
                borderWidth: 1.0,
                fillDefaultColor: Colors.blue,
                borderColor: Colors.blue,
                padding: const EdgeInsets.only(
                    left: 3.0, right: 3.0, top: 1.0, bottom: 1.0),
                child: Visibility(
                  visible: context.watch<StuReady>().isShow,
                  child: Text(
                    widget.model.stuID!,
                    style: const TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          // Text(
          //   model.stuGroup,
          //   style: const TextStyle(
          //       fontSize: 11, color: Colors.black26),
          // ),
        ],
      ),
    );
  }
}
