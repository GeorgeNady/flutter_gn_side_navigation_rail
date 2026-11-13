import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import '../enums/side_bar_transition_type.dart';

/// Controller for externally managing and observing the state of [SideBarAnimated].
///
/// Provides programmatic control over the active navigation index, the
/// minimized (collapsed) state, and transition animation overrides when switching items.
class SideBarController extends ChangeNotifier {
  int _selectedIndex;
  bool _isMinimized;
  SideBarTransitionType? _lastTransitionType;
  Duration? _lastTransitionDuration;
  Curve? _lastTransitionCurve;

  /// Creates a [SideBarController] with optional initial state.
  SideBarController({
    int initialIndex = 0,
    bool initialMinimized = false,
  })  : _selectedIndex = initialIndex,
        _isMinimized = initialMinimized;

  /// The currently active navigation item index.
  int get selectedIndex => _selectedIndex;

  /// Whether the sidebar is currently minimized into compact rail mode.
  bool get isMinimized => _isMinimized;

  /// The transition animation type specified during the most recent [selectIndex] call.
  SideBarTransitionType? get lastTransitionType => _lastTransitionType;

  /// The transition duration specified during the most recent [selectIndex] call.
  Duration? get lastTransitionDuration => _lastTransitionDuration;

  /// The transition curve specified during the most recent [selectIndex] call.
  Curve? get lastTransitionCurve => _lastTransitionCurve;

  /// Updates the active navigation index and notifies listeners if changed.
  ///
  /// Optionally allows overriding the [transitionType], [duration], and [curve]
  /// for this specific navigation transition.
  void selectIndex(
    int index, {
    SideBarTransitionType? transitionType,
    Duration? duration,
    Curve? curve,
  }) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _lastTransitionType = transitionType;
      _lastTransitionDuration = duration;
      _lastTransitionCurve = curve;
      notifyListeners();
    }
  }

  /// Sets the minimized state and notifies listeners if changed.
  void setMinimized(bool minimized) {
    if (_isMinimized != minimized) {
      _isMinimized = minimized;
      notifyListeners();
    }
  }

  /// Toggles between minimized and expanded states.
  void toggleMinimize() {
    _isMinimized = !_isMinimized;
    notifyListeners();
  }

  /// Expands the sidebar into full width mode.
  void expand() => setMinimized(false);

  /// Collapses the sidebar into compact rail mode.
  void collapse() => setMinimized(true);
}
