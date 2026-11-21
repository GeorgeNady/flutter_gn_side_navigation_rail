import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/default_rail_preset_repository.dart';
import 'data/repositories/side_bar_code_export_repository.dart';
import 'domain/entities/studio_enums.dart';
import 'domain/repositories/code_export_repository.dart';
import 'domain/repositories/rail_preset_repository.dart';
import 'domain/usecases/studio_usecases.dart';
import 'presentation/bloc/playground_bloc.dart';
import 'presentation/bloc/playground_state.dart';
import 'presentation/theme/studio_theme.dart';
import 'presentation/widgets/inspector_panel.dart';
import 'presentation/widgets/live_navigation_rail.dart';
import 'presentation/widgets/preview_stage.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget that wires repositories, use cases, and [PlaygroundBloc].
class MyApp extends StatelessWidget {
  /// Repository used to generate Dart files and ZIP archives.
  final CodeExportRepository codeExportRepository;

  /// Repository used to load default sidebar items and visual presets.
  final RailPresetRepository railPresetRepository;

  /// Creates the example studio app with optional repository overrides.
  const MyApp({
    super.key,
    this.codeExportRepository = const SideBarCodeExportRepository(),
    this.railPresetRepository = const DefaultRailPresetRepository(),
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaygroundBloc>(
      create: (_) => PlaygroundBloc(
        applyPreset: ApplyRailPresetUseCase(railPresetRepository),
        generateFiles: GenerateProjectFilesUseCase(codeExportRepository),
        exportZip: ExportProjectZipUseCase(codeExportRepository),
      ),
      child: BlocSelector<PlaygroundBloc, PlaygroundState, ThemeMode>(
        selector: (state) => state.themeMode,
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'GN Navigation Rail Studio',
            debugShowCheckedModeBanner: false,
            theme: StudioTheme.light(),
            darkTheme: StudioTheme.dark(),
            themeMode: themeMode,
            home: const PlaygroundShell(),
          );
        },
      ),
    );
  }
}

/// Adaptive three-zone shell combining the live rail, preview, and inspector.
class PlaygroundShell extends StatefulWidget {
  /// Creates the playground shell.
  const PlaygroundShell({super.key});

  @override
  State<PlaygroundShell> createState() => _PlaygroundShellState();
}

class _PlaygroundShellState extends State<PlaygroundShell> {
  static const double _desktopBreakpoint = 1040.0;
  static const double _customizeInspectorWidth = 360.0;
  static const double _codeInspectorWidth = 480.0;
  static const double _compactCodeInspectorWidth = 420.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return BlocBuilder<PlaygroundBloc, PlaygroundState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
            final isCodeMode = state.inspectorMode == InspectorMode.code;
            final desktopInspectorWidth = isCodeMode
                ? (constraints.maxWidth >= 1280.0
                    ? _codeInspectorWidth
                    : _compactCodeInspectorWidth)
                : _customizeInspectorWidth;
            final drawerWidth = math.min(
              isCodeMode ? _codeInspectorWidth : 396.0,
              constraints.maxWidth * 0.92,
            );

            return Scaffold(
              key: _scaffoldKey,
              endDrawer: isDesktop
                  ? null
                  : Drawer(
                      width: drawerWidth,
                      child: InspectorPanel(
                        isDrawer: true,
                        onClose: () =>
                            _scaffoldKey.currentState?.closeEndDrawer(),
                      ),
                    ),
              body: Row(
                children: [
                  FocusTraversalGroup(
                    child: LiveNavigationRail(state: state),
                  ),
                  Expanded(
                    child: FocusTraversalGroup(
                      child: PreviewStage(
                        state: state,
                        isDesktop: isDesktop,
                        onOpenInspector: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                      ),
                    ),
                  ),
                  if (isDesktop)
                    FocusTraversalGroup(
                      child: AnimatedContainer(
                        duration: disableAnimations
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        width: state.showDesktopInspector
                            ? desktopInspectorWidth
                            : 0,
                        child: ClipRect(
                          child: OverflowBox(
                            minWidth: desktopInspectorWidth,
                            maxWidth: desktopInspectorWidth,
                            alignment: Alignment.centerLeft,
                            child: state.showDesktopInspector
                                ? const InspectorPanel()
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
