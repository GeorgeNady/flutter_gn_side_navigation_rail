import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

enum ExportArchitecture {
  stateful,
  bloc,
}

/// Snapshot of all current sidebar settings to generate runnable Dart code & project files.
class SideBarExportConfig {
  final bool useController;
  final bool useDirectIsMinimized;
  final bool directIsMinimized;
  final int initialIndex;
  final double widthSwitch;
  final double sideBarWidth;
  final double sideBarSmallWidth;
  final double itemHeight;
  final double itemSpacing;
  final double borderRadius;
  final double itemBorderRadiusValue;
  final double marginAll;
  final bool useCustomContentPadding;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final Color sideBarColor;
  final Color animatedContainerColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final bool useCustomDisabledIconColor;
  final Color disabledIconColor;
  final Color unSelectedTextColor;
  final bool useCustomDisabledTextColor;
  final Color disabledTextColor;
  final Color hoverColor;
  final Color splashColor;
  final Color highlightColor;
  final bool useCustomTextStyle;
  final double baseFontSize;
  final FontWeight baseFontWeight;
  final bool useCustomSelectedTextStyle;
  final Color selectedTextColor;
  final double selectedFontSize;
  final FontWeight selectedFontWeight;
  final bool useCustomDisabledTextStyle;
  final double disabledFontSize;
  final bool disabledFontItalic;
  final bool settingsDivider;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerThickness;
  final SideBarTransitionType transitionType;
  final int sideBarAnimationDurationMs;
  final int itemTransitionDurationMs;
  final String curveKey;
  final String itemTransitionCurveKey;
  final String customTransitionMode;
  final bool showHeaderWidget;
  final bool showFooterWidget;
  final bool showToggleButton;
  final bool useCustomToggleButtonColor;
  final Color toggleButtonColor;
  final bool useCustomToggleWidgets;
  final String expandedToggleIconKey;
  final String collapsedToggleIconKey;
  final String scrollPhysicsKey;
  final List<SideBarItem> sidebarItems;

  const SideBarExportConfig({
    required this.useController,
    required this.useDirectIsMinimized,
    required this.directIsMinimized,
    required this.initialIndex,
    required this.widthSwitch,
    required this.sideBarWidth,
    required this.sideBarSmallWidth,
    required this.itemHeight,
    required this.itemSpacing,
    required this.borderRadius,
    required this.itemBorderRadiusValue,
    required this.marginAll,
    required this.useCustomContentPadding,
    required this.contentPaddingHorizontal,
    required this.contentPaddingVertical,
    required this.sideBarColor,
    required this.animatedContainerColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.useCustomDisabledIconColor,
    required this.disabledIconColor,
    required this.unSelectedTextColor,
    required this.useCustomDisabledTextColor,
    required this.disabledTextColor,
    required this.hoverColor,
    required this.splashColor,
    required this.highlightColor,
    required this.useCustomTextStyle,
    required this.baseFontSize,
    required this.baseFontWeight,
    required this.useCustomSelectedTextStyle,
    required this.selectedTextColor,
    required this.selectedFontSize,
    required this.selectedFontWeight,
    required this.useCustomDisabledTextStyle,
    required this.disabledFontSize,
    required this.disabledFontItalic,
    required this.settingsDivider,
    required this.dividerColor,
    required this.dividerHeight,
    required this.dividerThickness,
    required this.transitionType,
    required this.sideBarAnimationDurationMs,
    required this.itemTransitionDurationMs,
    required this.curveKey,
    required this.itemTransitionCurveKey,
    required this.customTransitionMode,
    required this.showHeaderWidget,
    required this.showFooterWidget,
    required this.showToggleButton,
    required this.useCustomToggleButtonColor,
    required this.toggleButtonColor,
    required this.useCustomToggleWidgets,
    required this.expandedToggleIconKey,
    required this.collapsedToggleIconKey,
    required this.scrollPhysicsKey,
    required this.sidebarItems,
  });
}

class CodeExportGenerator {
  static String _colorToCode(Color c) {
    final hex = c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return 'const Color(0x$hex)';
  }

