import 'package:flutter/material.dart';

extension NumExtension on num {
  SizedBox get boxHeight => SizedBox(height: toDouble());

  SizedBox get boxWidth => SizedBox(width: toDouble());

  double get percentage => this * 100;

  bool isBetween(num num1, num num2) => this >= num1 && this <= num2;

  double percent(double value) => (value / 100) * this;
}

extension BuildContextExtension on BuildContext {
  Size get queryScreenSize => MediaQuery.of(this).size;
}

extension OffsetExtension on Offset {
  bool isWithinBoundsOf(Size size) => dx <= size.width && dy <= size.height;

  bool isAtExtremeOf(Size size, {double tolerance = 5}) =>
      dx.isBetween(
        size.width - tolerance,
        size.width,
      ) ||
      dx.isBetween(0, tolerance) ||
      dy.isBetween(0, tolerance) ||
      dy.isBetween(
        size.height - tolerance,
        size.height,
      );
}
