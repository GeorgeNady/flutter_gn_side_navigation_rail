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
}
