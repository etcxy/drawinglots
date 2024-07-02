// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// enum CustomTextDirection {
//   localeBased,
//   ltr,
//   rtl,
// }
//
// const systemLocaleOption = Locale('system');
//
// Locale? _deviceLocale;
//
// Locale? get deviceLocale => _deviceLocale;
//
//
//
// class GalleryOptions{
//   const GalleryOptions({
//     required this.themeMode,
//     required double? textScaleFactor,
//     required this.customTextDirection,
//     required Locale? locale,
//     required this.timeDilation,
//     required this.platform,
//     required this.isTestMode,
//   })  : _textScaleFactor = textScaleFactor ?? 1.0,
//         _locale = locale;
//
//   final ThemeMode themeMode;
//   final double _textScaleFactor;
//   final CustomTextDirection customTextDirection;
//   final Locale? _locale;
//   final double timeDilation;
//   final TargetPlatform? platform;
//   final bool isTestMode; // True for integration tests.
//
//   double textScaleFactor(BuildContext context,{bool useSentinel = false}){
//     //TODO
//     return 1.0;
//   }
//
//   Locale? get locale => _locale ?? deviceLocale;
//
//
//   TextDirection? resolvedTextDirection(){
//     return TextDirection.ltr;
//   }
//
//   SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
//     return SystemUiOverlayStyle.light;
//   }
//
//   static GalleryOptions of(BuildContext context) {
//     final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
//     return scope.modelBindingState.currentModel;
//   }
// }
//
//
// class ModelBinding extends StatefulWidget {
//   const ModelBinding({
//     super.key,
//     required this.initialModel,
//     required this.child,
//   });
//
//   final Widget child;
//   final GalleryOptions initialModel;
//
//   @override
//   State<ModelBinding> createState() => _ModelBindingState();
//
// }
//
// class _ModelBindingState extends State<ModelBinding> {
//   late GalleryOptions currentModel;
//
//   Timer? _timeDilationTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     currentModel = widget.initialModel;
//   }
//
//   @override
//   void dispose() {
//     _timeDilationTimer?.cancel();
//     _timeDilationTimer = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _ModelBindingScope(
//       modelBindingState: this,
//       child: widget.child,
//     );
//   }
// }
//
// class ModelBindingScope extends StatefulWidget {
//   const ModelBindingScope({super.key});
//
//   @override
//   State<ModelBindingScope> createState() => _ModelBindingScopeState();
// }
//
// class _ModelBindingScopeState extends State<ModelBindingScope> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
// //InheritedWidget 用于在应用程序的不同的部分之间共享数据
// class _ModelBindingScope extends InheritedWidget {
//   const _ModelBindingScope({
//     required this.modelBindingState,
//     required super.child,
//   });
//
//   final _ModelBindingState modelBindingState;
//
//   @override
//   bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
// }
