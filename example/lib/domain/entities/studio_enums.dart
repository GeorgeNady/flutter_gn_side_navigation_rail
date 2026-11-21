import 'package:flutter/material.dart';

/// Active mode shown in the right inspector panel.
enum InspectorMode {
  /// Interactive controls for editing rail properties.
  customize,

  /// Live Dart source preview and ZIP archive exporter.
  code,
}

/// Active tab inside the customize inspector view.
enum CustomizeTab {
  /// Colors, header/footer visibility, and chrome toggles.
  style,

  /// Height mode, rail widths, radii, and item spacing.
  layout,

  /// Selection indicator transitions, speeds, and curves.
  motion,

  /// Dynamic list of navigation items.
  items,
}

/// Vertical sizing behavior for the sidebar container.
enum RailHeightMode {
  /// Stretches to fill the available parent height.
  full,

  /// Wraps tightly around the sidebar content.
  wrap,

  /// Uses an explicit pixel height.
  fixed,
}

/// Built-in visual presets for the navigation rail.
enum RailPreset {
  /// Dark charcoal rail with neutral highlight and slide indicator.
  obsidian,

  /// Light white rail with soft indigo highlight and dark labels.
  snow,

  /// Deep indigo rail with brand accent and visible footer slot.
  indigo,

  /// Tightly wrapped dark rail with narrower expanded width.
  compact;

  /// Short display name shown on preset buttons.
  String get label => switch (this) {
        RailPreset.obsidian => 'Obsidian',
        RailPreset.snow => 'Snow',
        RailPreset.indigo => 'Indigo',
        RailPreset.compact => 'Compact',
      };

  /// Swatch fill representing the rail surface.
  Color get previewColor => switch (this) {
        RailPreset.obsidian => const Color(0xFF161B22),
        RailPreset.snow => const Color(0xFFFFFFFF),
        RailPreset.indigo => const Color(0xFF1E1B4B),
        RailPreset.compact => const Color(0xFF27272A),
      };

  /// Swatch ring representing the preset accent.
  Color get accentColor => switch (this) {
        RailPreset.obsidian => const Color(0xFF6366F1),
        RailPreset.snow => const Color(0xFF4F46E5),
        RailPreset.indigo => const Color(0xFF818CF8),
        RailPreset.compact => const Color(0xFF10B981),
      };
}
