import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../../domain/entities/studio_enums.dart';
import '../../domain/usecases/studio_usecases.dart';
import 'playground_event.dart';
import 'playground_state.dart';

/// Coordinates playground state, rail presets, and code exports via BLoC.
class PlaygroundBloc extends Bloc<PlaygroundEvent, PlaygroundState> {
  /// Animation curves selectable in the motion and override panels.
  static const Map<String, Curve> curveOptions = {
    'easeOut': Curves.easeOut,
    'easeIn': Curves.easeIn,
    'easeInOut': Curves.easeInOut,
    'easeOutCubic': Curves.easeOutCubic,
    'easeInOutCubic': Curves.easeInOutCubic,
    'easeInOutBack': Curves.easeInOutBack,
    'elasticOut': Curves.elasticOut,
    'bounceOut': Curves.bounceOut,
    'fastOutSlowIn': Curves.fastOutSlowIn,
    'linear': Curves.linear,
  };

  /// Icons selectable for the sidebar collapse and expand toggle button.
  static const Map<String, IconData> toggleIconOptions = {
    'menu_open': Icons.menu_open,
    'menu': Icons.menu,
    'space_dashboard': Icons.space_dashboard_outlined,
    'arrow_right': CupertinoIcons.arrow_right,
    'chevron_left': Icons.chevron_left,
    'chevron_right': Icons.chevron_right,
    'unfold_less': Icons.unfold_less,
    'unfold_more': Icons.unfold_more,
  };

  /// Scroll physics selectable for the sidebar item list.
  static const Map<String, ScrollPhysics> physicsOptions = {
    'bouncing': BouncingScrollPhysics(),
    'clamping': ClampingScrollPhysics(),
    'never': NeverScrollableScrollPhysics(),
  };

  final ApplyRailPresetUseCase _applyPreset;
  final GenerateProjectFilesUseCase _generateFiles;
  final ExportProjectZipUseCase _exportZip;
  final bool _ownsController;

  /// External controller attached to `SideBarAnimated` when enabled.
  final SideBarController sideBarController;

  /// Creates a [PlaygroundBloc] with injected domain use cases.
  factory PlaygroundBloc({
    required ApplyRailPresetUseCase applyPreset,
    required GenerateProjectFilesUseCase generateFiles,
    required ExportProjectZipUseCase exportZip,
    SideBarController? sideBarController,
  }) {
    final initialItems = applyPreset.defaultItems();
    final initialConfig = applyPreset(RailPreset.obsidian, initialItems);
    final initialFiles = generateFiles(
      config: initialConfig,
      architecture: ExportArchitecture.stateful,
    );
    final controller = sideBarController ??
        SideBarController(
          initialIndex: initialConfig.initialIndex,
          initialMinimized: false,
        );

    return PlaygroundBloc._(
      applyPreset: applyPreset,
      generateFiles: generateFiles,
      exportZip: exportZip,
      sideBarController: controller,
      ownsController: sideBarController == null,
      initialState: PlaygroundState(
        config: initialConfig,
        themeMode: ThemeMode.dark,
        activePreset: RailPreset.obsidian,
        inspectorMode: InspectorMode.customize,
        customizeTab: CustomizeTab.style,
        showDesktopInspector: true,
        showAdvanced: false,
        exportArchitecture: ExportArchitecture.stateful,
        selectedExportFile: 'lib/main.dart',
        generatedFiles: initialFiles,
        isExportingZip: false,
        lastExportSavedPath: null,
        lastExportError: null,
        lastTappedIndex: null,
        lastMinimizeCallbackValue: null,
        controllerSelectedIndex: controller.selectedIndex,
        controllerIsMinimized: controller.isMinimized,
        overrideTransitionType: SideBarTransitionType.slide,
        overrideDurationMs: 500,
        overrideCurveKey: 'easeInOutBack',
      ),
    );
  }

