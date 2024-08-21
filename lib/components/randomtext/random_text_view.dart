import 'package:drawinglots/components/base_b_widget.dart';
import 'package:drawinglots/components/random_text_reveal.dart';
import 'package:drawinglots/components/randomtext/random_text_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'random_text_logic.dart';

class Random_textComponent extends StatefulWidget {
  const Random_textComponent({Key? key}) : super(key: key);

  @override
  State<Random_textComponent> createState() => _Random_textComponentState();
}

class _Random_textComponentState extends State<Random_textComponent> {
  final Random_textLogic logic = Get.put(Random_textLogic());
  final Random_textState state = Get.find<Random_textLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: state.isShow.value,
                  child: TDAvatar(
                    backgroundColor: Colors.blueGrey,
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.customText,
                    shape: TDAvatarShape.circle,
                    text: state.userEntity.value.userName[state.userEntity.value.userName.length - 1],
                    // text: 'a',
                  )),
              RandomTextReveal(
                key: logic.globalKey,
                initialText: state.userEntity.value.userName,
                shouldPlayOnStart: false,
                text: state.userEntity.value.userName,
                duration: Duration(seconds: 2),
                style: GoogleFonts.notoSansHk(
                  textStyle: const TextStyle(
                    fontSize: 34,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                randomString: Source.lowercase,
                onFinished: () {},
                curve: Curves.bounceIn,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
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
                      visible: state.isShow.value,
                      child: Text(
                        state.userEntity.value.userID,
                        style:
                            const TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