  static String _fontWeightToCode(FontWeight fw) {
    if (fw == FontWeight.w300) return 'FontWeight.w300';
    if (fw == FontWeight.normal) return 'FontWeight.normal';
    if (fw == FontWeight.w500) return 'FontWeight.w500';
    if (fw == FontWeight.w600) return 'FontWeight.w600';
    if (fw == FontWeight.bold) return 'FontWeight.bold';
    return 'FontWeight.w400';
  }

  static String _toggleIconToCode(String key) {
    switch (key) {
      case 'menu_open':
        return 'Icons.menu_open';
      case 'menu':
        return 'Icons.menu';
      case 'space_dashboard':
        return 'Icons.space_dashboard_outlined';
      case 'arrow_right':
        return 'CupertinoIcons.arrow_right';
      case 'chevron_left':
        return 'Icons.chevron_left';
      case 'chevron_right':
        return 'Icons.chevron_right';
      case 'unfold_less':
        return 'Icons.unfold_less';
      case 'unfold_more':
        return 'Icons.unfold_more';
      default:
        return 'Icons.menu_open';
    }
  }

  static String _iconDataToCode(IconData icon) {
    final codePoint = icon.codePoint;
    const knownIcons = <int, String>{
      0xe1b1: 'Icons.dashboard',
      0xef5a: 'Icons.dashboard_outlined',
      0xe06e: 'Icons.analytics',
      0xee85: 'Icons.analytics_outlined',
      0xe44f: 'Icons.notifications',
      0xe451: 'Icons.notifications_none',
      0xe153: 'Icons.chat_bubble',
      0xe154: 'Icons.chat_bubble_outline',
      0xe3ae: 'Icons.lock',
      0xe3b0: 'Icons.lock_outline',
      0xe57f: 'Icons.settings',
      0xef6e: 'Icons.settings_outlined',
      0xe2a3: 'Icons.folder',
      0xef9c: 'Icons.folder_outlined',
    };
    if (knownIcons.containsKey(codePoint)) {
      return knownIcons[codePoint]!;
    }
    return "IconData(0x${codePoint.toRadixString(16)}, fontFamily: '${icon.fontFamily ?? 'MaterialIcons'}')";
  }

  static String _physicsToCode(String key) {
    switch (key) {
      case 'clamping':
        return 'const ClampingScrollPhysics()';
      case 'never':
        return 'const NeverScrollableScrollPhysics()';
      case 'bouncing':
      default:
        return 'const BouncingScrollPhysics()';
    }
  }

  static String _buildItemsListLiteral(List<SideBarItem> items, String indent) {
    final buf = StringBuffer('[\n');
    for (final item in items) {
      buf.writeln('$indent  const SideBarItem(');
      buf.writeln('$indent    iconSelected: ${_iconDataToCode(item.iconSelected)},');
      if (item.iconUnselected != null) {
        buf.writeln(
            '$indent    iconUnselected: ${_iconDataToCode(item.iconUnselected!)},');
      }
      buf.writeln("$indent    text: '${item.text.replaceAll("'", "\\'")}',");
      if (item.isDisabled) {
        buf.writeln('$indent    isDisabled: true,');
      }
      if (item.tooltip != null && item.tooltip!.isNotEmpty) {
        buf.writeln(
            "$indent    tooltip: '${item.tooltip!.replaceAll("'", "\\'")}',");
      }
      buf.writeln('$indent  ),');
    }
    buf.write('$indent]');
    return buf.toString();
  }

