# flutter_gn_side_navigation_rail

A modern, responsive, and animated side navigation rail / sidebar widget for Flutter applications.

[![GitHub license](https://img.shields.io/github/license/GeorgeNady/flutter_gn_side_navigation_rail)](https://github.com/GeorgeNady/flutter_gn_side_navigation_rail/blob/main/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/GeorgeNady/flutter_gn_side_navigation_rail)](https://github.com/GeorgeNady/flutter_gn_side_navigation_rail/stargazers)

## Features

- **Responsive & Adaptive**: Smoothly switches between an expanded sidebar and a compact navigation rail based on screen width (`widthSwitch`) or manual toggle.
- **Animated Floating Indicator**: A smooth animated indicator container that glides to the selected navigation item with customizable duration and curve.
- **Deeply Customizable**: Fine-tune colors for background, floating indicator, selected/unselected icons, text, hover, splash, and border radius.
- **Section Dividers**: Built-in divider support to separate standard navigation from bottom/settings actions.
- **Header Logo**: Integrated support for displaying your application's brand or logo at the top of the rail.
- **Clean & Lightweight**: Simple API built purely with Flutter widgets and animations.

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
  int _currentIndex = 0;

  final List<SideBarItem> _items = [
    SideBarItem(
      iconSelected: Icons.dashboard,
      iconUnselected: Icons.dashboard_outlined,
      text: 'Dashboard',
    ),
    SideBarItem(
      iconSelected: Icons.analytics,
      iconUnselected: Icons.analytics_outlined,
      text: 'Analytics',
    ),
    SideBarItem(
      iconSelected: Icons.notifications,
      iconUnselected: Icons.notifications_none,
      text: 'Notifications',
    ),
    SideBarItem(
      iconSelected: Icons.settings,
      iconUnselected: Icons.settings_outlined,
      text: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBarAnimated(
            mainLogoImage: 'assets/logo.png',
            widthSwitch: 700,
            sidebarItems: _items,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Selected Page: ${_items[_currentIndex].text}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Parameters

### SideBarAnimated

| Parameter | Type | Default | Description |
|---|---|---|---|
| `sidebarItems` | `List<SideBarItem>` | **Required** | The list of navigation items to render. |
| `widthSwitch` | `double` | **Required** | Width breakpoint to automatically toggle between expanded and collapsed rail. |
| `mainLogoImage` | `String` | **Required** | Asset path of the brand logo displayed at the top. |
| `onTap` | `ValueChanged<int>?` | `null` | Callback invoked when an item is tapped with its index. |
| `sideBarColor` | `Color` | `Color(0xff1D1D1D)` | Background color of the sidebar container. |
| `animatedContainerColor` | `Color` | `Color(0xff323232)` | Background color of the floating selection indicator container. |
| `selectedIconColor` | `Color` | `Colors.white` | Color of the active icon and toggle button. |
| `unselectedIconColor` | `Color` | `Color(0xffA0A5A9)` | Color of inactive navigation icons. |
| `unSelectedTextColor` | `Color` | `Color(0xffA0A5A9)` | Text color of inactive navigation labels. |
| `textStyle` | `TextStyle` | `TextStyle(...)` | Typography style applied to the item labels. |
| `sideBarWidth` | `double` | `260` | Full width of the expanded sidebar. |
| `sideBarSmallWidth` | `double` | `84` | Compact width of the collapsed sidebar rail. |
| `borderRadius` | `double` | `20` | Border radius of the sidebar container. |
| `sideBarAnimationDuration` | `Duration` | `700ms` | Duration of the expand/collapse width animation. |
| `floatingAnimationDuration` | `Duration` | `500ms` | Duration of the floating indicator movement. |
| `curve` | `Curve` | `Curves.easeOut` | Animation curve applied to width changes and indicator movements. |
| `settingsDivider` | `bool` | `true` | Whether to display a divider before the trailing item. |
| `dividerColor` | `Color` | `Color(0xff929292)` | Color of the section divider line. |
| `hoverColor` | `Color` | `Colors.black38` | Hover color when cursor hovers over an item. |
| `splashColor` | `Color` | `Colors.black87` | Ink splash color upon tapping an item. |
| `highlightColor` | `Color` | `Colors.black` | Ink highlight color when pressing an item. |

### SideBarItem

| Property | Type | Description |
|---|---|---|
| `iconSelected` | `IconData` | The icon shown when the item is active / selected. |
| `iconUnselected` | `IconData?` | Optional icon shown when inactive (defaults to `iconSelected`). |
| `text` | `String` | Text label displayed next to the icon in expanded mode. |

## Example Project

Check the [example](example) directory for a complete working Flutter application demonstrating responsive behavior, state switching, and custom themes.

## License

MIT
