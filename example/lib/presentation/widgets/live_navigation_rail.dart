import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

import '../bloc/playground_bloc.dart';
import '../bloc/playground_event.dart';
import '../bloc/playground_state.dart';
import '../theme/studio_theme.dart';

/// Renders `SideBarAnimated` configured from the current [PlaygroundState].
class LiveNavigationRail extends StatelessWidget {
  /// Current playground state snapshot.
  final PlaygroundState state;

  /// Creates a live navigation rail bound to [state].
  const LiveNavigationRail({super.key, required this.state});

  Widget _buildCustomTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }
    switch (state.config.customTransitionMode) {
      case 'rotateScale':
        return RotationTransition(
          turns: Tween<double>(begin: -0.04, end: 0.0).animate(animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      case 'horizontalSlide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.35, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      case 'sizeExpand':
      default:
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlaygroundBloc>();
    final cfg = state.config;
    final colors = StudioColors.of(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final isMinimized = state.isCurrentlyMinimized;

    final composedRail = Color.alphaBlend(cfg.sideBarColor, colors.canvas);
    final isLightRail = composedRail.computeLuminance() > 0.179;
    final railInk = isLightRail ? const Color(0xFF0F172A) : Colors.white;
    final footerBackground = isLightRail
        ? const Color(0xFF0F172A).withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.07);
    final footerText = isLightRail ? const Color(0xFF334155) : Colors.white70;

    return SideBarAnimated(
      controller: cfg.useController ? bloc.sideBarController : null,
      isMinimized: cfg.useDirectIsMinimized ? cfg.directIsMinimized : null,
      initialIndex: cfg.initialIndex.clamp(0, cfg.sidebarItems.length - 1),
      onTap: (index) => bloc.add(PlaygroundRailTapped(index)),
      onActionTap: (index) => bloc.add(PlaygroundRailActionTapped(index)),
      onMinimizeChanged: (minimized) =>
          bloc.add(PlaygroundRailMinimizeReported(minimized)),
      sidebarItems: cfg.sidebarItems,
      widthSwitch: cfg.widthSwitch,
      sideBarWidth: cfg.sideBarWidth,
      sideBarSmallWidth: cfg.sideBarSmallWidth,
      shrinkWrap: cfg.shrinkWrap,
      height: cfg.useCustomHeight ? cfg.customHeight : null,
      itemHeight: cfg.itemHeight,
      itemSpacing: cfg.itemSpacing,
      borderRadius: cfg.borderRadius,
      itemBorderRadius: BorderRadius.circular(cfg.itemBorderRadiusValue),
      margin: EdgeInsets.all(cfg.marginAll),
      contentPadding: cfg.useCustomContentPadding
          ? EdgeInsets.symmetric(
              horizontal: cfg.contentPaddingHorizontal,
              vertical: cfg.contentPaddingVertical,
            )
          : null,
      sideBarColor: cfg.sideBarColor,
      animatedContainerColor: cfg.animatedContainerColor,
      selectedIconColor: cfg.selectedIconColor,
      unselectedIconColor: cfg.unselectedIconColor,
      disabledIconColor:
          cfg.useCustomDisabledIconColor ? cfg.disabledIconColor : null,
      unSelectedTextColor: cfg.unSelectedTextColor,
      disabledTextColor:
          cfg.useCustomDisabledTextColor ? cfg.disabledTextColor : null,
      textStyle: cfg.useCustomTextStyle
          ? TextStyle(
              fontSize: cfg.baseFontSize,
              fontWeight: cfg.baseFontWeight,
            )
          : null,
      selectedTextStyle: cfg.useCustomSelectedTextStyle
          ? TextStyle(
              color: cfg.selectedTextColor,
              fontSize: cfg.selectedFontSize,
              fontWeight: cfg.selectedFontWeight,
            )
          : null,
      disabledTextStyle: cfg.useCustomDisabledTextStyle
          ? TextStyle(
              fontSize: cfg.disabledFontSize,
              fontStyle:
                  cfg.disabledFontItalic ? FontStyle.italic : FontStyle.normal,
              color: cfg.useCustomDisabledTextColor
                  ? cfg.disabledTextColor
                  : cfg.unSelectedTextColor.withValues(alpha: 0.38),
            )
          : null,
      settingsDivider: cfg.settingsDivider,
      dividerColor: cfg.dividerColor,
      dividerHeight: cfg.dividerHeight,
      dividerThickness: cfg.dividerThickness,
      hoverColor: cfg.hoverColor,
      splashColor: cfg.splashColor,
      highlightColor: cfg.highlightColor,
      curve: PlaygroundBloc.curveOptions[cfg.curveKey] ?? Curves.easeOut,
      sideBarAnimationDuration: disableAnimations
          ? Duration.zero
          : Duration(milliseconds: cfg.sideBarAnimationDurationMs),
      transitionType:
          disableAnimations ? SideBarTransitionType.none : cfg.transitionType,
      itemTransitionDuration: disableAnimations
          ? Duration.zero
          : Duration(milliseconds: cfg.itemTransitionDurationMs),
      itemTransitionCurve:
          PlaygroundBloc.curveOptions[cfg.itemTransitionCurveKey] ??
              Curves.easeOutCubic,
      itemTransitionBuilder: _buildCustomTransition,
      headerWidget: cfg.showHeaderWidget
          ? LayoutBuilder(
              builder: (context, constraints) {
                final showTitle = !isMinimized && constraints.maxWidth >= 110;
                return Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth.clamp(0.0, 44.0),
                      height: 44,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 44,
                          height: 44,
                          excludeFromSemantics: showTitle,
                          semanticLabel: showTitle ? null : 'MyApp',
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.rocket_launch,
                            size: 32,
                            color: cfg.selectedIconColor,
                            semanticLabel: showTitle ? null : 'MyApp',
                          ),
                        ),
                      ),
                    ),
                    if (showTitle) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'MyApp',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: railInk,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            )
          : null,
      footerWidget: cfg.showFooterWidget
          ? LayoutBuilder(
              builder: (context, constraints) {
                final showName = !isMinimized && constraints.maxWidth >= 110;
                final isNarrow = constraints.maxWidth < 48;
                const avatar = CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF4F46E5),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
                );
                return Semantics(
                  label: showName ? null : 'User profile: George N.',
                  child: Container(
                    padding: EdgeInsets.all(isNarrow ? 4 : 10),
                    decoration: BoxDecoration(
                      color: footerBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExcludeSemantics(
                          child: isNarrow
                              ? const Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: avatar,
                                  ),
                                )
                              : avatar,
                        ),
                        if (showName) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'George N.',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: footerText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            )
          : null,
      showToggleButton: cfg.showToggleButton,
      expandedToggleIcon:
          PlaygroundBloc.toggleIconOptions[cfg.expandedToggleIconKey] ??
              Icons.menu_open,
      collapsedToggleIcon:
          PlaygroundBloc.toggleIconOptions[cfg.collapsedToggleIconKey] ??
              Icons.menu,
      expandedToggleWidget: cfg.useCustomToggleWidgets
          ? Semantics(
              button: true,
              label: 'Collapse navigation rail',
              excludeSemantics: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.first_page, size: 18, color: railInk),
                      const SizedBox(width: 4),
                      Text(
                        'Hide',
                        style: TextStyle(fontSize: 11, color: railInk),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      collapsedToggleWidget: cfg.useCustomToggleWidgets
          ? Semantics(
              button: true,
              label: 'Expand navigation rail',
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.last_page, size: 18, color: railInk),
              ),
            )
          : null,
      toggleButtonColor:
          cfg.useCustomToggleButtonColor ? cfg.toggleButtonColor : null,
      scrollPhysics: PlaygroundBloc.physicsOptions[cfg.scrollPhysicsKey] ??
          const BouncingScrollPhysics(),
    );
  }
}