  static String _buildSideBarWidgetArgs(
    SideBarExportConfig cfg, {
    required String indent,
    required String controllerExpr,
    required String isMinimizedCheckExpr,
    required String onTapExpr,
    required String onMinimizeChangedExpr,
  }) {
    final b = StringBuffer();
    if (cfg.useController) {
      b.writeln('${indent}controller: $controllerExpr,');
    }
    if (cfg.useDirectIsMinimized) {
      b.writeln('${indent}isMinimized: $isMinimizedCheckExpr,');
    }
    b.writeln('${indent}initialIndex: ${cfg.initialIndex},');
    b.writeln('${indent}onTap: $onTapExpr,');
    b.writeln('${indent}onMinimizeChanged: $onMinimizeChangedExpr,');
    b.writeln('${indent}sidebarItems: _sidebarItems,');
    b.writeln('${indent}widthSwitch: ${cfg.widthSwitch.toStringAsFixed(1)},');
    b.writeln('${indent}sideBarWidth: ${cfg.sideBarWidth.toStringAsFixed(1)},');
    b.writeln(
        '${indent}sideBarSmallWidth: ${cfg.sideBarSmallWidth.toStringAsFixed(1)},');
    b.writeln('${indent}itemHeight: ${cfg.itemHeight.toStringAsFixed(1)},');
    b.writeln('${indent}itemSpacing: ${cfg.itemSpacing.toStringAsFixed(1)},');
    b.writeln('${indent}borderRadius: ${cfg.borderRadius.toStringAsFixed(1)},');
    b.writeln(
        '${indent}itemBorderRadius: BorderRadius.circular(${cfg.itemBorderRadiusValue.toStringAsFixed(1)}),');
    b.writeln(
        '${indent}margin: const EdgeInsets.all(${cfg.marginAll.toStringAsFixed(1)}),');
    if (cfg.useCustomContentPadding) {
      b.writeln(
          '${indent}contentPadding: const EdgeInsets.symmetric(horizontal: ${cfg.contentPaddingHorizontal.toStringAsFixed(1)}, vertical: ${cfg.contentPaddingVertical.toStringAsFixed(1)}),');
    }
    b.writeln('${indent}sideBarColor: ${_colorToCode(cfg.sideBarColor)},');
    b.writeln(
        '${indent}animatedContainerColor: ${_colorToCode(cfg.animatedContainerColor)},');
    b.writeln(
        '${indent}selectedIconColor: ${_colorToCode(cfg.selectedIconColor)},');
    b.writeln(
        '${indent}unselectedIconColor: ${_colorToCode(cfg.unselectedIconColor)},');
    if (cfg.useCustomDisabledIconColor) {
      b.writeln(
          '${indent}disabledIconColor: ${_colorToCode(cfg.disabledIconColor)},');
    }
    b.writeln(
        '${indent}unSelectedTextColor: ${_colorToCode(cfg.unSelectedTextColor)},');
    if (cfg.useCustomDisabledTextColor) {
      b.writeln(
          '${indent}disabledTextColor: ${_colorToCode(cfg.disabledTextColor)},');
    }
    if (cfg.useCustomTextStyle) {
      b.writeln(
          '${indent}textStyle: const TextStyle(fontSize: ${cfg.baseFontSize.toStringAsFixed(1)}, fontWeight: ${_fontWeightToCode(cfg.baseFontWeight)}),');
    }
    if (cfg.useCustomSelectedTextStyle) {
      b.writeln(
          '${indent}selectedTextStyle: TextStyle(color: ${_colorToCode(cfg.selectedTextColor)}, fontSize: ${cfg.selectedFontSize.toStringAsFixed(1)}, fontWeight: ${_fontWeightToCode(cfg.selectedFontWeight)}),');
    }
    if (cfg.useCustomDisabledTextStyle) {
      b.writeln(
          '${indent}disabledTextStyle: const TextStyle(fontSize: ${cfg.disabledFontSize.toStringAsFixed(1)}, fontStyle: ${cfg.disabledFontItalic ? 'FontStyle.italic' : 'FontStyle.normal'}),');
    }
    b.writeln('${indent}settingsDivider: ${cfg.settingsDivider},');
    b.writeln('${indent}dividerColor: ${_colorToCode(cfg.dividerColor)},');
    b.writeln(
        '${indent}dividerHeight: ${cfg.dividerHeight.toStringAsFixed(1)},');
    b.writeln(
        '${indent}dividerThickness: ${cfg.dividerThickness.toStringAsFixed(1)},');
    b.writeln('${indent}hoverColor: ${_colorToCode(cfg.hoverColor)},');
    b.writeln('${indent}splashColor: ${_colorToCode(cfg.splashColor)},');
    b.writeln('${indent}highlightColor: ${_colorToCode(cfg.highlightColor)},');
    b.writeln('${indent}curve: Curves.${cfg.curveKey},');
    b.writeln(
        '${indent}sideBarAnimationDuration: const Duration(milliseconds: ${cfg.sideBarAnimationDurationMs}),');
    b.writeln(
        '${indent}transitionType: SideBarTransitionType.${cfg.transitionType.name},');
    b.writeln(
        '${indent}itemTransitionDuration: const Duration(milliseconds: ${cfg.itemTransitionDurationMs}),');
    b.writeln(
        '${indent}itemTransitionCurve: Curves.${cfg.itemTransitionCurveKey},');
    if (cfg.transitionType == SideBarTransitionType.custom) {
      b.writeln('${indent}itemTransitionBuilder: _buildCustomTransition,');
    }
    if (cfg.showHeaderWidget) {
      b.writeln('''${indent}headerWidget: Row(
$indent  children: [
$indent    const Icon(Icons.rocket_launch, size: 36, color: Colors.white),
$indent    if (!$isMinimizedCheckExpr) ...[
$indent      const SizedBox(width: 12),
$indent      const Expanded(
$indent        child: Text(
$indent          'MyApp',
$indent          overflow: TextOverflow.ellipsis,
$indent          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
$indent        ),
$indent      ),
$indent    ],
$indent  ],
$indent),''');
    }
    if (cfg.showFooterWidget) {
      b.writeln('''${indent}footerWidget: Container(
$indent  padding: const EdgeInsets.all(10),
$indent  decoration: BoxDecoration(
$indent    color: Colors.white.withValues(alpha: 0.06),
$indent    borderRadius: BorderRadius.circular(12),
$indent  ),
$indent  child: Row(
$indent    mainAxisSize: MainAxisSize.min,
$indent    children: [
$indent      const CircleAvatar(
$indent        radius: 14,
$indent        backgroundColor: Colors.deepPurple,
$indent        child: Icon(Icons.person, size: 16, color: Colors.white),
$indent      ),
$indent      if (!$isMinimizedCheckExpr) ...[
$indent        const SizedBox(width: 10),
$indent        const Expanded(
$indent          child: Text(
$indent            'Developer',
$indent            overflow: TextOverflow.ellipsis,
$indent            style: TextStyle(color: Colors.white70, fontSize: 13),
$indent          ),
$indent        ),
$indent      ],
$indent    ],
$indent  ),
$indent),''');
    }
    b.writeln('${indent}showToggleButton: ${cfg.showToggleButton},');
    b.writeln(
        '${indent}expandedToggleIcon: ${_toggleIconToCode(cfg.expandedToggleIconKey)},');
    b.writeln(
        '${indent}collapsedToggleIcon: ${_toggleIconToCode(cfg.collapsedToggleIconKey)},');
    if (cfg.useCustomToggleButtonColor) {
      b.writeln(
          '${indent}toggleButtonColor: ${_colorToCode(cfg.toggleButtonColor)},');
    }
    b.writeln('${indent}scrollPhysics: ${_physicsToCode(cfg.scrollPhysicsKey)},');
    return b.toString();
  }

