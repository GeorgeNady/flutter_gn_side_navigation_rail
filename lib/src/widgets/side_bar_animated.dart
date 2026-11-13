import 'dart:ui' show lerpDouble;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/side_bar_controller.dart';
import '../enums/side_bar_transition_type.dart';
import '../models/side_bar_item.dart';
import '../types/side_bar_transition_builder.dart';
import 'collapse_toggle_button.dart';
import 'floating_indicator.dart';
import 'side_bar_item_tile.dart';

/// A sleek, responsive, and animated side navigation rail / sidebar for Flutter.
///
/// Features smooth responsive transitions between expanded and collapsed states,
/// customizable item-to-item transition animations (slide, fade, scale, fadeSlide, none, custom),
/// external controller support, and native host project typography inheritance.
class SideBarAnimated extends StatefulWidget {
  /// Callback triggered when an active item is tapped with its index.
  final ValueChanged<int>? onTap;

  /// External controller for managing and observing navigation and minimize state.
  final SideBarController? controller;

  /// Directly control the minimized (collapsed) state from outside.
  final bool? isMinimized;

  /// Callback invoked when the minimize state changes.
  final ValueChanged<bool>? onMinimizeChanged;

  /// Initial selected item index if [controller] is not provided.
  final int initialIndex;

  /// Custom widget rendered at the top of the sidebar (e.g. Logo, avatar, branding).
  final Widget? headerWidget;

  /// Optional widget displayed at the bottom of the sidebar (above or below toggle button).
  final Widget? footerWidget;

  /// The list of items displayed in the sidebar. Must not be empty.
  final List<SideBarItem> sidebarItems;

  /// Screen width threshold below which the sidebar automatically collapses.
  final double widthSwitch;

  /// Width of the sidebar when fully expanded.
  final double sideBarWidth;

  /// Compact width of the sidebar when collapsed into rail mode.
  final double sideBarSmallWidth;

  /// Height of each navigation item tile.
  final double itemHeight;

  /// Spacing between consecutive navigation items.
  final double itemSpacing;

  /// Outer corner border radius of the sidebar container.
  final double borderRadius;

  /// Corner border radius of individual navigation items and floating indicator.
  final BorderRadius itemBorderRadius;

  /// Outer margin around the sidebar container.
  final EdgeInsetsGeometry margin;

  /// Inner padding for the scrollable navigation item list.
  final EdgeInsetsGeometry? contentPadding;

  /// Background color of the sidebar container.
  final Color sideBarColor;

  /// Background color of the floating animated selection indicator.
  final Color animatedContainerColor;

  /// Color of the selected navigation icon.
  final Color selectedIconColor;

  /// Color of unselected navigation icons.
  final Color unselectedIconColor;

  /// Color of disabled navigation icons. If null, a dimmed version of [unselectedIconColor] is used.
  final Color? disabledIconColor;

  /// Text color of unselected navigation item labels.
  final Color unSelectedTextColor;

  /// Text color of disabled navigation item labels. If null, a dimmed version of [unSelectedTextColor] is used.
  final Color? disabledTextColor;

  /// Base typography style for navigation items. Inherits native host project font family when null.
  final TextStyle? textStyle;

  /// Custom typography style for the selected navigation item.
  final TextStyle? selectedTextStyle;

  /// Custom typography style for disabled navigation items.
  final TextStyle? disabledTextStyle;

  /// Color of the section divider line.
  final Color dividerColor;

  /// Height allocated to the section divider.
  final double dividerHeight;

  /// Line thickness of the section divider.
  final double dividerThickness;

  /// Whether to show a divider before the trailing item(s).
  final bool settingsDivider;

  /// Hover highlight color for item interaction.
  final Color hoverColor;

  /// Splash ink color upon tapping an item.
  final Color splashColor;

  /// Highlight ink color when pressing an item.
  final Color highlightColor;

  /// Animation curve applied to width changes (sidebar expand/collapse).
  final Curve curve;

  /// Duration of the container expand / collapse animation.
  final Duration sideBarAnimationDuration;

  /// Animation style applied when changing selection between items.
  final SideBarTransitionType transitionType;

  /// Duration of the transition animation when switching between items.
  final Duration itemTransitionDuration;

  /// Animation curve applied when switching between items.
  final Curve itemTransitionCurve;

  /// Custom transition builder used when [transitionType] is set to [SideBarTransitionType.custom].
  final SideBarTransitionBuilder? itemTransitionBuilder;

  /// Whether to display the collapse / expand toggle button at the bottom.
  final bool showToggleButton;

  /// Icon displayed on the toggle button when the sidebar is expanded.
  final IconData expandedToggleIcon;

