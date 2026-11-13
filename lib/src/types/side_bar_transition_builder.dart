import 'package:flutter/widgets.dart';

/// Signature for a custom transition builder function applied to the selection indicator
/// during transitions between items in [SideBarAnimated].
typedef SideBarTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);