  /// Generates all files for the StatefulWidget export option.
  static Map<String, String> generateStatefulFiles(SideBarExportConfig cfg) {
    final mainDart = '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GN Side Navigation Rail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff121212),
        useMaterial3: true,
      ),
      home: const SideNavigationScreen(),
    );
  }
}

class SideNavigationScreen extends StatefulWidget {
  const SideNavigationScreen({super.key});

  @override
  State<SideNavigationScreen> createState() => _SideNavigationScreenState();
}

class _SideNavigationScreenState extends State<SideNavigationScreen> {
  late final SideBarController _controller;

  final List<SideBarItem> _sidebarItems = ${_buildItemsListLiteral(cfg.sidebarItems, '  ')};

  @override
  void initState() {
    super.initState();
    _controller = SideBarController(
      initialIndex: ${cfg.initialIndex},
      initialMinimized: ${cfg.directIsMinimized},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
${cfg.transitionType == SideBarTransitionType.custom ? '''

  Widget _buildCustomTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
''' : ''}
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final activeItem = _sidebarItems[_controller.selectedIndex];

        return Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
${_buildSideBarWidgetArgs(
      cfg,
      indent: '                ',
      controllerExpr: '_controller',
      isMinimizedCheckExpr: '_controller.isMinimized',
      onTapExpr: '(index) {}',
      onMinimizeChangedExpr: '(isMinimized) {}',
    )}              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(activeItem.iconSelected, size: 56, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        activeItem.text,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
''';

    final pubspecYaml = '''name: gn_side_navigation_app
description: "Generated Flutter project using flutter_gn_side_navigation_rail (StatefulWidget)."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_gn_side_navigation_rail: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
''';

    final readmeMd = '''# GN Side Navigation Rail (StatefulWidget Export)

This package was exported from the **GN Side Navigation Rail Playground** using the **StatefulWidget** architecture.

## Included Files
- `pubspec.yaml`: Project dependencies (`flutter_gn_side_navigation_rail`).
- `analysis_options.yaml`: Standard Flutter lint rules.
- `lib/main.dart`: Complete runnable `StatefulWidget` with `SideBarController` and your configured `SideBarAnimated` properties.

## Quick Start
```bash
flutter pub get
flutter run
```
''';

    return {
      'lib/main.dart': mainDart,
      'pubspec.yaml': pubspecYaml,
      'analysis_options.yaml': _analysisOptionsYaml,
      'README.md': readmeMd,
    };
  }

  /// Generates all files for the BLoC export option.
  static Map<String, String> generateBlocFiles(SideBarExportConfig cfg) {
    final blocEventDart = '''import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

final class NavigationItemSelected extends NavigationEvent {
  final int index;
  final SideBarTransitionType? transitionType;
  final Duration? duration;
  final Curve? curve;

  const NavigationItemSelected(
    this.index, {
    this.transitionType,
    this.duration,
    this.curve,
  });

  @override
  List<Object?> get props => [index, transitionType, duration, curve];
}

final class NavigationMinimizeToggled extends NavigationEvent {
  const NavigationMinimizeToggled();
}

final class NavigationMinimizeChanged extends NavigationEvent {
  final bool isMinimized;

  const NavigationMinimizeChanged(this.isMinimized);

  @override
  List<Object?> get props => [isMinimized];
}
''';

    final blocStateDart = '''import 'package:equatable/equatable.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

final class NavigationState extends Equatable {
  final int selectedIndex;
  final bool isMinimized;
  final SideBarTransitionType transitionType;

  const NavigationState({
    this.selectedIndex = ${cfg.initialIndex},
    this.isMinimized = ${cfg.directIsMinimized},
    this.transitionType = SideBarTransitionType.${cfg.transitionType.name},
  });

  NavigationState copyWith({
    int? selectedIndex,
    bool? isMinimized,
    SideBarTransitionType? transitionType,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isMinimized: isMinimized ?? this.isMinimized,
      transitionType: transitionType ?? this.transitionType,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, isMinimized, transitionType];
}
''';

    final blocDart = '''import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final SideBarController sideBarController;

  NavigationBloc({SideBarController? controller})
      : sideBarController = controller ??
            SideBarController(
              initialIndex: ${cfg.initialIndex},
              initialMinimized: ${cfg.directIsMinimized},
            ),
        super(const NavigationState()) {
    on<NavigationItemSelected>(_onItemSelected);
    on<NavigationMinimizeToggled>(_onMinimizeToggled);
    on<NavigationMinimizeChanged>(_onMinimizeChanged);
  }

  void _onItemSelected(
    NavigationItemSelected event,
    Emitter<NavigationState> emit,
  ) {
    sideBarController.selectIndex(
      event.index,
      transitionType: event.transitionType,
      duration: event.duration,
      curve: event.curve,
    );
    emit(state.copyWith(
      selectedIndex: event.index,
      transitionType: event.transitionType ?? state.transitionType,
    ));
  }

  void _onMinimizeToggled(
    NavigationMinimizeToggled event,
    Emitter<NavigationState> emit,
  ) {
    sideBarController.toggleMinimize();
    emit(state.copyWith(isMinimized: sideBarController.isMinimized));
  }

  void _onMinimizeChanged(
    NavigationMinimizeChanged event,
    Emitter<NavigationState> emit,
  ) {
    sideBarController.setMinimized(event.isMinimized);
    emit(state.copyWith(isMinimized: event.isMinimized));
  }

  @override
  Future<void> close() {
    sideBarController.dispose();
    return super.close();
  }
}
''';

    final mainDart = '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/navigation_event.dart';
import 'bloc/navigation_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GN Side Navigation Rail BLoC App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff121212),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => NavigationBloc(),
        child: const SideNavigationBlocScreen(),
      ),
    );
  }
}

class SideNavigationBlocScreen extends StatelessWidget {
  const SideNavigationBlocScreen({super.key});

  static final List<SideBarItem> _sidebarItems = ${_buildItemsListLiteral(cfg.sidebarItems, '  ')};
${cfg.transitionType == SideBarTransitionType.custom ? '''

  static Widget _buildCustomTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
''' : ''}
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NavigationBloc>();

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        final activeItem = _sidebarItems[state.selectedIndex];

        return Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
${_buildSideBarWidgetArgs(
      cfg,
      indent: '                ',
      controllerExpr: 'bloc.sideBarController',
      isMinimizedCheckExpr: 'state.isMinimized',
      onTapExpr: '(index) => bloc.add(NavigationItemSelected(index))',
      onMinimizeChangedExpr:
          '(isMinimized) => bloc.add(NavigationMinimizeChanged(isMinimized))',
    )}              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(activeItem.iconSelected, size: 56, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        activeItem.text,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () =>
                            bloc.add(const NavigationMinimizeToggled()),
                        icon: Icon(state.isMinimized
                            ? Icons.unfold_more
                            : Icons.unfold_less),
                        label: Text(
                            state.isMinimized ? 'Expand Rail' : 'Collapse Rail'),
                      ),
                    ],
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
''';

    final pubspecYaml = '''name: gn_side_navigation_bloc_app
description: "Generated Flutter project using flutter_gn_side_navigation_rail with flutter_bloc."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_gn_side_navigation_rail: ^2.1.0
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
''';

    final readmeMd = '''# GN Side Navigation Rail (BLoC Export)

This package was exported from the **GN Side Navigation Rail Playground** using the **BLoC (`flutter_bloc`)** architecture.

## Included Files
- `pubspec.yaml`: Project dependencies (`flutter_gn_side_navigation_rail`, `flutter_bloc`, `equatable`).
- `analysis_options.yaml`: Standard Flutter lint rules.
- `lib/bloc/navigation_event.dart`: BLoC events for item selection, transition overrides, and rail collapse/expand.
- `lib/bloc/navigation_state.dart`: Immutable `NavigationState` using `Equatable`.
- `lib/bloc/navigation_bloc.dart`: `NavigationBloc` coordinating `SideBarController` and state emissions.
- `lib/main.dart`: Complete `BlocProvider` & `BlocBuilder` integration with your configured `SideBarAnimated` properties.

## Quick Start
```bash
flutter pub get
flutter run
```
''';

    return {
      'lib/main.dart': mainDart,
      'lib/bloc/navigation_bloc.dart': blocDart,
      'lib/bloc/navigation_event.dart': blocEventDart,
      'lib/bloc/navigation_state.dart': blocStateDart,
      'pubspec.yaml': pubspecYaml,
      'analysis_options.yaml': _analysisOptionsYaml,
      'README.md': readmeMd,
    };
  }

  static const String _analysisOptionsYaml = '''include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
''';
}
