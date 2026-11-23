import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../../domain/entities/studio_enums.dart';

/// Immutable snapshot of the playground studio and sidebar configuration.
class PlaygroundState extends Equatable {
  /// Current sidebar configuration mirrored in the live rail and code export.
  final SideBarExportConfig config;

  /// Active theme mode for the surrounding studio shell.
  final ThemeMode themeMode;

  /// Currently active preset, or `null` after a manual edit.
  final RailPreset? activePreset;

  /// Active right inspector mode.
  final InspectorMode inspectorMode;

  /// Active tab inside the customize view.
  final CustomizeTab customizeTab;

  /// Whether the docked inspector is open on desktop layouts.
  final bool showDesktopInspector;

  /// Whether the advanced settings section is expanded.
  final bool showAdvanced;

  /// Target architecture for generated code and ZIP export.
  final ExportArchitecture exportArchitecture;

  /// Relative path of the currently displayed generated file.
  final String selectedExportFile;

  /// Generated source files mapped from relative path to Dart/YAML content.
  final Map<String, String> generatedFiles;

  /// Whether a ZIP archive export is currently running.
  final bool isExportingZip;

  /// File path or archive name returned by the last successful ZIP export.
  final String? lastExportSavedPath;

  /// Error message from the most recent failed ZIP export, if any.
  final String? lastExportError;

  /// Index reported by the last `onTap` callback from `SideBarAnimated`.
  final int? lastTappedIndex;

  /// Label of the most recently triggered non-selectable action item, if any.
  final String? lastActionLabel;

  /// Monotonically incremented counter whenever an action item is triggered.
  final int actionTriggerCount;

  /// Minimize value reported by the last `onMinimizeChanged` callback.
  final bool? lastMinimizeCallbackValue;

  /// Selected index observed on the attached [SideBarController].
  final int controllerSelectedIndex;

  /// Whether the attached [SideBarController] is minimized.
  final bool controllerIsMinimized;

  /// Transition type used by programmatic override jump buttons.
  final SideBarTransitionType overrideTransitionType;

  /// Duration in milliseconds used by programmatic override jump buttons.
  final int overrideDurationMs;

  /// Curve key used by programmatic override jump buttons.
  final String overrideCurveKey;

  /// Creates an immutable [PlaygroundState].
  const PlaygroundState({
    required this.config,
    required this.themeMode,
    required this.activePreset,
    required this.inspectorMode,
    required this.customizeTab,
    required this.showDesktopInspector,
    required this.showAdvanced,
    required this.exportArchitecture,
    required this.selectedExportFile,
    required this.generatedFiles,
    required this.isExportingZip,
    required this.lastExportSavedPath,
    required this.lastExportError,
    required this.lastTappedIndex,
    this.lastActionLabel,
    this.actionTriggerCount = 0,
    required this.lastMinimizeCallbackValue,
    required this.controllerSelectedIndex,
    required this.controllerIsMinimized,
    required this.overrideTransitionType,
    required this.overrideDurationMs,
    required this.overrideCurveKey,
  });

  /// Clamped active navigation index across controller and uncontrolled modes.
  int get effectiveIndex {
    final raw = config.useController
        ? controllerSelectedIndex
        : (lastTappedIndex ?? config.initialIndex);
    final clamped = raw.clamp(0, config.sidebarItems.length - 1);
    if (!config.sidebarItems[clamped].isAction) {
      return clamped;
    }
    final firstNav = config.sidebarItems.indexWhere((item) => !item.isAction);
    return firstNav >= 0 ? firstNav : 0;
  }

  /// Currently selected [SideBarItem].
  SideBarItem get activeItem => config.sidebarItems[effectiveIndex];

  /// Whether the sidebar is currently collapsed into rail mode.
  bool get isCurrentlyMinimized {
    if (config.useController) return controllerIsMinimized;
    if (config.useDirectIsMinimized) return config.directIsMinimized;
    return lastMinimizeCallbackValue ?? false;
  }

  /// Active vertical sizing mode derived from [config].
  RailHeightMode get heightMode {
    if (config.useCustomHeight) return RailHeightMode.fixed;
    if (config.shrinkWrap) return RailHeightMode.wrap;
    return RailHeightMode.full;
  }

