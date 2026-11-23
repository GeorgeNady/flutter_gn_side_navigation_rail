import 'package:equatable/equatable.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../../domain/entities/studio_enums.dart';

/// Base class for all events handled by [PlaygroundBloc].
sealed class PlaygroundEvent extends Equatable {
  /// Creates a playground event.
  const PlaygroundEvent();

  @override
  List<Object?> get props => const [];
}

/// Toggles the studio theme between dark and light modes.
final class PlaygroundThemeToggled extends PlaygroundEvent {
  /// Creates a theme toggle event.
  const PlaygroundThemeToggled();
}

/// Toggles visibility of the docked desktop inspector panel.
final class PlaygroundDesktopInspectorToggled extends PlaygroundEvent {
  /// Creates a desktop inspector toggle event.
  const PlaygroundDesktopInspectorToggled();
}

/// Switches the right inspector between customize controls and exported code.
final class PlaygroundInspectorModeChanged extends PlaygroundEvent {
  /// The target inspector mode.
  final InspectorMode mode;

  /// Creates an inspector mode change event.
  const PlaygroundInspectorModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Switches the active section tab inside the customize view.
final class PlaygroundCustomizeTabChanged extends PlaygroundEvent {
  /// The target customize tab.
  final CustomizeTab tab;

  /// Creates a customize tab change event.
  const PlaygroundCustomizeTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

/// Expands or collapses the advanced settings section.
final class PlaygroundAdvancedVisibilityChanged extends PlaygroundEvent {
  /// Whether the advanced section should be visible.
  final bool show;

  /// Creates an advanced visibility change event.
  const PlaygroundAdvancedVisibilityChanged(this.show);

  @override
  List<Object?> get props => [show];
}

/// Applies one of the built-in rail presets.
final class PlaygroundPresetApplied extends PlaygroundEvent {
  /// The preset to apply.
  final RailPreset preset;

  /// Creates a preset application event.
  const PlaygroundPresetApplied(this.preset);

  @override
  List<Object?> get props => [preset];
}

/// Resets all rail settings, items, and controller state to defaults.
final class PlaygroundResetRequested extends PlaygroundEvent {
  /// Creates a reset event.
  const PlaygroundResetRequested();
}

/// Toggles the rail between expanded and collapsed states.
final class PlaygroundRailMinimizeToggled extends PlaygroundEvent {
  /// Creates a rail minimize toggle event.
  const PlaygroundRailMinimizeToggled();
}

/// Changes how the sidebar computes its vertical height.
final class PlaygroundHeightModeChanged extends PlaygroundEvent {
  /// The target height mode.
  final RailHeightMode mode;

  /// Creates a height mode change event.
  const PlaygroundHeightModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Records a tap on a sidebar item at [index].
final class PlaygroundRailTapped extends PlaygroundEvent {
  /// Zero-based index of the tapped sidebar item.
  final int index;

  /// Creates a rail tap event.
  const PlaygroundRailTapped(this.index);

  @override
  List<Object?> get props => [index];
}

/// Records a tap on a non-selectable action item at [index].
final class PlaygroundRailActionTapped extends PlaygroundEvent {
  /// Zero-based index of the tapped action item.
  final int index;

  /// Creates a rail action tap event.
  const PlaygroundRailActionTapped(this.index);

  @override
  List<Object?> get props => [index];
}

/// Records a minimize callback reported by `SideBarAnimated`.
final class PlaygroundRailMinimizeReported extends PlaygroundEvent {
  /// Whether the sidebar is now minimized.
  final bool minimized;

  /// Creates a minimize callback event.
  const PlaygroundRailMinimizeReported(this.minimized);

  @override
  List<Object?> get props => [minimized];
}

/// Syncs state when the attached [SideBarController] notifies listeners.
final class PlaygroundControllerSynced extends PlaygroundEvent {
  /// Creates a controller sync event.
  const PlaygroundControllerSynced();
}

/// Applies an updated [SideBarExportConfig].
final class PlaygroundConfigUpdated extends PlaygroundEvent {
  /// The updated sidebar configuration snapshot.
  final SideBarExportConfig config;

