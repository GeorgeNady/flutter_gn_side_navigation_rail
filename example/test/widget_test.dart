import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

void main() {
  testWidgets('SideBarAnimated renders and responds to taps', (WidgetTester tester) async {
    // Provide a large enough display size for tests
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify SideBarAnimated widget is present
    expect(find.byType(SideBarAnimated), findsOneWidget);

    // Verify Dashboard is initially selected and visible
    expect(find.text('Dashboard'), findsWidgets);

    // Tap on Analytics
    await tester.tap(find.text('Analytics').first);
    await tester.pumpAndSettle();

    // Verify the view updated to Analytics
    expect(find.text('Welcome to Analytics'), findsOneWidget);
  });
}
