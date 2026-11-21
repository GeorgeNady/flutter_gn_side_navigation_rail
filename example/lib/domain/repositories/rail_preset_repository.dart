import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../entities/studio_enums.dart';

/// Contract for loading default sidebar items and visual presets.
abstract interface class RailPresetRepository {
  /// Returns the default navigation items shown on startup or reset.
  List<SideBarItem> getDefaultItems();

  /// Builds a complete [SideBarExportConfig] for [preset] using [items].
  SideBarExportConfig buildPreset(RailPreset preset, List<SideBarItem> items);
}
