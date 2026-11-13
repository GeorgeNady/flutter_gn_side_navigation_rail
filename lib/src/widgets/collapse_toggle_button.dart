import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// An internal widget rendering the collapse/expand toggle button in [SideBarAnimated].
class CollapseToggleButton extends StatelessWidget {
  final bool isMinimized;
  final VoidCallback onToggle;
  final Color color;
  final Color hoverColor;
  final Color splashColor;
  final Color highlightColor;
  final IconData expandedIcon;
  final IconData collapsedIcon;
  final Widget? expandedWidget;
  final Widget? collapsedWidget;
  final String? tooltip;

  const CollapseToggleButton({
    super.key,
    required this.isMinimized,
    required this.onToggle,
    required this.color,
    required this.hoverColor,
    required this.splashColor,
    required this.highlightColor,
    this.expandedIcon = Icons.space_dashboard_outlined,
    this.collapsedIcon = CupertinoIcons.arrow_right,
    this.expandedWidget,
    this.collapsedWidget,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconChild;
    if (isMinimized) {
      iconChild = collapsedWidget ?? Icon(collapsedIcon, color: color);
    } else {
      iconChild = expandedWidget ?? Icon(expandedIcon, color: color);
    }

    Widget button = IconButton(
      hoverColor: hoverColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      onPressed: onToggle,
      icon: iconChild,
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
