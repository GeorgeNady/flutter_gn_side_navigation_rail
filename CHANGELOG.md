## 2.1.0

* **Customizable Item Selection Transitions**:
  * Added `SideBarTransitionType` enum (`slide`, `fade`, `scale`, `fadeSlide`, `none`, `custom`) to choose how the selection indicator transitions when switching items.
  * Added `transitionType`, `itemTransitionDuration`, and `itemTransitionCurve` properties to `SideBarAnimated`.
  * Added `SideBarTransitionBuilder` (`itemTransitionBuilder`) for creating completely custom transition animations.
  * Enhanced `SideBarController.selectIndex()` with optional transition overrides (`transitionType`, `duration`, `curve`) for per-call animation control.
  * Added smooth crossfade transitions for the indicator content using `AnimatedSwitcher`.

## 2.0.0

* **Native Project Typography**: Item labels now inherit the host project's theme and native `fontFamily` by default instead of forcing a hardcoded font.
* **Disabled Item State**: Added `isDisabled` (and optional `tooltip`) to `SideBarItem`. Disabled items cannot be tapped or selected, and support `disabledIconColor`, `disabledTextColor`, and `disabledTextStyle`.
* **Custom Header Widget**: Changed `mainLogoImage` to `headerWidget`, allowing any custom `Widget` (images, icons, rows, avatars, branding) to be passed as the header.
* **External Minimize Control**:
  * Added `SideBarController` to programmatically control and observe `selectedIndex` and `isMinimized`.
  * Added `isMinimized` property and `onMinimizeChanged` callback for direct state control from outside the library.
* **Custom Toggle Icons**:
  * Added `expandedToggleIcon` and `collapsedToggleIcon` to customize the collapse button icon in both states.
  * Added `expandedToggleWidget` and `collapsedToggleWidget` for full custom widget overrides of the toggle action.
* **SOLID & Clean Architecture**:
  * Refactored into a clean modular structure: `src/models/`, `src/controllers/`, and `src/widgets/`.
  * Encapsulated internal implementation widgets (`SideBarItemTile`, `FloatingIndicator`, `CollapseToggleButton`) so only public APIs are exported.
* **Dynamic & Flexible Layout**:
  * Replaced fixed height constraints and magic alignment numbers with dynamic position calculations.
  * Added customizable `itemHeight`, `itemSpacing`, `footerWidget`, `contentPadding`, and `itemBorderRadius`.

## 1.0.0

* Initial release of `flutter_gn_side_navigation_rail`.
* **SideBarAnimated**: A sleek, responsive, and animated side navigation rail / sidebar widget for Flutter.
* **Smooth Responsive Transitions**: Automatic collapse and expand based on configurable screen width breakpoint (`widthSwitch`), plus manual minimize toggle button.
* **Animated Floating Indicator**: Smoothly animates the indicator to the selected item with custom duration and curve.
* **Rich Customization**:
  * Full color control: sidebar background, floating indicator, selected/unselected icons, text, hover, splash, and highlight colors.
  * Configurable dimensions: expanded width (`sideBarWidth`), collapsed width (`sideBarSmallWidth`), and border radius (`borderRadius`).
  * Built-in support for section divider before bottom/settings items (`settingsDivider`, `dividerColor`).
* **SideBarItem**: Model supporting selected icon, optional unselected icon, and label text.
