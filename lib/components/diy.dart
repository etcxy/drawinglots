import 'package:drawinglots/model/user_struct.dart';
import 'package:flutter/material.dart';

import 'combination_widget.dart';

class CustomDemo1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自定义控件"),
      ),
      body: Column(
        children: [
          // CombinationWidget(
          //   model: StuModel(stuGroup: "计算机一班", stuID: "12312", stuName: "张三"),
          //   onPressed: () {
          //     print("安装今日头条");
          //   },
          // )
        ],
      ),
    );
  }
}


// class UpdateWidget extends StatelessWidget {
//   final UpdateItemModel model; //数据模型
//   final VoidCallback onPressed;
//
//   UpdateWidget({Key? key, required this.model, required this.onPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: ClipRect(
//             child: Image.network(
//               model.appIcon,
//               width: 80,
//               height: 80,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         model.appName,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Colors.black),
//                       ),
//                       Text(
//                         model.appType,
//                         style: const TextStyle(
//                             fontSize: 14, color: Colors.black26),
//                       ),
//                       Text(
//                         model.appDecs,
//                         style: const TextStyle(
//                             fontSize: 14, color: Colors.black26),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
//                     alignment: Alignment.topRight,
//                     child: MaterialButton(
//                         onPressed: this.onPressed,
//                         textColor: Colors.blue,
//                         color: Colors.grey,
//                         minWidth: 30,
//                         height: 25,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           "安装",
//                         )),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