  PlaygroundBloc._({
    required ApplyRailPresetUseCase applyPreset,
    required GenerateProjectFilesUseCase generateFiles,
    required ExportProjectZipUseCase exportZip,
    required this.sideBarController,
    required bool ownsController,
    required PlaygroundState initialState,
  })  : _applyPreset = applyPreset,
        _generateFiles = generateFiles,
        _exportZip = exportZip,
        _ownsController = ownsController,
        super(initialState) {
    sideBarController.addListener(_onControllerChanged);

    on<PlaygroundThemeToggled>(_onThemeToggled);
    on<PlaygroundDesktopInspectorToggled>(_onDesktopInspectorToggled);
    on<PlaygroundInspectorModeChanged>(_onInspectorModeChanged);
    on<PlaygroundCustomizeTabChanged>(_onCustomizeTabChanged);
    on<PlaygroundAdvancedVisibilityChanged>(_onAdvancedVisibilityChanged);
    on<PlaygroundPresetApplied>(_onPresetApplied);
    on<PlaygroundResetRequested>(_onResetRequested);
    on<PlaygroundRailMinimizeToggled>(_onRailMinimizeToggled);
    on<PlaygroundHeightModeChanged>(_onHeightModeChanged);
    on<PlaygroundRailTapped>(_onRailTapped);
    on<PlaygroundRailMinimizeReported>(_onRailMinimizeReported);
    on<PlaygroundControllerSynced>(_onControllerSynced);
    on<PlaygroundConfigUpdated>(_onConfigUpdated);
    on<PlaygroundItemDisabledToggled>(_onItemDisabledToggled);
    on<PlaygroundItemAdded>(_onItemAdded);
    on<PlaygroundItemRemoved>(_onItemRemoved);
    on<PlaygroundItemsReset>(_onItemsReset);
    on<PlaygroundOverrideTransitionChanged>(_onOverrideTransitionChanged);
    on<PlaygroundOverrideDurationChanged>(_onOverrideDurationChanged);
    on<PlaygroundOverrideCurveChanged>(_onOverrideCurveChanged);
    on<PlaygroundExportArchitectureChanged>(_onExportArchitectureChanged);
    on<PlaygroundExportFileSelected>(_onExportFileSelected);
    on<PlaygroundZipExportRequested>(_onZipExportRequested);
  }

  void _onControllerChanged() {
    if (!isClosed) {
      add(const PlaygroundControllerSynced());
    }
  }

  Map<String, String> _regenerate(
    SideBarExportConfig config,
    ExportArchitecture architecture,
  ) {
    return _generateFiles(config: config, architecture: architecture);
  }

