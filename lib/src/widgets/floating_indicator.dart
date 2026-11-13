import 'package:flutter/material.dart';
import '../models/side_bar_item.dart';

/// An internal widget rendering the floating highlight indicator in [SideBarAnimated].
class FloatingIndicator extends StatelessWidget {
  final Color color;
  final BorderRadius borderRadius;
  final double height;
  final bool isExpanded;
  final SideBarItem item;
  final Color iconColor;
  final TextStyle textStyle;

  const FloatingIndicator({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.height,
    required this.isExpanded,
    required this.item,
    required this.iconColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: KeyedSubtree(
            key: ValueKey<String>(item.text),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  item.iconSelected,
                  color: iconColor,
                  size: 24,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textStyle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
