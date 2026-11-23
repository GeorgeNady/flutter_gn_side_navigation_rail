import 'package:flutter/widgets.dart';

import '../enums/side_bar_item_type.dart';

/// Data model representing a single navigation or action item in [SideBarAnimated].
class SideBarItem {
  /// The icon displayed when this item is active or selected.
  ///
  /// For [SideBarItemType.action] items, this is used as the default icon when
  /// [iconUnselected] is null.
  final IconData iconSelected;

  /// The icon displayed when this item is unselected.
  /// If null, [iconSelected] is used.
  final IconData? iconUnselected;

  /// The text label displayed next to the icon in expanded mode.
  final String text;

  /// Whether this item is disabled.
  /// Disabled items cannot be tapped, will not trigger callbacks, and
  /// are rendered with a dimmed / disabled appearance.
  final bool isDisabled;

  /// Optional tooltip text shown on hover/long-press.
  final String? tooltip;

  /// The interaction type of this item.
  ///
  /// Defaults to [SideBarItemType.navigation]. Set to [SideBarItemType.action]
  /// for non-selectable action triggers such as Logout, Sync, or Refresh.
  final SideBarItemType type;

  /// Optional callback invoked when this item is tapped (when not disabled).
  ///
  /// Especially useful for [SideBarItemType.action] items so each action can
  /// define its own behavior directly alongside its icon and label.
  final VoidCallback? onTap;

  /// Creates a navigation or action [SideBarItem].
  const SideBarItem({
    required this.iconSelected,
    this.iconUnselected,
    required this.text,
    this.isDisabled = false,
    this.tooltip,
    this.type = SideBarItemType.navigation,
    this.onTap,
  });

  /// Creates a non-selectable action [SideBarItem] (such as Logout, Sync, or
  /// Refresh) that triggers [onTap] without changing the active selection.
  const SideBarItem.action({
    required IconData icon,
    required this.text,
    this.onTap,
    this.isDisabled = false,
    this.tooltip,
  })  : iconSelected = icon,
        iconUnselected = icon,
        type = SideBarItemType.action;

  /// Whether this item is a non-selectable action item.
  bool get isAction => type == SideBarItemType.action;

  /// Whether this item can be selected as an active navigation destination.
  bool get isSelectable => type == SideBarItemType.navigation && !isDisabled;
}
