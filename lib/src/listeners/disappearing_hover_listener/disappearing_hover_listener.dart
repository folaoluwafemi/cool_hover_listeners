import 'package:cool_hover_listeners/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class DisappearingHoverListener extends StatefulWidget {
  final bool escapeHover;
  final Widget child;
  final double height;
  final double width;

  ///double value between 0 and 1
  final double minOpacity;

  ///defaults to 200 milliseconds
  final Duration animationDuration;

  const DisappearingHoverListener({
    Key? key,
    this.minOpacity = 0.0,
    required this.escapeHover,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 200),
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  State<DisappearingHoverListener> createState() =>
      _DisappearingHoverListenerState();
}

class _DisappearingHoverListenerState extends State<DisappearingHoverListener> {
  late final double minOpacity;
  late final Duration duration;

  @override
  void initState() {
    super.initState();
    minOpacity = widget.minOpacity;
    duration = widget.animationDuration;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onHover: widget.escapeHover
                ? (event) => setOpacityRelativeToHoverOffset(
                      event.localPosition,
                      Size(constraints.maxWidth, constraints.maxHeight),
                    )
                : null,
            child: ValueListenableBuilder<double>(
              valueListenable: opacityNotifier,
              builder: (_, opacity, __) {
                return AnimatedOpacity(
                  duration: duration,
                  opacity: widget.escapeHover ? opacity : 1.0,
                  child: widget.child,
                );
              },
            ),
          );
        },
      ),
    );
  }

  ValueNotifier<double> opacityNotifier = ValueNotifier<double>(1.0);

  void setOpacityRelativeToHoverOffset(
    Offset hoverOffset,
    Size widgetSize,
  ) {
    if (hoverOffset.isWithinBoundsOf(widgetSize) &&
        opacityNotifier.value != 0) {
      opacityNotifier.value = minOpacity;
    }
    if (hoverOffset.isAtExtremeOf(widgetSize)) {
      opacityNotifier.value = 1.0;
    }
  }
}
