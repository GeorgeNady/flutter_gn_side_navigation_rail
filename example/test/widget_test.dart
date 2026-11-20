import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

void main() {
  testWidgets('SideBarAnimated renders, responds to taps, and shows export panel',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify SideBarAnimated widget is present
    expect(find.byType(SideBarAnimated), findsOneWidget);

    // Verify Export panel is rendered on the left with StatefulWidget & BLoC options
    expect(find.text('Export Dart Code & ZIP'), findsOneWidget);
    expect(find.text('StatefulWidget'), findsOneWidget);
    expect(find.text('BLoC Pattern'), findsOneWidget);

    // Switch to BLoC Pattern and verify BLoC requirement files appear
    await tester.tap(find.text('BLoC Pattern'));
    await tester.pumpAndSettle();
    expect(find.text('lib/bloc/navigation_bloc.dart'), findsOneWidget);
    expect(find.text('lib/bloc/navigation_event.dart'), findsOneWidget);
    expect(find.text('lib/bloc/navigation_state.dart'), findsOneWidget);
    expect(find.text('pubspec.yaml'), findsOneWidget);

    // Tap on Analytics in the sidebar
    await tester.tap(find.text('Analytics').first);
    await tester.pumpAndSettle();

    // Verify the view updated to Analytics
    expect(find.text('Welcome to Analytics'), findsOneWidget);
  });

  test('ZipExporter builds a valid ZIP binary archive with all requirement files', () {
    final files = {
      'lib/main.dart': 'void main() {}',
      'pubspec.yaml': 'name: test_app',
    };
    final bytes = ZipExporter.buildZipArchive(files);
    // ZIP Local file header magic signature: PK\x03\x04
    expect(bytes.length, greaterThan(40));
    expect(bytes[0], 0x50); // 'P'
    expect(bytes[1], 0x4B); // 'K'
    expect(bytes[2], 0x03);
    expect(bytes[3], 0x04);
    expect(ExportArchitecture.values.length, 2);
  });

  testWidgets('Playground controls shrinkWrap, fixed height, live preview code, and animates without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(SideBarAnimated)).height, 900.0);

    // Toggle Wrap Content from header bar and verify live preview + code export update
    await tester.tap(find.widgetWithText(OutlinedButton, 'Wrap Content'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final wrappedWithHeaderHeight = tester.getSize(find.byType(SideBarAnimated)).height;
    expect(wrappedWithHeaderHeight, lessThan(900.0));
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data ?? '').contains('shrinkWrap: true,'),
      ),
      findsOneWidget,
    );

    // Toggle Header and Toggle Button off and verify wrap content shrinks further cleanly
    final section7 = find.text('7. Header, Footer, Toggle Button & Scroll Physics');
    await tester.ensureVisible(section7);
    await tester.pumpAndSettle();
    await tester.tap(section7);
    await tester.pumpAndSettle();

    final headerSwitch = find.text('Show Header Widget (headerWidget)');
    await tester.ensureVisible(headerSwitch);
    await tester.pumpAndSettle();
    await tester.tap(headerSwitch);
    await tester.pumpAndSettle();

    final toggleSwitch = find.text('Show Collapse Toggle Button (showToggleButton)');
    await tester.ensureVisible(toggleSwitch);
    await tester.pumpAndSettle();
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, lessThan(wrappedWithHeaderHeight));

    // Re-enable Header and Toggle Button for the remaining checks
    await tester.tap(headerSwitch);
    await tester.pumpAndSettle();
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();

    // Switch to Fixed Height in Section 1 and verify height (500 + 40 margin) + code output
    final fixedChip = find.widgetWithText(ChoiceChip, 'Fixed Height');
    await tester.ensureVisible(fixedChip);
    await tester.pumpAndSettle();
    await tester.tap(fixedChip);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).height, 540.0);
    expect(
      find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data ?? '').contains('height: 500.0,'),
      ),
      findsOneWidget,
    );

    // Collapse and re-expand rail step-by-step verifying zero overflow on every frame
    final collapseButton = find.text('Collapse Rail');
    await tester.ensureVisible(collapseButton);
    await tester.pumpAndSettle();
    await tester.tap(collapseButton);
    for (var elapsed = 0; elapsed <= 800; elapsed += 50) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).width, 124.0);

    final expandButton = find.text('Expand Rail');
    await tester.ensureVisible(expandButton);
    await tester.pumpAndSettle();
    await tester.tap(expandButton);
    for (var elapsed = 0; elapsed <= 800; elapsed += 50) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(SideBarAnimated)).width, 300.0);
  });
}
