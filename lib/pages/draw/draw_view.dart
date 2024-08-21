import 'package:drawinglots/state/global_st_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'draw_logic.dart';

class DrawPage extends StatelessWidget {
  const DrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<DrawLogic>();
    final state = Get.find<DrawLogic>().state;

    var glb_stLogic = Get.find<Global_stLogic>();

    final box = GetStorage();

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pix.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.bottomCenter, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              const Text(
                'designer by 1000000000',
                // style: TextStyle(fontFamily: 'MiSans'),
              ),
              // Positioned(
              //   right: 8.0,
              //   bottom: 12,
              //   child: ToggleButtons(
              //     selectedColor: Colors.black,
              //     fillColor: Colors.blue,
              //     renderBorder: true,
              //     borderRadius: BorderRadius.circular(25),
              //     hoverColor: Colors.blueGrey,
              //     // isSelected: _selected,
              //     isSelected: [true, false, false],
              //     onPressed: (index) {
              //       // setState(() {
              //       //   _selected[index] = !_selected[index];
              //       //   _stuColl.selected[groupList[index]] = _selected[index];
              //       // });
              //     },
              //     children: _getChildList(groupList),
              //   ),
              // ),
              Positioned(
                  right: 1.0,
                  bottom: 1,
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Obx(() => Wrap(
                          spacing: 3.0,
                          runSpacing: 3.0,
                          alignment: WrapAlignment.end,
                          verticalDirection: VerticalDirection.up,
                          // children: _getChildList(glb_stLogic),
                          children: glb_stLogic.state.tagSet
                              .map((element) => TDSelectTag(
                                    element,
                                    icon: TDIcons.discount,
                                    theme: TDTagTheme.primary,
                                    isOutline: true,
                                    isLight: true,
                                    isSelected: !glb_stLogic.state.cancelTagSet
                                        .contains(element),
                                    disableSelect: !glb_stLogic.state.leftTagSet
                                        .contains(element),
                                    onSelectChanged: (bool value) {
                                      if (value) {
                                        glb_stLogic.state.cancelTagSet
                                            .remove(element);
                                      } else {
                                        glb_stLogic.state.cancelTagSet
                                            .add(element);
                                      }
                                      glb_stLogic.flushAllCollections();
                                      glb_stLogic.flushAllTags();
                                    },
                                  ))
                              .toList(),
                        )),
                  )),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CombinationWidget(
                      //   model: _thisStu,
                      // ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Divider(),
                      ),

                      TDButton(
                        text: 'Go!',
                        icon: TDIcons.chevron_right_double,
                        size: TDButtonSize.medium,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: () {
                          try {
                            logic.getRandomUser();
                          } catch (e) {
                            TDToast.showText('已全部中签\n可长按重置',
                                duration: const Duration(milliseconds: 700),
                                context: context);
                          }

                          glb_stLogic.saveToLocalStorage();
                        },
                        onLongPress: () {
                          glb_stLogic.state.cancelTagSet.clear();
                          glb_stLogic.state.selectedUserList.clear();
                          glb_stLogic.flushAllCollections();
                          glb_stLogic.flushAllTags();

                          TDToast.showIconText('已重置',
                              icon: TDIcons.check_circle,
                              direction: IconTextDirection.vertical,
                              duration: const Duration(milliseconds: 500),
                              context: context);

                          glb_stLogic.saveToLocalStorage();
                        },
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