  /// Whether to keep the current preset badge selected.
  final bool keepPreset;

  /// Creates a configuration update event.
  const PlaygroundConfigUpdated(this.config, {this.keepPreset = false});

  @override
  List<Object?> get props => [config, keepPreset];
}

/// Toggles the disabled state of the sidebar item at [index].
final class PlaygroundItemDisabledToggled extends PlaygroundEvent {
  /// Zero-based index of the item to toggle.
  final int index;

  /// Creates an item disabled toggle event.
  const PlaygroundItemDisabledToggled(this.index);

  @override
  List<Object?> get props => [index];
}

/// Toggles the item at [index] between navigation and non-selectable action.
final class PlaygroundItemTypeToggled extends PlaygroundEvent {
  /// Zero-based index of the item to toggle.
  final int index;

  /// Creates an item type toggle event.
  const PlaygroundItemTypeToggled(this.index);

  @override
  List<Object?> get props => [index];
}

/// Inserts a new custom project item before the trailing item.
final class PlaygroundItemAdded extends PlaygroundEvent {
  /// Creates an add item event.
  const PlaygroundItemAdded();
}

/// Appends a new non-selectable action item (e.g. Refresh) to the rail.
final class PlaygroundActionItemAdded extends PlaygroundEvent {
  /// Creates an add action item event.
  const PlaygroundActionItemAdded();
}

/// Removes the sidebar item at [index] when more than two items exist.
final class PlaygroundItemRemoved extends PlaygroundEvent {
  /// Zero-based index of the item to remove.
  final int index;

  /// Creates a remove item event.
  const PlaygroundItemRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

/// Restores the default set of sidebar items.
final class PlaygroundItemsReset extends PlaygroundEvent {
  /// Creates an items reset event.
  const PlaygroundItemsReset();
}

/// Updates the programmatic override transition type.
final class PlaygroundOverrideTransitionChanged extends PlaygroundEvent {
  /// The transition type used for override jumps.
  final SideBarTransitionType transitionType;

  /// Creates an override transition change event.
  const PlaygroundOverrideTransitionChanged(this.transitionType);

  @override
  List<Object?> get props => [transitionType];
}

/// Updates the programmatic override duration in milliseconds.
final class PlaygroundOverrideDurationChanged extends PlaygroundEvent {
  /// Duration in milliseconds used for override jumps.
  final int durationMs;

  /// Creates an override duration change event.
  const PlaygroundOverrideDurationChanged(this.durationMs);

  @override
  List<Object?> get props => [durationMs];
}

/// Updates the programmatic override animation curve key.
final class PlaygroundOverrideCurveChanged extends PlaygroundEvent {
  /// Name of the curve key in `PlaygroundBloc.curveOptions`.
  final String curveKey;

  /// Creates an override curve change event.
  const PlaygroundOverrideCurveChanged(this.curveKey);

  @override
  List<Object?> get props => [curveKey];
}

/// Switches the generated code architecture between StatefulWidget and BLoC.
final class PlaygroundExportArchitectureChanged extends PlaygroundEvent {
  /// The target export architecture.
  final ExportArchitecture architecture;

  /// Creates an export architecture change event.
  const PlaygroundExportArchitectureChanged(this.architecture);

  @override
  List<Object?> get props => [architecture];
}

/// Selects a generated source file to view in the code pane.
final class PlaygroundExportFileSelected extends PlaygroundEvent {
  /// Relative path of the file to display.
  final String fileName;

  /// Creates a file selection event.
  const PlaygroundExportFileSelected(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

/// Triggers a ZIP export of the current generated project files.
final class PlaygroundZipExportRequested extends PlaygroundEvent {
  /// Creates a ZIP export event.
  const PlaygroundZipExportRequested();
}
