import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

void main() {
  testWidgets(
      'SideBarAnimated renders, navigates preview stage, and switches Code exporter',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(SideBarAnimated), findsOneWidget);
    expect(find.text('Customize'), findsOneWidget);
    expect(find.text('Code'), findsOneWidget);

    // Tap Analytics in the rail and verify realistic preview updates
    await tester.tap(find.text('Analytics').first);
    await tester.pumpAndSettle();
    expect(find.text('Traffic and conversion metrics'), findsOneWidget);
    expect(find.text('Navigation Entry Sources'), findsOneWidget);

    // Switch Inspector to Code mode and verify StatefulWidget & BLoC outputs
    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(find.text('StatefulWidget'), findsOneWidget);
    expect(find.text('BLoC'), findsOneWidget);
    expect(find.text('lib/main.dart'), findsWidgets);

    await tester.tap(find.text('BLoC'));
    await tester.pumpAndSettle();
    expect(find.text('lib/bloc/navigation_bloc.dart'), findsWidgets);
    expect(find.text('lib/bloc/navigation_event.dart'), findsOneWidget);
    expect(find.text('lib/bloc/navigation_state.dart'), findsOneWidget);
    expect(find.text('pubspec.yaml'), findsOneWidget);

    // Mock platform clipboard channel to verify copied payload in test
    String? copiedText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedText = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    // Copy active file and verify inline confirmation & clipboard payload
    await tester.tap(find.text('Copy'));
    await tester.pump();
    expect(find.text('Copied'), findsOneWidget);
    expect(copiedText, isNotNull);
    expect(copiedText, contains('SideBarAnimated'));

    // Wait out the 2-second copy timer cleanly before tearDown
    await tester.pump(const Duration(seconds: 3));
  });

  test('ZipExporter builds a valid ZIP binary archive with all requirement files',
      () {
    final files = {
      'lib/main.dart': 'void main() {}',
      'pubspec.yaml': 'name: test_app',
    };
    final bytes = ZipExporter.buildZipArchive(files);
    expect(bytes.length, greaterThan(40));
    expect(bytes[0], 0x50); // 'P'
    expect(bytes[1], 0x4B); // 'K'
    expect(bytes[2], 0x03);
    expect(bytes[3], 0x04);
    expect(ExportArchitecture.values.length, 2);
  });

  testWidgets(
      'Studio controls shrinkWrap, fixed height, live preview code, and animate without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(SideBarAnimated)).height, 900.0);

    // Switch to Layout tab and select Wrap height mode
    await tester.tap(find.text('Layout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wrap'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final wrappedWithHeaderHeight =
        tester.getSize(find.byType(SideBarAnimated)).height;
    expect(wrappedWithHeaderHeight, lessThan(900.0));

    // Confirm generated code reflects shrinkWrap: true
    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is SelectableText && (w.data ?? '').contains('shrinkWrap: true,'),
      ),
      findsOneWidget,
    );

    // Return to Style tab and toggle Show Header, Show Footer, & Collapse Toggle
    await tester.tap(find.text('Customize'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Style'));
    await tester.pumpAndSettle();

    // Header is visible initially; Footer is hidden initially
    expect(find.text('MyApp'), findsOneWidget);
    expect(find.text('George N.'), findsNothing);

    // Toggle Show Footer on and verify live footer slot appears
    final footerSwitch = find.text('Show Footer');
    await tester.tap(footerSwitch);
    await tester.pumpAndSettle();
    expect(find.text('George N.'), findsOneWidget);

    // Toggle Show Footer back off
    await tester.tap(footerSwitch);
    await tester.pumpAndSettle();
    expect(find.text('George N.'), findsNothing);

    final headerSwitch = find.text('Show Header');
    await tester.tap(headerSwitch);
    await tester.pumpAndSettle();
    expect(find.text('MyApp'), findsNothing);

    final toggleSwitch = find.text('Collapse Toggle');
    await tester.ensureVisible(toggleSwitch);
    await tester.pumpAndSettle();
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(SideBarAnimated)).height,
      lessThan(wrappedWithHeaderHeight),
    );

    // Re-enable Header & Collapse Toggle
    await tester.ensureVisible(headerSwitch);
    await tester.pumpAndSettle();
    await tester.tap(headerSwitch);
    await tester.pumpAndSettle();
    expect(find.text('MyApp'), findsOneWidget);
    await tester.ensureVisible(toggleSwitch);
    await tester.pumpAndSettle();
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();

    // Switch to Fixed height mode in Layout tab (500 + 40 margin = 540)
    await tester.tap(find.text('Layout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fixed'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, 540.0);

    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data ?? '').contains('height: 500.0,'),
      ),
      findsOneWidget,
    );

    // Collapse and re-expand rail frame-by-frame verifying zero overflow
    await tester.tap(find.byTooltip('Collapse Rail'));
    for (var elapsed = 0; elapsed <= 800; elapsed += 50) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).width, 124.0);

    await tester.tap(find.byTooltip('Expand Rail'));
    for (var elapsed = 0; elapsed <= 800; elapsed += 50) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).width, 300.0);
  });

  testWidgets('Presets, Light/Dark studio theme toggle, and Advanced disclosure work cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Apply Snow light rail preset
    await tester.tap(find.text('Snow'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final snowRail =
        tester.widget<SideBarAnimated>(find.byType(SideBarAnimated));
    expect(snowRail.sideBarColor, const Color(0xFFFFFFFF));

    // Apply Compact shrinkWrap preset
    await tester.tap(find.text('Compact'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final compactRail =
        tester.widget<SideBarAnimated>(find.byType(SideBarAnimated));
    expect(compactRail.shrinkWrap, isTrue);

    // Toggle studio theme to Light and verify icon/tooltip switch
    await tester.tap(find.byTooltip('Switch to light theme'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Switch to dark theme'), findsOneWidget);

    // Expand Advanced disclosure and toggle Custom Base TextStyle
    final advancedTile = find.text('Advanced');
    await tester.ensureVisible(advancedTile);
    await tester.pumpAndSettle();
    await tester.tap(advancedTile);
    await tester.pumpAndSettle();

    expect(find.text('Controller & Overrides'), findsOneWidget);
    final baseStyleSwitch = find.text('Custom Base TextStyle');
    await tester.ensureVisible(baseStyleSwitch);
    await tester.pumpAndSettle();
    await tester.tap(baseStyleSwitch);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data ?? '').contains('textStyle:'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Responsive mobile (375x812) and tablet (768x1024) layouts render without overflow',
      (WidgetTester tester) async {
    // Mobile 375x812
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Open mobile endDrawer Inspector and switch to Code tab
    await tester.tap(find.byTooltip('Open Inspector'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Customize'), findsOneWidget);

    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Export .ZIP'), findsOneWidget);

    // Close drawer before resizing to tablet
    await tester.tap(find.byTooltip('Close inspector'));
    await tester.pumpAndSettle();

    // Tablet 768x1024
    tester.view.physicalSize = const Size(768, 1024);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Accessibility: 2.0x text scaling and reduced motion render without overflow',
      (WidgetTester tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    // Desktop 1440x900 at 2.0x text scale
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Switch through all preview destinations & inspector tabs
    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Items'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Mobile 375x812 at 2.0x text scale
    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