  /// Returns a copy of this state with the given fields replaced.
  PlaygroundState copyWith({
    SideBarExportConfig? config,
    ThemeMode? themeMode,
    RailPreset? activePreset,
    bool clearActivePreset = false,
    InspectorMode? inspectorMode,
    CustomizeTab? customizeTab,
    bool? showDesktopInspector,
    bool? showAdvanced,
    ExportArchitecture? exportArchitecture,
    String? selectedExportFile,
    Map<String, String>? generatedFiles,
    bool? isExportingZip,
    String? lastExportSavedPath,
    bool clearLastExportSavedPath = false,
    String? lastExportError,
    bool clearLastExportError = false,
    int? lastTappedIndex,
    bool clearLastTappedIndex = false,
    String? lastActionLabel,
    bool clearLastActionLabel = false,
    int? actionTriggerCount,
    bool? lastMinimizeCallbackValue,
    bool clearLastMinimizeCallbackValue = false,
    int? controllerSelectedIndex,
    bool? controllerIsMinimized,
    SideBarTransitionType? overrideTransitionType,
    int? overrideDurationMs,
    String? overrideCurveKey,
  }) {
    return PlaygroundState(
      config: config ?? this.config,
      themeMode: themeMode ?? this.themeMode,
      activePreset:
          clearActivePreset ? null : (activePreset ?? this.activePreset),
      inspectorMode: inspectorMode ?? this.inspectorMode,
      customizeTab: customizeTab ?? this.customizeTab,
      showDesktopInspector: showDesktopInspector ?? this.showDesktopInspector,
      showAdvanced: showAdvanced ?? this.showAdvanced,
      exportArchitecture: exportArchitecture ?? this.exportArchitecture,
      selectedExportFile: selectedExportFile ?? this.selectedExportFile,
      generatedFiles: generatedFiles ?? this.generatedFiles,
      isExportingZip: isExportingZip ?? this.isExportingZip,
      lastExportSavedPath: clearLastExportSavedPath
          ? null
          : (lastExportSavedPath ?? this.lastExportSavedPath),
      lastExportError: clearLastExportError
          ? null
          : (lastExportError ?? this.lastExportError),
      lastTappedIndex: clearLastTappedIndex
          ? null
          : (lastTappedIndex ?? this.lastTappedIndex),
      lastActionLabel: clearLastActionLabel
          ? null
          : (lastActionLabel ?? this.lastActionLabel),
      actionTriggerCount: actionTriggerCount ?? this.actionTriggerCount,
      lastMinimizeCallbackValue: clearLastMinimizeCallbackValue
          ? null
          : (lastMinimizeCallbackValue ?? this.lastMinimizeCallbackValue),
      controllerSelectedIndex:
          controllerSelectedIndex ?? this.controllerSelectedIndex,
      controllerIsMinimized:
          controllerIsMinimized ?? this.controllerIsMinimized,
      overrideTransitionType:
          overrideTransitionType ?? this.overrideTransitionType,
      overrideDurationMs: overrideDurationMs ?? this.overrideDurationMs,
      overrideCurveKey: overrideCurveKey ?? this.overrideCurveKey,
    );
  }

  @override
  List<Object?> get props => [
        config,
        themeMode,
        activePreset,
        inspectorMode,
        customizeTab,
        showDesktopInspector,
        showAdvanced,
        exportArchitecture,
        selectedExportFile,
        generatedFiles,
        isExportingZip,
        lastExportSavedPath,
        lastExportError,
        lastTappedIndex,
        lastActionLabel,
        actionTriggerCount,
        lastMinimizeCallbackValue,
        controllerSelectedIndex,
        controllerIsMinimized,
        overrideTransitionType,
        overrideDurationMs,
        overrideCurveKey,
      ];
}

