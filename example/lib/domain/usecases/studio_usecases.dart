import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../entities/studio_enums.dart';
import '../repositories/code_export_repository.dart';
import '../repositories/rail_preset_repository.dart';

/// Generates project source files for a given sidebar configuration.
class GenerateProjectFilesUseCase {
  final CodeExportRepository _repository;

  /// Creates a use case backed by [repository].
  const GenerateProjectFilesUseCase(this._repository);

  /// Generates a map of relative file paths to source contents.
  Map<String, String> call({
    required SideBarExportConfig config,
    required ExportArchitecture architecture,
  }) {
    return _repository.generateFiles(
      config: config,
      architecture: architecture,
    );
  }
}

/// Exports generated project source files to a downloadable ZIP archive.
class ExportProjectZipUseCase {
  final CodeExportRepository _repository;

  /// Creates a use case backed by [repository].
  const ExportProjectZipUseCase(this._repository);

  /// Builds and saves a ZIP archive for [config] and [architecture].
  ///
  /// Returns the saved file path or archive name.
  Future<String> call({
    required SideBarExportConfig config,
    required ExportArchitecture architecture,
  }) {
    final files = _repository.generateFiles(
      config: config,
      architecture: architecture,
    );
    return _repository.exportZip(files: files, architecture: architecture);
  }
}

/// Resolves preset configurations and default sidebar items.
class ApplyRailPresetUseCase {
  final RailPresetRepository _repository;

  /// Creates a use case backed by [repository].
  const ApplyRailPresetUseCase(this._repository);

  /// Returns a fresh list of default navigation items.
  List<SideBarItem> defaultItems() => _repository.getDefaultItems();

  /// Builds a [SideBarExportConfig] for [preset] preserving [items].
  SideBarExportConfig call(RailPreset preset, List<SideBarItem> items) {
    return _repository.buildPreset(preset, items);
  }
}
