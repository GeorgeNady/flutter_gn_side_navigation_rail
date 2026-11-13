import 'package:flutter/material.dart';
import '../models/side_bar_item.dart';

/// An internal widget that renders a single item row in [SideBarAnimated].
class SideBarItemTile extends StatelessWidget {
  final SideBarItem item;
  final bool isSelected;
  final bool isExpanded;
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
    required this.isExpanded,
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

    Widget content = SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              effectiveIcon,
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