  void _onThemeToggled(
    PlaygroundThemeToggled event,
    Emitter<PlaygroundState> emit,
  ) {
    final nextMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: nextMode));
  }

  void _onDesktopInspectorToggled(
    PlaygroundDesktopInspectorToggled event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(showDesktopInspector: !state.showDesktopInspector));
  }

  void _onInspectorModeChanged(
    PlaygroundInspectorModeChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(inspectorMode: event.mode));
  }

  void _onCustomizeTabChanged(
    PlaygroundCustomizeTabChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(customizeTab: event.tab));
  }

  void _onAdvancedVisibilityChanged(
    PlaygroundAdvancedVisibilityChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(showAdvanced: event.show));
  }

  void _onPresetApplied(
    PlaygroundPresetApplied event,
    Emitter<PlaygroundState> emit,
  ) {
    final nextConfig = _applyPreset(event.preset, state.config.sidebarItems);
    emit(
      state.copyWith(
        config: nextConfig,
        activePreset: event.preset,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onResetRequested(
    PlaygroundResetRequested event,
    Emitter<PlaygroundState> emit,
  ) {
    final items = _applyPreset.defaultItems();
    final nextConfig = _applyPreset(RailPreset.obsidian, items);
    sideBarController.selectIndex(0, transitionType: SideBarTransitionType.none);
    sideBarController.expand();
    emit(
      state.copyWith(
        config: nextConfig,
        activePreset: RailPreset.obsidian,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
        clearLastTappedIndex: true,
        clearLastMinimizeCallbackValue: true,
        controllerSelectedIndex: 0,
        controllerIsMinimized: false,
        overrideTransitionType: SideBarTransitionType.slide,
        overrideDurationMs: 500,
        overrideCurveKey: 'easeInOutBack',
      ),
    );
  }

  void _onRailMinimizeToggled(
    PlaygroundRailMinimizeToggled event,
    Emitter<PlaygroundState> emit,
  ) {
    if (state.config.useController) {
      sideBarController.toggleMinimize();
      emit(
        state.copyWith(
          controllerSelectedIndex: sideBarController.selectedIndex,
          controllerIsMinimized: sideBarController.isMinimized,
        ),
      );
      return;
    }

    final nextConfig = state.config.copyWith(
      useDirectIsMinimized: true,
      directIsMinimized: !state.config.directIsMinimized,
    );
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onHeightModeChanged(
    PlaygroundHeightModeChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    final nextConfig = switch (event.mode) {
      RailHeightMode.full =>
        state.config.copyWith(shrinkWrap: false, useCustomHeight: false),
      RailHeightMode.wrap =>
        state.config.copyWith(shrinkWrap: true, useCustomHeight: false),
      RailHeightMode.fixed =>
        state.config.copyWith(shrinkWrap: false, useCustomHeight: true),
    };
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onRailTapped(
    PlaygroundRailTapped event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(lastTappedIndex: event.index));
  }

  void _onRailMinimizeReported(
    PlaygroundRailMinimizeReported event,
    Emitter<PlaygroundState> emit,
  ) {
    if (state.config.useDirectIsMinimized) {
      final nextConfig = state.config.copyWith(
        directIsMinimized: event.minimized,
      );
      emit(
        state.copyWith(
          config: nextConfig,
          lastMinimizeCallbackValue: event.minimized,
          generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
        ),
      );
      return;
    }
    emit(state.copyWith(lastMinimizeCallbackValue: event.minimized));
  }

  void _onControllerSynced(
    PlaygroundControllerSynced event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(
      state.copyWith(
        controllerSelectedIndex: sideBarController.selectedIndex,
        controllerIsMinimized: sideBarController.isMinimized,
      ),
    );
  }

  void _onConfigUpdated(
    PlaygroundConfigUpdated event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(
      state.copyWith(
        config: event.config,
        clearActivePreset: !event.keepPreset,
        generatedFiles: _regenerate(event.config, state.exportArchitecture),
      ),
    );
  }

  void _onItemDisabledToggled(
    PlaygroundItemDisabledToggled event,
    Emitter<PlaygroundState> emit,
  ) {
    final items = List<SideBarItem>.from(state.config.sidebarItems);
    final current = items[event.index];
    items[event.index] = SideBarItem(
      iconSelected: current.iconSelected,
      iconUnselected: current.iconUnselected,
      text: current.text,
      isDisabled: !current.isDisabled,
      tooltip: current.tooltip,
    );
    final nextConfig = state.config.copyWith(sidebarItems: items);
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onItemAdded(
    PlaygroundItemAdded event,
    Emitter<PlaygroundState> emit,
  ) {
    final items = List<SideBarItem>.from(state.config.sidebarItems);
    final nextNum = items.length + 1;
    items.insert(
      items.length - 1,
      SideBarItem(
        iconSelected: Icons.folder,
        iconUnselected: Icons.folder_outlined,
        text: 'Project $nextNum',
        tooltip: 'Custom workspace #$nextNum',
      ),
    );
    final nextConfig = state.config.copyWith(sidebarItems: items);
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onItemRemoved(
    PlaygroundItemRemoved event,
    Emitter<PlaygroundState> emit,
  ) {
    if (state.config.sidebarItems.length <= 2) return;
    final items = List<SideBarItem>.from(state.config.sidebarItems)
      ..removeAt(event.index);
    if (sideBarController.selectedIndex >= items.length) {
      sideBarController.selectIndex(
        items.length - 1,
        transitionType: SideBarTransitionType.none,
      );
    }
    final clampedInitial = state.config.initialIndex.clamp(0, items.length - 1);
    final nextConfig = state.config.copyWith(
      sidebarItems: items,
      initialIndex: clampedInitial,
    );
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        controllerSelectedIndex: sideBarController.selectedIndex,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onItemsReset(
    PlaygroundItemsReset event,
    Emitter<PlaygroundState> emit,
  ) {
    final defaults = _applyPreset.defaultItems();
    sideBarController.selectIndex(0, transitionType: SideBarTransitionType.none);
    final nextConfig = state.config.copyWith(
      sidebarItems: defaults,
      initialIndex: 0,
    );
    emit(
      state.copyWith(
        config: nextConfig,
        clearActivePreset: true,
        controllerSelectedIndex: 0,
        generatedFiles: _regenerate(nextConfig, state.exportArchitecture),
      ),
    );
  }

  void _onOverrideTransitionChanged(
    PlaygroundOverrideTransitionChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(overrideTransitionType: event.transitionType));
  }

  void _onOverrideDurationChanged(
    PlaygroundOverrideDurationChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(overrideDurationMs: event.durationMs));
  }

  void _onOverrideCurveChanged(
    PlaygroundOverrideCurveChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(overrideCurveKey: event.curveKey));
  }

  void _onExportArchitectureChanged(
    PlaygroundExportArchitectureChanged event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(
      state.copyWith(
        exportArchitecture: event.architecture,
        selectedExportFile: 'lib/main.dart',
        generatedFiles: _regenerate(state.config, event.architecture),
      ),
    );
  }

  void _onExportFileSelected(
    PlaygroundExportFileSelected event,
    Emitter<PlaygroundState> emit,
  ) {
    emit(state.copyWith(selectedExportFile: event.fileName));
  }

  Future<void> _onZipExportRequested(
    PlaygroundZipExportRequested event,
    Emitter<PlaygroundState> emit,
  ) async {
    emit(
      state.copyWith(
        isExportingZip: true,
        clearLastExportError: true,
      ),
    );
    try {
      final savedPath = await _exportZip(
        config: state.config,
        architecture: state.exportArchitecture,
      );
      emit(
        state.copyWith(
          isExportingZip: false,
          lastExportSavedPath: savedPath,
          clearLastExportError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isExportingZip: false,
          lastExportError: '$e',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    sideBarController.removeListener(_onControllerChanged);
    if (_ownsController) {
      sideBarController.dispose();
    }
    return super.close();
  }
}