  /// Icon displayed on the toggle button when the sidebar is collapsed.
  final IconData collapsedToggleIcon;

  /// Custom widget override for the expanded toggle button icon.
  final Widget? expandedToggleWidget;

  /// Custom widget override for the collapsed toggle button icon.
  final Widget? collapsedToggleWidget;

  /// Tint color for the toggle button. Defaults to [selectedIconColor].
  final Color? toggleButtonColor;

  /// Scroll physics for the navigation items scroll view.
  final ScrollPhysics scrollPhysics;

  SideBarAnimated({
    super.key,
    required this.sidebarItems,
    this.widthSwitch = 700,
    this.onTap,
    this.controller,
    this.isMinimized,
    this.onMinimizeChanged,
    this.initialIndex = 0,
    Widget? headerWidget,
    Widget? logoWidget,
    this.footerWidget,
    this.sideBarWidth = 260,
    this.sideBarSmallWidth = 84,
    this.itemHeight = 48,
    this.itemSpacing = 8,
    this.borderRadius = 20,
    BorderRadius? itemBorderRadius,
    this.margin = const EdgeInsets.all(20),
    this.contentPadding,
    this.sideBarColor = const Color(0xff1D1D1D),
    this.animatedContainerColor = const Color(0xff323232),
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = const Color(0xffA0A5A9),
    this.disabledIconColor,
    this.unSelectedTextColor = const Color(0xffA0A5A9),
    this.disabledTextColor,
    this.textStyle,
    this.selectedTextStyle,
    this.disabledTextStyle,
    this.dividerColor = const Color(0xff929292),
    this.dividerHeight = 12,
    this.dividerThickness = 0.2,
    this.settingsDivider = true,
    this.hoverColor = Colors.black38,
    this.splashColor = Colors.black87,
    this.highlightColor = Colors.black,
    this.curve = Curves.easeOut,
    this.sideBarAnimationDuration = const Duration(milliseconds: 700),
    Duration? itemTransitionDuration,
    Duration floatingAnimationDuration = const Duration(milliseconds: 500),
    this.transitionType = SideBarTransitionType.slide,
    Curve? itemTransitionCurve,
    this.itemTransitionBuilder,
    this.showToggleButton = true,
    this.expandedToggleIcon = Icons.space_dashboard_outlined,
    this.collapsedToggleIcon = CupertinoIcons.arrow_right,
    this.expandedToggleWidget,
    this.collapsedToggleWidget,
    this.toggleButtonColor,
    this.scrollPhysics = const BouncingScrollPhysics(),
  })  : headerWidget = headerWidget ?? logoWidget,
        itemTransitionDuration = itemTransitionDuration ?? floatingAnimationDuration,
        itemTransitionCurve = itemTransitionCurve ?? curve,
        itemBorderRadius = itemBorderRadius ?? BorderRadius.circular(12),
        assert(sidebarItems.isNotEmpty, "sidebarItems cannot be empty");

  /// Duration of the floating indicator glide animation (for backward compatibility).
  Duration get floatingAnimationDuration => itemTransitionDuration;

  @override
  State<SideBarAnimated> createState() => _SideBarAnimatedState();
}

