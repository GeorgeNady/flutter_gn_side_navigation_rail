import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

void main() {
  test('SideBarItem creates instance with expected properties and disabled state', () {
    const item = SideBarItem(
      iconSelected: Icons.home,
      iconUnselected: Icons.home_outlined,
      text: 'Home',
      isDisabled: true,
      tooltip: 'Home is disabled',
    );

    expect(item.iconSelected, Icons.home);
    expect(item.iconUnselected, Icons.home_outlined);
    expect(item.text, 'Home');
    expect(item.isDisabled, isTrue);
    expect(item.tooltip, 'Home is disabled');
  });

  test('SideBarController updates index and minimize states', () {
    final controller = SideBarController(initialIndex: 0, initialMinimized: false);
    expect(controller.selectedIndex, 0);
    expect(controller.isMinimized, isFalse);

    var notifyCount = 0;
    controller.addListener(() => notifyCount++);

    controller.selectIndex(2);
    expect(controller.selectedIndex, 2);
    expect(notifyCount, 1);

    controller.toggleMinimize();
    expect(controller.isMinimized, isTrue);
    expect(notifyCount, 2);

    controller.expand();
    expect(controller.isMinimized, isFalse);
    expect(notifyCount, 3);
  });

  test('SideBarController supports transition animation overrides', () {
    final controller = SideBarController(initialIndex: 0);

    controller.selectIndex(
      1,
      transitionType: SideBarTransitionType.fade,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    expect(controller.selectedIndex, 1);
    expect(controller.lastTransitionType, SideBarTransitionType.fade);
    expect(controller.lastTransitionDuration, const Duration(milliseconds: 300));
    expect(controller.lastTransitionCurve, Curves.easeInOut);
  });

  testWidgets('SideBarAnimated renders with custom header and handles disabled items', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = SideBarController(initialIndex: 0);
    int tappedIndex = -1;

    final items = [
      const SideBarItem(
        iconSelected: Icons.dashboard,
        text: 'Dashboard',
      ),
      const SideBarItem(
        iconSelected: Icons.lock,
        text: 'Disabled Item',
        isDisabled: true,
      ),
      const SideBarItem(
        iconSelected: Icons.settings,
        text: 'Settings',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SideBarAnimated(
            controller: controller,
            headerWidget: const Text('CustomHeader'),
            sidebarItems: items,
            expandedToggleIcon: Icons.menu_open,
            collapsedToggleIcon: Icons.menu,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify custom header is rendered
    expect(find.text('CustomHeader'), findsOneWidget);

    // Verify items are displayed
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Disabled Item'), findsOneWidget);

    // Tapping disabled item should NOT change selectedIndex or fire onTap
    await tester.tap(find.text('Disabled Item'));
    await tester.pumpAndSettle();

    expect(tappedIndex, -1);
    expect(controller.selectedIndex, 0);

    // Tapping enabled item (Settings) should select it
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 2);
    expect(controller.selectedIndex, 2);

    // Toggle minimize
    expect(find.byIcon(Icons.menu_open), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu_open));
    await tester.pumpAndSettle();

    expect(controller.isMinimized, isTrue);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('SideBarAnimated supports different transition animation types and custom builders', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var customBuilderCalled = false;
    final controller = SideBarController(initialIndex: 0);

    final items = [
      const SideBarItem(iconSelected: Icons.home, text: 'Home'),
      const SideBarItem(iconSelected: Icons.search, text: 'Search'),
      const SideBarItem(iconSelected: Icons.person, text: 'Profile'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SideBarAnimated(
            controller: controller,
            sidebarItems: items,
            transitionType: SideBarTransitionType.custom,
            itemTransitionDuration: const Duration(milliseconds: 300),
            itemTransitionBuilder: (context, animation, child) {
              customBuilderCalled = true;
              return ScaleTransition(scale: animation, child: child);
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Custom builder called on build
    expect(customBuilderCalled, isTrue);

    // Switch item using fade override via controller
    controller.selectIndex(1, transitionType: SideBarTransitionType.fade);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    expect(controller.selectedIndex, 1);
  });
}
