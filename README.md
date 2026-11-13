# flutter_gn_side_navigation_rail

A sleek, responsive, and animated side navigation rail / sidebar for Flutter applications.

[![GitHub license](https://img.shields.io/github/license/GeorgeNady/flutter_gn_side_navigation_rail)](https://github.com/GeorgeNady/flutter_gn_side_navigation_rail/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/GeorgeNady/flutter_gn_side_navigation_rail)](https://github.com/GeorgeNady/flutter_gn_side_navigation_rail/stargazers)

## Features

- **Customizable Selection Transitions**: Switch between multiple animation styles (`slide`, `fade`, `scale`, `fadeSlide`, `none`, or `custom`) when changing selected items.
- **Dynamic Programmatic Control**: Trigger animations with specific curves, durations, and transition styles on demand using `SideBarController.selectIndex()`.
- **Responsive & Adaptive**: Smoothly expands and collapses based on a configurable screen width breakpoint (`widthSwitch`) or manual toggle.
- **External State Management**: Expose and control navigation and minimize states using `SideBarController` or direct `isMinimized` / `onMinimizeChanged` properties.
- **Native Typography**: Inherits your project's native theme font family automatically without imposing hardcoded fonts.
- **Disabled Item States**: Mark items with `isDisabled: true` to prevent interaction, dim their appearance, and display custom tooltips.
- **Custom Header & Footer Widgets**: Render any custom widget (logo image, brand banner, avatar, text) via `headerWidget` and `footerWidget`.
- **Custom Toggle Icons**: Customize the expand/collapse button in both states using `expandedToggleIcon` / `collapsedToggleIcon` or custom widgets.
- **Animated Floating Indicator**: Smooth animated indicator container that glides or transitions to the selected navigation item with customizable curves and durations.
- **Clean Architecture & SOLID**: Organized into decoupled models, controllers, enums, and widgets while exposing only clean public APIs.
- **Deeply Customizable**: Fine-tune colors, dimensions, borders, curves, and padding.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_gn_side_navigation_rail:
    git:
      url: https://github.com/GeorgeNady/flutter_gn_side_navigation_rail.git
      ref: main
```

Or when published on [pub.dev](https://pub.dev):

```bash
flutter pub add flutter_gn_side_navigation_rail
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SideBarController _controller;

  final List<SideBarItem> _items = [
    const SideBarItem(
      iconSelected: Icons.dashboard,
      iconUnselected: Icons.dashboard_outlined,
      text: 'Dashboard',
    ),
    const SideBarItem(
      iconSelected: Icons.analytics,
      iconUnselected: Icons.analytics_outlined,
      text: 'Analytics',
    ),
    const SideBarItem(
      iconSelected: Icons.notifications,
      iconUnselected: Icons.notifications_none,
      text: 'Notifications',
    ),
    const SideBarItem(
      iconSelected: Icons.lock,
      iconUnselected: Icons.lock_outline,
      text: 'Security (Disabled)',
      isDisabled: true,
      tooltip: 'Restricted area',
    ),
    const SideBarItem(
      iconSelected: Icons.settings,
      iconUnselected: Icons.settings_outlined,
      text: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = SideBarController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                controller: _controller,
                widthSwitch: 700,
                sidebarItems: _items,
                transitionType: SideBarTransitionType.slide,
                itemTransitionDuration: const Duration(milliseconds: 400),
                itemTransitionCurve: Curves.easeOutCubic,
                headerWidget: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.rocket_launch, size: 40, color: Colors.white),
                ),
                expandedToggleIcon: Icons.menu_open,
                collapsedToggleIcon: Icons.menu,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Active: ${_items[_controller.selectedIndex].text}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Transition Animations

You can customize the item selection animation style globally or per navigation call:

```dart
// Globally configure transition style on SideBarAnimated:
SideBarAnimated(
  transitionType: SideBarTransitionType.scale, // .slide, .fade, .scale, .fadeSlide, .none, .custom
  itemTransitionDuration: const Duration(milliseconds: 450),
  itemTransitionCurve: Curves.easeOutBack,
  sidebarItems: items,
  ...
)

// Or override on-demand with SideBarController:
controller.selectIndex(
  2,
  transitionType: SideBarTransitionType.fade,
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOut,
);

// Or write a completely custom transition:
SideBarAnimated(
  transitionType: SideBarTransitionType.custom,
  itemTransitionBuilder: (context, animation, child) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  },
  sidebarItems: items,
  ...
)
```

## Parameters

### SideBarAnimated

| Parameter | Type | Default | Description |
|---|---|---|---|
| `sidebarItems` | `List<SideBarItem>` | **Required** | The list of navigation items to render. |
| `controller` | `SideBarController?` | `null` | External controller for managing and observing selected index and minimize states. |
| `transitionType` | `SideBarTransitionType` | `SideBarTransitionType.slide` | Transition animation style when switching items (`slide`, `fade`, `scale`, `fadeSlide`, `none`, `custom`). |
| `itemTransitionDuration` | `Duration` | `500ms` | Duration of the transition animation when switching between items. |
| `itemTransitionCurve` | `Curve` | `Curves.easeOutCubic` | Animation curve applied when switching between items. |
| `itemTransitionBuilder` | `SideBarTransitionBuilder?` | `null` | Custom transition widget builder for `SideBarTransitionType.custom`. |
| `isMinimized` | `bool?` | `null` | Directly controls whether the sidebar is collapsed into rail mode. |
| `onMinimizeChanged` | `ValueChanged<bool>?` | `null` | Callback invoked when the minimize state changes. |
| `headerWidget` | `Widget?` | `null` | Custom widget rendered at the top of the sidebar (logo, icon, branding row). |
| `footerWidget` | `Widget?` | `null` | Custom widget rendered at the bottom of the sidebar. |
| `widthSwitch` | `double` | `700` | Screen width breakpoint to automatically toggle between full sidebar and collapsed rail. |
| `onTap` | `ValueChanged<int>?` | `null` | Callback invoked with the selected item index when an enabled item is tapped. |
| `initialIndex` | `int` | `0` | Initial active navigation item index when no controller is used. |
| `sideBarColor` | `Color` | `Color(0xff1D1D1D)` | Background color of the sidebar container. |
| `animatedContainerColor` | `Color` | `Color(0xff323232)` | Background color of the floating selection indicator container. |
| `selectedIconColor` | `Color` | `Colors.white` | Color of active navigation icons. |
| `unselectedIconColor` | `Color` | `Color(0xffA0A5A9)` | Color of inactive navigation icons. |
| `disabledIconColor` | `Color?` | `dimmed` | Color of disabled navigation icons. |
| `unSelectedTextColor` | `Color` | `Color(0xffA0A5A9)` | Text color of inactive navigation labels. |
| `disabledTextColor` | `Color?` | `dimmed` | Text color of disabled navigation labels. |
| `textStyle` | `TextStyle?` | `null` | Base text style for navigation items (inherits native theme font). |
| `selectedTextStyle` | `TextStyle?` | `null` | Typography override for the selected item. |
| `disabledTextStyle` | `TextStyle?` | `null` | Typography override for disabled items. |
| `sideBarWidth` | `double` | `260` | Full width of the expanded sidebar. |
| `sideBarSmallWidth` | `double` | `84` | Width of the sidebar when collapsed into rail mode. |
| `itemHeight` | `double` | `48` | Height of individual item rows. |
| `itemSpacing` | `double` | `8` | Spacing between consecutive item rows. |
| `borderRadius` | `double` | `20` | Corner border radius of the sidebar container. |
| `itemBorderRadius` | `BorderRadius` | `circular(12)` | Border radius of item tiles and floating indicator. |
| `margin` | `EdgeInsetsGeometry` | `EdgeInsets.all(20)` | Outer margin surrounding the sidebar container. |
| `contentPadding` | `EdgeInsetsGeometry?` | `null` | Inner padding for the scrollable items list. |
| `sideBarAnimationDuration` | `Duration` | `700ms` | Duration of the expand/collapse width animation. |
| `curve` | `Curve` | `Curves.easeOut` | Animation curve applied to sidebar expand/collapse transitions. |
| `settingsDivider` | `bool` | `true` | Whether to display a divider line before trailing item(s). |
| `dividerColor` | `Color` | `Color(0xff929292)` | Color of the section divider line. |
| `dividerHeight` | `double` | `12` | Height allocated to the section divider. |
| `dividerThickness` | `double` | `0.2` | Thickness of the section divider line. |
| `showToggleButton` | `bool` | `true` | Whether to show the minimize/expand toggle button at the bottom. |
| `expandedToggleIcon` | `IconData` | `Icons.space_dashboard_outlined` | Icon on the toggle button when expanded. |
| `collapsedToggleIcon` | `IconData` | `CupertinoIcons.arrow_right` | Icon on the toggle button when collapsed. |
| `expandedToggleWidget` | `Widget?` | `null` | Custom widget override for the toggle button in expanded state. |
| `collapsedToggleWidget` | `Widget?` | `null` | Custom widget override for the toggle button in collapsed state. |
| `toggleButtonColor` | `Color?` | `null` | Tint color for the toggle button (defaults to `selectedIconColor`). |
| `hoverColor` | `Color` | `Colors.black38` | Hover color when cursor is over an item. |
| `splashColor` | `Color` | `Colors.black87` | Ink splash color upon tapping an item. |
| `highlightColor` | `Color` | `Colors.black` | Ink highlight color when pressing an item. |

### SideBarItem

| Property | Type | Default | Description |
|---|---|---|---|
| `iconSelected` | `IconData` | **Required** | Icon shown when the item is active / selected. |
| `iconUnselected` | `IconData?` | `null` | Optional icon shown when inactive (defaults to `iconSelected`). |
| `text` | `String` | **Required** | Label text displayed next to the icon in expanded mode. |
| `isDisabled` | `bool` | `false` | Whether this item is disabled. Disabled items cannot be clicked. |
| `tooltip` | `String?` | `null` | Optional tooltip message shown on hover or long-press. |

### SideBarTransitionType

| Value | Description |
|---|---|
| `slide` | Smoothly glides the selection indicator along the rail to the new item. |
| `fade` | Fades the selection indicator into the new item position. |
| `scale` | Scales the selection indicator into the new item position. |
| `fadeSlide` | Combines a smooth glide with a subtle fade effect. |
| `none` | Instantly updates the indicator position with no animation. |
| `custom` | Executes a custom transition builder passed to `itemTransitionBuilder`. |

### SideBarController

| Method / Property | Type | Description |
|---|---|---|
| `selectedIndex` | `int` | The currently active navigation item index. |
| `isMinimized` | `bool` | Whether the sidebar is currently collapsed into rail mode. |
| `selectIndex(int index, {SideBarTransitionType? transitionType, Duration? duration, Curve? curve})` | `void` | Changes the active index with optional per-call transition overrides and notifies listeners. |
| `setMinimized(bool minimized)`| `void` | Sets the collapsed/minimized state and notifies listeners. |
| `toggleMinimize()` | `void` | Toggles between minimized and expanded states. |
| `expand()` | `void` | Expands the sidebar into full width mode. |
| `collapse()` | `void` | Collapses the sidebar into compact rail mode. |

## Example Project

Check the [example](example) directory for a complete working Flutter application demonstrating interactive transition animation switching, external control with `SideBarController`, custom header widgets, disabled item states, and responsive behavior.

## License

MIT