class _SideBarAnimatedState extends State<SideBarAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _animation;
  late int _currentIndex;
  double _previousTop = 0;
  double _targetTop = 0;
  bool _internalMinimized = false;
  SideBarTransitionType? _activeTransitionType;

  bool get _isMinimized {
    if (widget.controller != null) {
      return widget.controller!.isMinimized;
    }
    if (widget.isMinimized != null) {
      return widget.isMinimized!;
    }
    return _internalMinimized;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.controller?.selectedIndex ?? widget.initialIndex;
    _targetTop = _calculateItemTop(_currentIndex);
    _previousTop = _targetTop;
    _internalMinimized = widget.isMinimized ?? widget.controller?.isMinimized ?? false;

    _transitionController = AnimationController(
      vsync: this,
      duration: widget.itemTransitionDuration,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _transitionController,
      curve: widget.itemTransitionCurve,
    );

    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant SideBarAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
      if (widget.controller != null) {
        _animateToIndex(widget.controller!.selectedIndex);
      }
    }
    if (widget.isMinimized != null && widget.isMinimized != oldWidget.isMinimized) {
      _internalMinimized = widget.isMinimized!;
    }
    if (widget.itemTransitionDuration != oldWidget.itemTransitionDuration) {
      _transitionController.duration = widget.itemTransitionDuration;
    }
    if (widget.itemTransitionCurve != oldWidget.itemTransitionCurve) {
      _animation = CurvedAnimation(
        parent: _transitionController,
        curve: widget.itemTransitionCurve,
      );
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _transitionController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller != null && mounted) {
      final controller = widget.controller!;
      if (_internalMinimized != controller.isMinimized) {
        setState(() {
          _internalMinimized = controller.isMinimized;
        });
      }
      if (_currentIndex != controller.selectedIndex) {
        _animateToIndex(
          controller.selectedIndex,
          transitionOverride: controller.lastTransitionType,
          durationOverride: controller.lastTransitionDuration,
          curveOverride: controller.lastTransitionCurve,
        );
      }
    }
  }

  void _animateToIndex(
    int newIndex, {
    SideBarTransitionType? transitionOverride,
    Duration? durationOverride,
    Curve? curveOverride,
  }) {
    if (newIndex < 0 || newIndex >= widget.sidebarItems.length) return;
    if (widget.sidebarItems[newIndex].isDisabled) return;

    final prevIndex = _currentIndex;
    if (prevIndex == newIndex && _transitionController.isCompleted) return;

    final currentTop = lerpDouble(_previousTop, _targetTop, _animation.value) ?? _targetTop;

    setState(() {
      _currentIndex = newIndex;
      _previousTop = currentTop;
      _targetTop = _calculateItemTop(newIndex);
      _activeTransitionType = transitionOverride;
    });

    final effectiveType = transitionOverride ?? widget.transitionType;
    if (effectiveType == SideBarTransitionType.none) {
      _previousTop = _targetTop;
      _transitionController.value = 1.0;
    } else {
      _transitionController.duration = durationOverride ?? widget.itemTransitionDuration;
      _animation = CurvedAnimation(
        parent: _transitionController,
        curve: curveOverride ?? widget.itemTransitionCurve,
      );
      _transitionController.forward(from: 0.0);
    }
  }

  void _toggleMinimize() {
    final next = !_isMinimized;
    if (widget.controller != null) {
      widget.controller!.setMinimized(next);
    } else {
      setState(() {
        _internalMinimized = next;
      });
    }
    widget.onMinimizeChanged?.call(next);
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= widget.sidebarItems.length) return;
    if (widget.sidebarItems[index].isDisabled) return;

    if (widget.controller != null) {
      widget.controller!.selectIndex(index);
    } else {
      _animateToIndex(index);
    }
    widget.onTap?.call(index);
  }

  double _calculateItemTop(int targetIndex) {
    double top = 0;
    final dividerIndex = widget.sidebarItems.length - 2;
    for (int i = 0; i < targetIndex; i++) {
      top += widget.itemHeight;
      if (widget.settingsDivider && i == dividerIndex) {
        top += widget.dividerHeight;
      } else {
        top += widget.itemSpacing;
      }
    }
    return top;
  }

  double _calculateTotalHeight() {
    if (widget.sidebarItems.isEmpty) return 0;
    return _calculateItemTop(widget.sidebarItems.length - 1) + widget.itemHeight;
  }

  TextStyle _resolveTextStyle(SideBarItem item, bool isSelected) {
    final theme = Theme.of(context);
    final baseStyle = widget.textStyle ??
        theme.textTheme.bodyMedium?.copyWith(fontSize: 16) ??
        const TextStyle(fontSize: 16);

    if (item.isDisabled) {
      return widget.disabledTextStyle ??
          baseStyle.copyWith(
            color: widget.disabledTextColor ??
                widget.unSelectedTextColor.withValues(alpha: 0.38),
          );
    }

    if (isSelected) {
      return widget.selectedTextStyle ??
          baseStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          );
    }

    return baseStyle.copyWith(color: widget.unSelectedTextColor);
  }

  Color _resolveIconColor(SideBarItem item, bool isSelected) {
    if (item.isDisabled) {
      return widget.disabledIconColor ??
          widget.unselectedIconColor.withValues(alpha: 0.38);
    }
    if (isSelected) {
      return widget.selectedIconColor;
    }
    return widget.unselectedIconColor;
  }

  Widget _buildIndicatorWidget({
    required Widget indicatorChild,
    required SideBarTransitionType type,
  }) {
    switch (type) {
      case SideBarTransitionType.none:
        return Positioned(
          top: _targetTop,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: indicatorChild,
        );

      case SideBarTransitionType.slide:
        final top = lerpDouble(_previousTop, _targetTop, _animation.value) ?? _targetTop;
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: indicatorChild,
        );

      case SideBarTransitionType.fade:
        return Positioned(
          top: _targetTop,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: FadeTransition(
            opacity: _animation,
            child: indicatorChild,
          ),
        );

      case SideBarTransitionType.scale:
        return Positioned(
          top: _targetTop,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: ScaleTransition(
            scale: _animation,
            child: indicatorChild,
          ),
        );

      case SideBarTransitionType.fadeSlide:
        final top = lerpDouble(_previousTop, _targetTop, _animation.value) ?? _targetTop;
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: FadeTransition(
            opacity: _animation,
            child: indicatorChild,
          ),
        );

      case SideBarTransitionType.custom:
        if (widget.itemTransitionBuilder != null) {
          return Positioned(
            top: _targetTop,
            left: 0,
            right: 0,
            height: widget.itemHeight,
            child: widget.itemTransitionBuilder!(context, _animation, indicatorChild),
          );
        }
        final top = lerpDouble(_previousTop, _targetTop, _animation.value) ?? _targetTop;
        return Positioned(
          top: top,
          left: 0,
          right: 0,
          height: widget.itemHeight,
          child: indicatorChild,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final isScreenNarrow = screenWidth < widget.widthSwitch;
    final isEffectiveMinimized = isScreenNarrow || _isMinimized;
    final isExpanded = !isEffectiveMinimized;

    final totalHeight = _calculateTotalHeight();
    final safeIndex = (_currentIndex >= 0 && _currentIndex < widget.sidebarItems.length)
        ? _currentIndex
        : 0;
    final activeItem = widget.sidebarItems[safeIndex];

    final defaultPadding = EdgeInsets.only(
      top: 40,
      left: isExpanded ? 20 : 18,
      right: isExpanded ? 20 : 18,
      bottom: 24,
    );

    final effectiveTransitionType = _activeTransitionType ?? widget.transitionType;

    return AnimatedContainer(
      curve: widget.curve,
      height: screenHeight,
      margin: widget.margin,
      width: isExpanded ? widget.sideBarWidth : widget.sideBarSmallWidth,
      decoration: BoxDecoration(
        color: widget.sideBarColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      duration: widget.sideBarAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerWidget != null)
            Padding(
              padding: EdgeInsets.only(
                left: isExpanded ? 20 : 18,
                right: isExpanded ? 20 : 18,
                top: 24,
              ),
              child: widget.headerWidget!,
            ),
          Expanded(
            child: SingleChildScrollView(
              physics: widget.scrollPhysics,
              padding: widget.contentPadding ?? defaultPadding,
              child: SizedBox(
                height: totalHeight,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return _buildIndicatorWidget(
                          type: effectiveTransitionType,
                          indicatorChild: FloatingIndicator(
                            color: widget.animatedContainerColor,
                            borderRadius: widget.itemBorderRadius,
                            height: widget.itemHeight,
                            isExpanded: isExpanded,
                            item: activeItem,
                            iconColor: widget.selectedIconColor,
                            textStyle: _resolveTextStyle(activeItem, true),
                          ),
                        );
                      },
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.sidebarItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.sidebarItems[index];
                        final isSelected = index == safeIndex;
                        return SideBarItemTile(
                          item: item,
                          isSelected: isSelected,
                          isExpanded: isExpanded,
                          height: widget.itemHeight,
                          borderRadius: widget.itemBorderRadius,
                          iconColor: _resolveIconColor(item, isSelected),
                          textStyle: _resolveTextStyle(item, isSelected),
                          hoverColor: widget.hoverColor,
                          splashColor: widget.splashColor,
                          highlightColor: widget.highlightColor,
                          onTap: () => _onItemTapped(index),
                        );
                      },
                      separatorBuilder: (context, index) {
                        if (index == widget.sidebarItems.length - 2 &&
                            widget.settingsDivider) {
                          return Divider(
                            height: widget.dividerHeight,
                            thickness: widget.dividerThickness,
                            color: widget.dividerColor,
                          );
                        }
                        return SizedBox(height: widget.itemSpacing);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.footerWidget != null)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 20 : 18,
                vertical: 8,
              ),
              child: widget.footerWidget!,
            ),
          if (widget.showToggleButton && !isScreenNarrow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: CollapseToggleButton(
                isMinimized: isEffectiveMinimized,
                onToggle: _toggleMinimize,
                color: widget.toggleButtonColor ?? widget.selectedIconColor,
                hoverColor: widget.hoverColor,
                splashColor: widget.splashColor,
                highlightColor: widget.highlightColor,
                expandedIcon: widget.expandedToggleIcon,
                collapsedIcon: widget.collapsedToggleIcon,
                expandedWidget: widget.expandedToggleWidget,
                collapsedWidget: widget.collapsedToggleWidget,
              ),
            ),
        ],
      ),
    );
  }
}
