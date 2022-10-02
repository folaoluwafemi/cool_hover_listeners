import 'package:cool_hover_listeners/src/listeners/sliding_hover_listener/sliding_axis.dart';
import 'package:cool_hover_listeners/src/package_barrel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SlidingHoverListener extends StatefulWidget {
  final Widget child;
  final bool escapeHover;
  final Duration? animationDuration;
  final SlidingAxis axis;
  final double? width;
  final double? height;

  ///todo: add doc
  const SlidingHoverListener({
    Key? key,
    required this.child,
    required this.escapeHover,
    this.width,
    this.axis = SlidingAxis.horizontal,
    this.animationDuration,
    this.height,
  })  : assert(
          (axis == SlidingAxis.horizontal) ? width != null : height != null,
          'max extent for an axis must not be null',
        ),
        super(key: key);

  @override
  State<SlidingHoverListener> createState() => _SlidingHoverListenerState();
}

class _SlidingHoverListenerState extends State<SlidingHoverListener> {
  late final double maxExtent;
  late final SlidingAxis axis;

  @override
  void initState() {
    super.initState();
    maxExtent = (widget.axis == SlidingAxis.horizontal)
        ? widget.width!
        : widget.height!;
    axis = widget.axis;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: axis == SlidingAxis.horizontal ? maxExtent : null,
      height: axis == SlidingAxis.vertical ? maxExtent : null,
      child: MouseRegion(
        onHover: widget.escapeHover
            ? (PointerHoverEvent event) => setNextPositionRelativeToHoverOffset(
                  event.localPosition,
                )
            : null,
        child: ValueListenableBuilder<Alignment>(
          valueListenable: childAlignmentNotifier,
          builder: (context, alignment, _) {
            return AnimatedAlign(
              duration:
                  widget.animationDuration ?? const Duration(milliseconds: 100),
              alignment: widget.escapeHover ? alignment : Alignment.center,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }

  void setNextPositionRelativeToHoverOffset(Offset hoverOffset) {
    final double thirdWidth = maxExtent / 3;
    final double directionalHoverOffset =
        axis == SlidingAxis.horizontal ? hoverOffset.dx : hoverOffset.dy;

    ///if in the left extreme of the max space
    if (directionalHoverOffset < thirdWidth) {
      if (childAlignmentNotifier.value != maxExtremeAlignment) {
        childAlignmentNotifier.value = Alignment.center;
      }
    }

    ///if in the middle of the max space
    else if (directionalHoverOffset > thirdWidth &&
        directionalHoverOffset < (thirdWidth * 2)) {
      final double currentCenterXOffset = directionalHoverOffset - thirdWidth;

      final double percentCenterXOffset = thirdWidth.percent(
        currentCenterXOffset,
      );

      ///if the greater half of the middle of the max space
      if (percentCenterXOffset > 50) {
        childAlignmentNotifier.value = minExtremeAlignment;
      } else {
        childAlignmentNotifier.value = maxExtremeAlignment;
      }
    }

    ///if at the right extreme of the max space
    else {
      if (childAlignmentNotifier.value != minExtremeAlignment) {
        childAlignmentNotifier.value = Alignment.center;
      }
    }
  }

  Alignment get maxExtremeAlignment {
    return (axis == SlidingAxis.vertical)
        ? Alignment.bottomCenter
        : Alignment.centerRight;
  }

  Alignment get minExtremeAlignment {
    return (axis == SlidingAxis.vertical)
        ? Alignment.topCenter
        : Alignment.centerLeft;
  }

  ValueNotifier<Alignment> childAlignmentNotifier =
      ValueNotifier(Alignment.center);
}
