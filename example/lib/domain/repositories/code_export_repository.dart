import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

/// Contract for generating Dart source files and exporting ZIP archives.
abstract interface class CodeExportRepository {
  /// Generates runnable project files for [config] using [architecture].
  Map<String, String> generateFiles({
    required SideBarExportConfig config,
    required ExportArchitecture architecture,
  });

  /// Packages [files] into a ZIP archive and returns the saved path or file name.
  Future<String> exportZip({
    required Map<String, String> files,
    required ExportArchitecture architecture,
  });
}
