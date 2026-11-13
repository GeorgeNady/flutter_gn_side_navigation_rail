/// Defines the transition animation style when changing between selected items in [SideBarAnimated].
enum SideBarTransitionType {
  /// The floating indicator smoothly slides along the rail to the new item position.
  slide,

  /// The indicator fades into the new item position.
  fade,

  /// The indicator scales into the new item position.
  scale,

  /// Combines a smooth slide with a fade transition.
  fadeSlide,

  /// Instant position update with no transition animation.
  none,

  /// Uses a custom transition widget provided by [SideBarAnimated.itemTransitionBuilder].
  custom,
}
