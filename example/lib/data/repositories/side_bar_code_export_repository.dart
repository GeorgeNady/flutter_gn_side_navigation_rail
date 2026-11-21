import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../../domain/repositories/code_export_repository.dart';

/// Generates Dart code and ZIP archives using `side_bar_code_exporter`.
class SideBarCodeExportRepository implements CodeExportRepository {
  /// Creates a repository backed by [CodeExportGenerator] and [ZipExporter].
  const SideBarCodeExportRepository();

  @override
  Map<String, String> generateFiles({
    required SideBarExportConfig config,
    required ExportArchitecture architecture,
  }) {
    return architecture == ExportArchitecture.stateful
        ? CodeExportGenerator.generateStatefulFiles(config)
        : CodeExportGenerator.generateBlocFiles(config);
  }

  @override
  Future<String> exportZip({
    required Map<String, String> files,
    required ExportArchitecture architecture,
  }) async {
    final zipName = architecture == ExportArchitecture.stateful
        ? 'gn_side_nav_stateful_export.zip'
        : 'gn_side_nav_bloc_export.zip';
    final savedPath = await ZipExporter.exportZipFile(
      files: files,
      fileName: zipName,
    );
    return savedPath ?? zipName;
  }
}
