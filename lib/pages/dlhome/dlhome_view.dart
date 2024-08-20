import 'package:drawinglots/page/import.dart';
import 'package:drawinglots/pages/draw/draw_logic.dart';
import 'package:drawinglots/pages/draw/draw_view.dart';
import 'package:drawinglots/pages/import_file/import_file_logic.dart';
import 'package:drawinglots/pages/import_file/import_file_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'dlhome_logic.dart';

Widget? _selectedIcon;

Widget? _unSelectedIcon;

class DlhomePage extends StatefulWidget {
  const DlhomePage({super.key});

  @override
  State<DlhomePage> createState() => _DlhomePageState();
}

class _DlhomePageState extends State<DlhomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    print('初始化 数据...');
    _tabController = TabController(
        vsync: this, //固定写法
        length: 3 //指定tab长度
        );

    _tabController.addListener(() {
      var index = _tabController.index;
      var previousIndex = _tabController.previousIndex;
      print("index: $index");
      print('previousIndex: $previousIndex');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<DlhomeLogic>();
    final state = Get.find<DlhomeLogic>().state;

    _selectedIcon = Icon(
      TDIcons.app,
      size: 20,
      color: TDTheme.of(context).brandNormalColor,
    );
    _unSelectedIcon = Icon(
      TDIcons.app,
      size: 20,
      color: TDTheme.of(context).brandNormalColor,
    );

    return Scaffold(
      appBar: TDNavBar(
          useDefaultBack: false,
          screenAdaptation: false,
          centerTitle: false,
          titleMargin: 0,
          titleWidget: const TDImage(
            assetUrl: 'assets/img/td_brand.png',
            width: 102,
            height: 24,
          ),
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home, iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24)
          ]),
      bottomNavigationBar: TDBottomTabBar(
        TDBottomTabBarBasicType.iconText,
        componentType: TDBottomTabBarComponentType.label,
        outlineType: TDBottomTabBarOutlineType.capsule,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            tabText: '抽签',
            onTap: () {
              // onTapTab(context, '标签1');
              _tabController.index = 0;
            },
          ),
          TDBottomTabBarTabConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            tabText: '导入',
            onTap: () {
              // onTapTab(context, '标签2');
              _tabController.index = 1;
            },
          ),
          TDBottomTabBarTabConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            tabText: '设置',
            onTap: () {
              // onTapTab(context, '标签3');
              _tabController.index = 2;
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          GetBuilder<DrawLogic>(
            init: DrawLogic(),
            builder: (context) {
              return DrawPage();
            },
          ),
          GetBuilder<Import_fileLogic>(
            init: Import_fileLogic(),
            builder: (context) {
              return Import_filePage();
            },
          ),
          ListView(
            children: <Widget>[
              ListTile(title: Text("tab3")),
              ListTile(title: Text("tab3")),
              ListTile(title: Text("tab3"))
            ],
          )
        ],
      ),
      // GetBuilder(
      //   init: DrawLogic(),
      //   builder: (context) {
      //     return DrawPage();
      //   },
      // ),
    );
  }
}