/// Convenience copy helper for creating updated [SideBarExportConfig] values.
extension SideBarExportConfigCopy on SideBarExportConfig {
  /// Returns a new [SideBarExportConfig] with the provided fields updated.
  SideBarExportConfig copyWith({
    bool? useController,
    bool? useDirectIsMinimized,
    bool? directIsMinimized,
    int? initialIndex,
    double? widthSwitch,
    double? sideBarWidth,
    double? sideBarSmallWidth,
    bool? shrinkWrap,
    bool? useCustomHeight,
    double? customHeight,
    double? itemHeight,
    double? itemSpacing,
    double? borderRadius,
    double? itemBorderRadiusValue,
    double? marginAll,
    bool? useCustomContentPadding,
    double? contentPaddingHorizontal,
    double? contentPaddingVertical,
    Color? sideBarColor,
    Color? animatedContainerColor,
    Color? selectedIconColor,
    Color? unselectedIconColor,
    bool? useCustomDisabledIconColor,
    Color? disabledIconColor,
    Color? unSelectedTextColor,
    bool? useCustomDisabledTextColor,
    Color? disabledTextColor,
    Color? hoverColor,
    Color? splashColor,
    Color? highlightColor,
    bool? useCustomTextStyle,
    double? baseFontSize,
    FontWeight? baseFontWeight,
    bool? useCustomSelectedTextStyle,
    Color? selectedTextColor,
    double? selectedFontSize,
    FontWeight? selectedFontWeight,
    bool? useCustomDisabledTextStyle,
    double? disabledFontSize,
    bool? disabledFontItalic,
    bool? settingsDivider,
    Color? dividerColor,
    double? dividerHeight,
    double? dividerThickness,
    SideBarTransitionType? transitionType,
    int? sideBarAnimationDurationMs,
    int? itemTransitionDurationMs,
    String? curveKey,
    String? itemTransitionCurveKey,
    String? customTransitionMode,
    bool? showHeaderWidget,
    bool? showFooterWidget,
    bool? showToggleButton,
    bool? useCustomToggleButtonColor,
    Color? toggleButtonColor,
    bool? useCustomToggleWidgets,
    String? expandedToggleIconKey,
    String? collapsedToggleIconKey,
    String? scrollPhysicsKey,
    List<SideBarItem>? sidebarItems,
  }) {
    return SideBarExportConfig(
      useController: useController ?? this.useController,
      useDirectIsMinimized: useDirectIsMinimized ?? this.useDirectIsMinimized,
      directIsMinimized: directIsMinimized ?? this.directIsMinimized,
      initialIndex: initialIndex ?? this.initialIndex,
      widthSwitch: widthSwitch ?? this.widthSwitch,
      sideBarWidth: sideBarWidth ?? this.sideBarWidth,
      sideBarSmallWidth: sideBarSmallWidth ?? this.sideBarSmallWidth,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      useCustomHeight: useCustomHeight ?? this.useCustomHeight,
      customHeight: customHeight ?? this.customHeight,
      itemHeight: itemHeight ?? this.itemHeight,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      borderRadius: borderRadius ?? this.borderRadius,
      itemBorderRadiusValue:
          itemBorderRadiusValue ?? this.itemBorderRadiusValue,
      marginAll: marginAll ?? this.marginAll,
      useCustomContentPadding:
          useCustomContentPadding ?? this.useCustomContentPadding,
      contentPaddingHorizontal:
          contentPaddingHorizontal ?? this.contentPaddingHorizontal,
      contentPaddingVertical:
          contentPaddingVertical ?? this.contentPaddingVertical,
      sideBarColor: sideBarColor ?? this.sideBarColor,
      animatedContainerColor:
          animatedContainerColor ?? this.animatedContainerColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      unselectedIconColor: unselectedIconColor ?? this.unselectedIconColor,
      useCustomDisabledIconColor:
          useCustomDisabledIconColor ?? this.useCustomDisabledIconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      unSelectedTextColor: unSelectedTextColor ?? this.unSelectedTextColor,
      useCustomDisabledTextColor:
          useCustomDisabledTextColor ?? this.useCustomDisabledTextColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      hoverColor: hoverColor ?? this.hoverColor,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      useCustomTextStyle: useCustomTextStyle ?? this.useCustomTextStyle,
      baseFontSize: baseFontSize ?? this.baseFontSize,
      baseFontWeight: baseFontWeight ?? this.baseFontWeight,
      useCustomSelectedTextStyle:
          useCustomSelectedTextStyle ?? this.useCustomSelectedTextStyle,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      selectedFontSize: selectedFontSize ?? this.selectedFontSize,
      selectedFontWeight: selectedFontWeight ?? this.selectedFontWeight,
      useCustomDisabledTextStyle:
          useCustomDisabledTextStyle ?? this.useCustomDisabledTextStyle,
      disabledFontSize: disabledFontSize ?? this.disabledFontSize,
      disabledFontItalic: disabledFontItalic ?? this.disabledFontItalic,
      settingsDivider: settingsDivider ?? this.settingsDivider,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      transitionType: transitionType ?? this.transitionType,
      sideBarAnimationDurationMs:
          sideBarAnimationDurationMs ?? this.sideBarAnimationDurationMs,
      itemTransitionDurationMs:
          itemTransitionDurationMs ?? this.itemTransitionDurationMs,
      curveKey: curveKey ?? this.curveKey,
      itemTransitionCurveKey:
          itemTransitionCurveKey ?? this.itemTransitionCurveKey,
      customTransitionMode: customTransitionMode ?? this.customTransitionMode,
      showHeaderWidget: showHeaderWidget ?? this.showHeaderWidget,
      showFooterWidget: showFooterWidget ?? this.showFooterWidget,
      showToggleButton: showToggleButton ?? this.showToggleButton,
      useCustomToggleButtonColor:
          useCustomToggleButtonColor ?? this.useCustomToggleButtonColor,
      toggleButtonColor: toggleButtonColor ?? this.toggleButtonColor,
      useCustomToggleWidgets:
          useCustomToggleWidgets ?? this.useCustomToggleWidgets,
      expandedToggleIconKey:
          expandedToggleIconKey ?? this.expandedToggleIconKey,
      collapsedToggleIconKey:
          collapsedToggleIconKey ?? this.collapsedToggleIconKey,
      scrollPhysicsKey: scrollPhysicsKey ?? this.scrollPhysicsKey,
      sidebarItems: sidebarItems ?? this.sidebarItems,
    );
  }
}
