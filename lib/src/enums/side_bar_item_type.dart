/// Defines the interaction behavior of a [SideBarItem] in [SideBarAnimated].
enum SideBarItemType {
  /// A standard selectable navigation destination.
  ///
  /// Tapping updates the active index, animates the floating selection
  /// indicator, and invokes [SideBarAnimated.onTap] (as well as
  /// [SideBarItem.onTap] if provided).
  navigation,

  /// A non-selectable action item for one-off commands such as Logout, Sync,
  /// or Refresh.
  ///
  /// Tapping executes [SideBarItem.onTap] and [SideBarAnimated.onActionTap]
  /// without changing the selected index or moving the floating indicator.
  action,
}
