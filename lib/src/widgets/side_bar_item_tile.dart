import 'package:flutter/material.dart';
import '../models/side_bar_item.dart';

/// An internal widget that renders a single item row in [SideBarAnimated].
class SideBarItemTile extends StatelessWidget {
  final SideBarItem item;
  final bool isSelected;
  final double labelOpacity;
  final double height;
  final BorderRadius borderRadius;
  final Color iconColor;
  final TextStyle textStyle;
  final Color hoverColor;
  final Color splashColor;
  final Color highlightColor;
  final VoidCallback? onTap;

  const SideBarItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.labelOpacity,
    required this.height,
    required this.borderRadius,
    required this.iconColor,
    required this.textStyle,
    required this.hoverColor,
    required this.splashColor,
    required this.highlightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = isSelected
        ? item.iconSelected
        : (item.iconUnselected ?? item.iconSelected);

    const double iconSize = 24.0;
    const double iconTextGap = 12.0;

    Widget content = SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth =
              constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
          final double horizontalPadding =
              ((maxWidth - iconSize) / 2).clamp(0.0, 12.0);
          final double innerWidth =
              (maxWidth - horizontalPadding * 2).clamp(0.0, double.infinity);
          final double availableTextWidth = innerWidth - iconSize - iconTextGap;
          final double clampedOpacity = labelOpacity.clamp(0.0, 1.0);
          final bool shouldShowLabel =
              clampedOpacity > 0 && availableTextWidth > 0;

          Widget iconWidget = Icon(
            effectiveIcon,
            color: iconColor,
            size: iconSize,
          );
          if (innerWidth < iconSize) {
            iconWidget = SizedBox(
              width: innerWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: iconWidget,
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget,
                if (shouldShowLabel) ...[
                  const SizedBox(width: iconTextGap),
                  Expanded(
                    child: Opacity(
                      opacity: clampedOpacity,
                      child: Text(
                        item.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: textStyle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );

    if (item.tooltip != null && item.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: item.tooltip!,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: item.isDisabled ? null : onTap,
        mouseCursor: item.isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        hoverColor: hoverColor,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: content,
      ),
    );
  }
}
