import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

void main() {
  const sampleConfig = SideBarExportConfig(
    useController: true,
    useDirectIsMinimized: false,
    directIsMinimized: false,
    initialIndex: 0,
    widthSwitch: 700,
    sideBarWidth: 260,
    sideBarSmallWidth: 84,
    itemHeight: 48,
    itemSpacing: 8,
    borderRadius: 20,
    itemBorderRadiusValue: 12,
    marginAll: 20,
    useCustomContentPadding: false,
    contentPaddingHorizontal: 20,
    contentPaddingVertical: 24,
    sideBarColor: Color(0xff1D1D1D),
    animatedContainerColor: Color(0xff323232),
    selectedIconColor: Colors.white,
    unselectedIconColor: Color(0xffA0A5A9),
    useCustomDisabledIconColor: false,
    disabledIconColor: Color(0xff555555),
    unSelectedTextColor: Color(0xffA0A5A9),
    useCustomDisabledTextColor: false,
    disabledTextColor: Color(0xff555555),
    hoverColor: Colors.black38,
    splashColor: Colors.black87,
    highlightColor: Colors.black,
    useCustomTextStyle: false,
    baseFontSize: 16,
    baseFontWeight: FontWeight.normal,
    useCustomSelectedTextStyle: false,
    selectedTextColor: Colors.white,
    selectedFontSize: 16,
    selectedFontWeight: FontWeight.w600,
    useCustomDisabledTextStyle: false,
    disabledFontSize: 16,
    disabledFontItalic: true,
    settingsDivider: true,
    dividerColor: Color(0xff929292),
    dividerHeight: 12,
    dividerThickness: 0.5,
    transitionType: SideBarTransitionType.slide,
    sideBarAnimationDurationMs: 700,
    itemTransitionDurationMs: 400,
    curveKey: 'easeOut',
    itemTransitionCurveKey: 'easeOutCubic',
    customTransitionMode: 'rotateScale',
    showHeaderWidget: true,
    showFooterWidget: false,
    showToggleButton: true,
    useCustomToggleButtonColor: false,
    toggleButtonColor: Colors.deepPurpleAccent,
    useCustomToggleWidgets: false,
    expandedToggleIconKey: 'menu_open',
    collapsedToggleIconKey: 'menu',
    scrollPhysicsKey: 'bouncing',
    sidebarItems: [
      SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
      SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
    ],
  );

  test('generates StatefulWidget files with requirements', () {
    final files = CodeExportGenerator.generateStatefulFiles(sampleConfig);
    expect(files.keys, containsAll(['lib/main.dart', 'pubspec.yaml', 'analysis_options.yaml', 'README.md']));
    expect(files['lib/main.dart'], contains('StatefulWidget'));
    expect(files['pubspec.yaml'], contains('flutter_gn_side_navigation_rail'));
  });

  test('generates BLoC files with requirements', () {
    final files = CodeExportGenerator.generateBlocFiles(sampleConfig);
    expect(
      files.keys,
      containsAll([
        'lib/main.dart',
        'lib/bloc/navigation_bloc.dart',
        'lib/bloc/navigation_event.dart',
        'lib/bloc/navigation_state.dart',
        'pubspec.yaml',
        'analysis_options.yaml',
        'README.md',
      ]),
    );
    expect(files['pubspec.yaml'], contains('flutter_bloc'));
    expect(files['pubspec.yaml'], contains('equatable'));
  });

  test('builds valid ZIP archive bytes', () {
    final files = CodeExportGenerator.generateBlocFiles(sampleConfig);
    final zipBytes = ZipExporter.buildZipArchive(files);
    expect(zipBytes.length, greaterThan(100));
    expect(zipBytes.sublist(0, 4), [0x50, 0x4B, 0x03, 0x04]);
  });

  test('exports shrinkWrap and custom height configuration for StatefulWidget and BLoC', () {
    const shrinkConfig = SideBarExportConfig(
      useController: true,
      useDirectIsMinimized: false,
      directIsMinimized: false,
      initialIndex: 0,
      widthSwitch: 700,
      sideBarWidth: 260,
      sideBarSmallWidth: 84,
      shrinkWrap: true,
      useCustomHeight: false,
      customHeight: 500,
      itemHeight: 48,
      itemSpacing: 8,
      borderRadius: 20,
      itemBorderRadiusValue: 12,
      marginAll: 20,
      useCustomContentPadding: false,
      contentPaddingHorizontal: 20,
      contentPaddingVertical: 24,
      sideBarColor: Color(0xff1D1D1D),
      animatedContainerColor: Color(0xff323232),
      selectedIconColor: Colors.white,
      unselectedIconColor: Color(0xffA0A5A9),
      useCustomDisabledIconColor: false,
      disabledIconColor: Color(0xff555555),
      unSelectedTextColor: Color(0xffA0A5A9),
      useCustomDisabledTextColor: false,
      disabledTextColor: Color(0xff555555),
      hoverColor: Colors.black38,
      splashColor: Colors.black87,
      highlightColor: Colors.black,
      useCustomTextStyle: false,
      baseFontSize: 16,
      baseFontWeight: FontWeight.normal,
      useCustomSelectedTextStyle: false,
      selectedTextColor: Colors.white,
      selectedFontSize: 16,
      selectedFontWeight: FontWeight.w600,
      useCustomDisabledTextStyle: false,
      disabledFontSize: 16,
      disabledFontItalic: true,
      settingsDivider: true,
      dividerColor: Color(0xff929292),
      dividerHeight: 12,
      dividerThickness: 0.5,
      transitionType: SideBarTransitionType.slide,
      sideBarAnimationDurationMs: 700,
      itemTransitionDurationMs: 400,
      curveKey: 'easeOut',
      itemTransitionCurveKey: 'easeOutCubic',
      customTransitionMode: 'rotateScale',
      showHeaderWidget: true,
      showFooterWidget: false,
      showToggleButton: true,
      useCustomToggleButtonColor: false,
      toggleButtonColor: Colors.deepPurpleAccent,
      useCustomToggleWidgets: false,
      expandedToggleIconKey: 'menu_open',
      collapsedToggleIconKey: 'menu',
      scrollPhysicsKey: 'bouncing',
      sidebarItems: [
        SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
        SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
      ],
    );

    final shrinkStateful = CodeExportGenerator.generateStatefulFiles(shrinkConfig)['lib/main.dart']!;
    final shrinkBloc = CodeExportGenerator.generateBlocFiles(shrinkConfig)['lib/main.dart']!;
    expect(shrinkStateful, contains('shrinkWrap: true,'));
    expect(shrinkStateful, isNot(contains('height: 500.0,')));
    expect(shrinkBloc, contains('shrinkWrap: true,'));
    expect(shrinkBloc, isNot(contains('height: 500.0,')));

    const fixedHeightConfig = SideBarExportConfig(
      useController: true,
      useDirectIsMinimized: false,
      directIsMinimized: false,
      initialIndex: 0,
      widthSwitch: 700,
      sideBarWidth: 260,
      sideBarSmallWidth: 84,
      shrinkWrap: false,
      useCustomHeight: true,
      customHeight: 450,
      itemHeight: 48,
      itemSpacing: 8,
      borderRadius: 20,
      itemBorderRadiusValue: 12,
      marginAll: 20,
      useCustomContentPadding: false,
      contentPaddingHorizontal: 20,
      contentPaddingVertical: 24,
      sideBarColor: Color(0xff1D1D1D),
      animatedContainerColor: Color(0xff323232),
      selectedIconColor: Colors.white,
      unselectedIconColor: Color(0xffA0A5A9),
      useCustomDisabledIconColor: false,
      disabledIconColor: Color(0xff555555),
      unSelectedTextColor: Color(0xffA0A5A9),
      useCustomDisabledTextColor: false,
      disabledTextColor: Color(0xff555555),
      hoverColor: Colors.black38,
      splashColor: Colors.black87,
      highlightColor: Colors.black,
      useCustomTextStyle: false,
      baseFontSize: 16,
      baseFontWeight: FontWeight.normal,
      useCustomSelectedTextStyle: false,
      selectedTextColor: Colors.white,
      selectedFontSize: 16,
      selectedFontWeight: FontWeight.w600,
      useCustomDisabledTextStyle: false,
      disabledFontSize: 16,
      disabledFontItalic: true,
      settingsDivider: true,
      dividerColor: Color(0xff929292),
      dividerHeight: 12,
      dividerThickness: 0.5,
      transitionType: SideBarTransitionType.slide,
      sideBarAnimationDurationMs: 700,
      itemTransitionDurationMs: 400,
      curveKey: 'easeOut',
      itemTransitionCurveKey: 'easeOutCubic',
      customTransitionMode: 'rotateScale',
      showHeaderWidget: true,
      showFooterWidget: false,
      showToggleButton: true,
      useCustomToggleButtonColor: false,
      toggleButtonColor: Colors.deepPurpleAccent,
      useCustomToggleWidgets: false,
      expandedToggleIconKey: 'menu_open',
      collapsedToggleIconKey: 'menu',
      scrollPhysicsKey: 'bouncing',
      sidebarItems: [
        SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
        SideBarItem(iconSelected: Icons.settings, text: 'Settings'),
      ],
    );

    final fixedStateful = CodeExportGenerator.generateStatefulFiles(fixedHeightConfig)['lib/main.dart']!;
    final fixedBloc = CodeExportGenerator.generateBlocFiles(fixedHeightConfig)['lib/main.dart']!;
    expect(fixedStateful, contains('height: 450.0,'));
    expect(fixedBloc, contains('height: 450.0,'));
  });

  test('exports SideBarItem.action and onActionTap for StatefulWidget and BLoC', () {
    const actionConfig = SideBarExportConfig(
      useController: true,
      useDirectIsMinimized: false,
      directIsMinimized: false,
      initialIndex: 0,
      widthSwitch: 700,
      sideBarWidth: 260,
      sideBarSmallWidth: 84,
      itemHeight: 48,
      itemSpacing: 8,
      borderRadius: 20,
      itemBorderRadiusValue: 12,
      marginAll: 20,
      useCustomContentPadding: false,
      contentPaddingHorizontal: 20,
      contentPaddingVertical: 24,
      sideBarColor: Color(0xff1D1D1D),
      animatedContainerColor: Color(0xff323232),
      selectedIconColor: Colors.white,
      unselectedIconColor: Color(0xffA0A5A9),
      useCustomDisabledIconColor: false,
      disabledIconColor: Color(0xff555555),
      unSelectedTextColor: Color(0xffA0A5A9),
      useCustomDisabledTextColor: false,
      disabledTextColor: Color(0xff555555),
      hoverColor: Colors.black38,
      splashColor: Colors.black87,
      highlightColor: Colors.black,
      useCustomTextStyle: false,
      baseFontSize: 16,
      baseFontWeight: FontWeight.normal,
      useCustomSelectedTextStyle: false,
      selectedTextColor: Colors.white,
      selectedFontSize: 16,
      selectedFontWeight: FontWeight.w600,
      useCustomDisabledTextStyle: false,
      disabledFontSize: 16,
      disabledFontItalic: true,
      settingsDivider: true,
      dividerColor: Color(0xff929292),
      dividerHeight: 12,
      dividerThickness: 0.5,
      transitionType: SideBarTransitionType.slide,
      sideBarAnimationDurationMs: 700,
      itemTransitionDurationMs: 400,
      curveKey: 'easeOut',
      itemTransitionCurveKey: 'easeOutCubic',
      customTransitionMode: 'rotateScale',
      showHeaderWidget: true,
      showFooterWidget: false,
      showToggleButton: true,
      useCustomToggleButtonColor: false,
      toggleButtonColor: Colors.deepPurpleAccent,
      useCustomToggleWidgets: false,
      expandedToggleIconKey: 'menu_open',
      collapsedToggleIconKey: 'menu',
      scrollPhysicsKey: 'bouncing',
      sidebarItems: [
        SideBarItem(iconSelected: Icons.dashboard, text: 'Dashboard'),
        SideBarItem.action(
          icon: Icons.sync,
          text: 'Sync',
          tooltip: 'Sync workspace data',
        ),
        SideBarItem.action(
          icon: Icons.logout,
          text: 'Logout',
          tooltip: 'Sign out',
        ),
      ],
    );

    final statefulFiles = CodeExportGenerator.generateStatefulFiles(actionConfig);
    final blocFiles = CodeExportGenerator.generateBlocFiles(actionConfig);

    expect(statefulFiles['lib/main.dart'], contains('SideBarItem.action('));
    expect(statefulFiles['lib/main.dart'], contains('Icons.sync'));
    expect(statefulFiles['lib/main.dart'], contains('Icons.logout'));
    expect(statefulFiles['lib/main.dart'], contains('onActionTap:'));
    expect(statefulFiles['pubspec.yaml'], contains('^2.3.0'));

    expect(blocFiles['lib/main.dart'], contains('SideBarItem.action('));
    expect(blocFiles['lib/main.dart'], contains('onActionTap:'));
    expect(blocFiles['pubspec.yaml'], contains('^2.3.0'));
  });
}
