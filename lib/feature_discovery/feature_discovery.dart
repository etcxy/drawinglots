// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:get_storage/get_storage.dart';

const _featureHighlightShownKey = 'feature_highlight_shown';


class FeatureDiscoveryController extends StatefulWidget {
  final Widget child;

  const FeatureDiscoveryController(this.child, {super.key});

  static _FeatureDiscoveryControllerState _of(BuildContext context) {
    final matchResult =
        context.findAncestorStateOfType<_FeatureDiscoveryControllerState>();
    if (matchResult != null) {
      return matchResult;
    }

    throw FlutterError(
        'FeatureDiscoveryController.of() called with a context that does not '
        'contain a FeatureDiscoveryController.\n The context used was:\n '
        '$context');
  }

  @override
  State<FeatureDiscoveryController> createState() =>
      _FeatureDiscoveryControllerState();
}

class _FeatureDiscoveryControllerState
    extends State<FeatureDiscoveryController> {
  bool _isLocked = false;


  bool get isLocked => _isLocked;

  void lock() => _isLocked = true;

  /// Unlock the controller.
  void unlock() => setState(() => _isLocked = false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(
      context.findAncestorStateOfType<_FeatureDiscoveryControllerState>() ==
          null,
      'There should not be another ancestor of type '
      'FeatureDiscoveryController in the widget tree.',
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Widget that highlights the [child] with an overlay.
///
/// This widget loosely follows the guidelines set forth in the Material Specs:
/// https://material.io/archive/guidelines/growth-communications/feature-discovery.html.
class FeatureDiscovery extends StatefulWidget {
  /// Title to be displayed in the overlay.
  final String title;

  /// Description to be displayed in the overlay.
  final String description;

  /// Icon to be promoted.
  final Icon child;

  /// Flag to indicate whether to show the overlay or not anchored to the
  /// [child].
  final bool showOverlay;

  /// Callback invoked when the user dismisses an overlay.
  final void Function()? onDismiss;

  /// Callback invoked when the user taps on the tap target of an overlay.
  final void Function()? onTap;

  /// Color with which to fill the outer circle.
  final Color? color;

  @visibleForTesting
  static const overlayKey = Key('overlay key');

  @visibleForTesting
  static const gestureDetectorKey = Key('gesture detector key');

  const FeatureDiscovery({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.showOverlay,
    this.onDismiss,
    this.onTap,
    this.color,
  });

  @override
  State<FeatureDiscovery> createState() => _FeatureDiscoveryState();
}

class _FeatureDiscoveryState extends State<FeatureDiscovery>
    with TickerProviderStateMixin {
  bool showOverlay = false;

  late AnimationController openController;
  late AnimationController rippleController;
  late AnimationController tapController;
  late AnimationController dismissController;


  OverlayEntry? overlay;

  Widget buildOverlay(BuildContext ctx, Offset center) {
    debugCheckHasMediaQuery(ctx);
    debugCheckHasDirectionality(ctx);

    final deviceSize = MediaQuery.of(ctx).size;
    final color = widget.color ?? Theme.of(ctx).colorScheme.primary;

    // Wrap in transparent [Material] to enable widgets that require one.
    return Material(
      key: FeatureDiscovery.overlayKey,
      type: MaterialType.transparency,
      child: Stack(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              key: FeatureDiscovery.gestureDetectorKey,
              onTap: dismiss,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Method to handle user tap on [TapTarget].
  ///
  /// Tapping will stop any active controller and start the [tapController].
  void tap() {
    openController.stop();
    rippleController.stop();
    dismissController.stop();
    tapController.forward(from: 0.0);
  }

  /// Method to handle user dismissal.
  ///
  /// Dismissal will stop any active controller and start the
  /// [dismissController].
  void dismiss() {
    openController.stop();
    rippleController.stop();
    tapController.stop();
    dismissController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, _) {
      if (overlay != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // [OverlayEntry] needs to be explicitly rebuilt when necessary.
          overlay!.markNeedsBuild();
        });
      } else {
        if (showOverlay && !FeatureDiscoveryController._of(ctx).isLocked) {
          final entry = OverlayEntry(
            builder: (_) => buildOverlay(ctx, getOverlayCenter(ctx)),
          );

          // Lock [FeatureDiscoveryController] early in order to prevent
          // another [FeatureDiscovery] widget from trying to show its
          // overlay while the post frame callback and set state are not
          // complete.
          FeatureDiscoveryController._of(ctx).lock();

          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              overlay = entry;
              openController.forward(from: 0.0);
            });
            Overlay.of(context).insert(entry);
          });
        }
      }
      return widget.child;
    });
  }

  /// Compute the center position of the overlay.
  Offset getOverlayCenter(BuildContext parentCtx) {
    final box = parentCtx.findRenderObject() as RenderBox;
    final size = box.size;
    final topLeftPosition = box.localToGlobal(Offset.zero);
    final centerPosition = Offset(
      topLeftPosition.dx + size.width / 2,
      topLeftPosition.dy + size.height / 2,
    );
    return centerPosition;
  }

  @override
  void initState() {
    super.initState();

    initAnimationControllers();
    initAnimations();

    //数据初始化对象
    final localStorage = GetStorage();

    final featureHiglightShown =
        localStorage.read<bool>(_featureHighlightShownKey) ?? false;
    localStorage.write(_featureHighlightShownKey, true);
    showOverlay = widget.showOverlay && !featureHiglightShown;
    if (showOverlay) {
      localStorage.write(_featureHighlightShownKey, true);
    }
  }

  void initAnimationControllers() {
    openController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
        } else if (animationStatus == AnimationStatus.completed) {
          rippleController.forward(from: 0.0);
        }
      });

    rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
        } else if (animationStatus == AnimationStatus.completed) {
          rippleController.forward(from: 0.0);
        }
      });

    tapController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
        } else if (animationStatus == AnimationStatus.completed) {
          widget.onTap?.call();
          cleanUponOverlayClose();
        }
      });

    dismissController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.forward) {
        } else if (animationStatus == AnimationStatus.completed) {
          widget.onDismiss?.call();
          cleanUponOverlayClose();
        }
      });
  }

  void initAnimations() {

  }

  /// Clean up once overlay has been dismissed or tap target has been tapped.
  ///
  /// This is called upon [tapController] and [dismissController] end.
  void cleanUponOverlayClose() {
    FeatureDiscoveryController._of(context).unlock();
    setState(() {
      showOverlay = false;
      overlay?.remove();
      overlay = null;
    });
  }

  @override
  void didUpdateWidget(FeatureDiscovery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOverlay != oldWidget.showOverlay) {
      showOverlay = widget.showOverlay;
    }
  }

  @override
  void dispose() {
    overlay?.remove();
    openController.dispose();
    rippleController.dispose();
    tapController.dispose();
    dismissController.dispose();
    super.dispose();
  }
}
