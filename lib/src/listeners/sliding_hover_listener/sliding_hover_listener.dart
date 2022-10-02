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
    this.width = 300,
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
      width: maxExtent,
      child: MouseRegion(
        onHover: widget.escapeHover
            ? (PointerHoverEvent event) => setNextPositionRelativeToHoverOffset(
                  event.localPosition,
                )
            : null,
        child: AnimatedAlign(
          duration:
              widget.animationDuration ?? const Duration(milliseconds: 100),
          alignment: widget.escapeHover ? childAlignment : Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }

  void setNextPositionRelativeToHoverOffset(Offset hoverOffset) {
    final double thirdWidth = maxExtent / 3;

    ///if in the left extreme of the max space
    if (hoverOffset.dx < thirdWidth) {
      if (childAlignment != maxExtremeAlignment) {
        setState(() {
          childAlignment = Alignment.center;
        });
      }
    }

    ///if in the middle of the max space
    else if (hoverOffset.dx > thirdWidth && hoverOffset.dx < (thirdWidth * 2)) {
      setState(() {
        final double currentCenterXOffset = hoverOffset.dx - thirdWidth;

        final double percentCenterXOffset = thirdWidth.percent(
          currentCenterXOffset,
        );

        ///if the greater half of the middle of the max space
        if (percentCenterXOffset > 50) {
          childAlignment = minExtremeAlignment;
        } else {
          childAlignment = maxExtremeAlignment;
        }
      });
    }

    ///if at the right extreme of the max space
    else {
      if (childAlignment != minExtremeAlignment) {
        setState(() {
          childAlignment = Alignment.center;
        });
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

  Alignment childAlignment = Alignment.center;
}
