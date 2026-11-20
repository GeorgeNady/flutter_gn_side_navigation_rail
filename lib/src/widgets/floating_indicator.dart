import 'package:flutter/material.dart';

/// An internal widget rendering the floating highlight indicator in [SideBarAnimated].
class FloatingIndicator extends StatelessWidget {
  final Color color;
  final BorderRadius borderRadius;
  final double height;

  const FloatingIndicator({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
