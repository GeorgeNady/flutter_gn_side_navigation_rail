import 'package:flutter/widgets.dart';

/// Data model representing a single navigation item in [SideBarAnimated].
class SideBarItem {
  /// The icon displayed when this item is active or selected.
  final IconData iconSelected;

  /// The icon displayed when this item is unselected.
  /// If null, [iconSelected] is used.
  final IconData? iconUnselected;

  /// The text label displayed next to the icon in expanded mode.
  final String text;

  /// Whether this navigation item is disabled.
  /// Disabled items cannot be tapped, will not trigger [onTap], and
  /// are rendered with a dimmed / disabled appearance.
  final bool isDisabled;

  /// Optional tooltip text shown on hover/long-press.
  final String? tooltip;

  const SideBarItem({
    required this.iconSelected,
    this.iconUnselected,
    required this.text,
    this.isDisabled = false,
    this.tooltip,
  });
}
