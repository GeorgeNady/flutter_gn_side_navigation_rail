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

  testWidgets('Expanding sidebar does not overflow mid-animation and delays title until wide enough', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = SideBarController(initialIndex: 0, initialMinimized: true);
    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                controller: controller,
                sidebarItems: items,
                sideBarAnimationDuration: const Duration(milliseconds: 500),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsNothing);

    controller.expand();
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 25));
    expect(tester.takeException(), isNull);
    expect(find.text('Dashboard'), findsNothing);

    for (var elapsed = 50; elapsed <= 600; elapsed += 25) {
      await tester.pump(const Duration(milliseconds: 25));
      expect(tester.takeException(), isNull);
    }

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('Collapsing sidebar renders only a single icon for the selected item', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = SideBarController(initialIndex: 0, initialMinimized: false);
    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                controller: controller,
                sidebarItems: items,
                sideBarAnimationDuration: const Duration(milliseconds: 500),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dashboard), findsOneWidget);

    controller.collapse();
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.dashboard), findsOneWidget);

    for (var elapsed = 25; elapsed <= 600; elapsed += 25) {
      await tester.pump(const Duration(milliseconds: 25));
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    }

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
  });

  testWidgets('Height control: default fills screen height', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(sidebarItems: items),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(SideBarAnimated));
    expect(size.height, 900.0);
  });

  testWidgets('Height control: shrinkWrap true shrinks to content in Scaffold/Row', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                sidebarItems: items,
                shrinkWrap: true,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(SideBarAnimated));
    expect(size.height, lessThan(900.0));
    expect(size.height, greaterThan(0.0));
  });

  testWidgets('Height control: shrinkWrap true with many items caps at viewport height and scrolls', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = List.generate(
      30,
      (i) => SideBarItem(iconSelected: Icons.circle, text: 'Item $i'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                sidebarItems: items,
                shrinkWrap: true,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(SideBarAnimated));
    expect(size.height, lessThanOrEqualTo(900.0));

    final scrollable = find.byType(SingleChildScrollView);
    expect(scrollable, findsOneWidget);
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Height control: shrinkWrap true inside unbounded SingleChildScrollView + Column', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SideBarAnimated(
                  sidebarItems: items,
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(SideBarAnimated));
    expect(size.height, lessThan(900.0));
    expect(size.height, greaterThan(0.0));
  });

  testWidgets('Height control: explicit height overrides shrinkWrap', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                sidebarItems: items,
                margin: EdgeInsets.zero,
                height: 420,
                shrinkWrap: true,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(SideBarAnimated));
    expect(size.height, 420.0);
  });

  testWidgets('Height control: runtime toggling of shrinkWrap and height completes with zero exceptions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    Widget buildApp({required bool shrinkWrap, double? height}) {
      return MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                sidebarItems: items,
                margin: EdgeInsets.zero,
                shrinkWrap: shrinkWrap,
                height: height,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }

    await tester.pumpWidget(buildApp(shrinkWrap: false, height: null));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(SideBarAnimated)).height, 900.0);

    await tester.pumpWidget(buildApp(shrinkWrap: true, height: null));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, lessThan(900.0));

    await tester.pumpWidget(buildApp(shrinkWrap: false, height: 420));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, 420.0);

    await tester.pumpWidget(buildApp(shrinkWrap: false, height: null));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, 900.0);
  });

  testWidgets('Height control: tight parent with shrinkWrap true wraps content without stretching', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    // Case 1: Row with CrossAxisAlignment.stretch
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SideBarAnimated(
                sidebarItems: items,
                shrinkWrap: true,
                showToggleButton: false,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final stretchedContainerHeight = tester.getSize(find.byType(AnimatedContainer)).height;
    // margin (20*2) + defaultPadding (40+24) + 2 items (48*2) + divider (12) = 212.0
    expect(stretchedContainerHeight, 212.0);
    expect(find.byType(ListView), findsNothing);

    // Case 2: Tight SizedBox(height: 900)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 900,
            child: SideBarAnimated(
              sidebarItems: items,
              shrinkWrap: true,
              showToggleButton: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 212.0);
  });

  testWidgets('Height control: tight parent with explicit height honors fixed height', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 900,
            child: SideBarAnimated(
              sidebarItems: items,
              margin: EdgeInsets.zero,
              height: 420,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 420.0);
  });

  testWidgets('Height control: match parent fills bounded parent heights (600px and 1200px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const items = [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: SideBarAnimated(
              sidebarItems: items,
              shrinkWrap: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 600.0);

    await tester.pumpWidget(
      MaterialApp(
        home: SingleChildScrollView(
          child: SizedBox(
            height: 1200,
            child: SideBarAnimated(
              sidebarItems: items,
              shrinkWrap: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 1200.0);
  });
}
