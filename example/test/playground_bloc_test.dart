import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import 'package:example/data/repositories/default_rail_preset_repository.dart';
import 'package:example/domain/entities/studio_enums.dart';
import 'package:example/domain/repositories/code_export_repository.dart';
import 'package:example/domain/usecases/studio_usecases.dart';
import 'package:example/presentation/bloc/playground_bloc.dart';
import 'package:example/presentation/bloc/playground_event.dart';

class _FakeCodeExportRepository implements CodeExportRepository {
  int generateCalls = 0;
  int exportCalls = 0;
  bool shouldThrowOnExport = false;

  @override
  Map<String, String> generateFiles({
    required SideBarExportConfig config,
    required ExportArchitecture architecture,
  }) {
    generateCalls++;
    return {
      'lib/main.dart':
          '// arch=${architecture.name} header=${config.showHeaderWidget} footer=${config.showFooterWidget}',
      if (architecture == ExportArchitecture.bloc)
        'lib/bloc/navigation_bloc.dart': '// bloc',
    };
  }

  @override
  Future<String> exportZip({
    required Map<String, String> files,
    required ExportArchitecture architecture,
  }) async {
    exportCalls++;
    if (shouldThrowOnExport) {
      throw StateError('Disk full');
    }
    return '/tmp/fake_${architecture.name}.zip';
  }
}

void main() {
  group('PlaygroundBloc (Clean Architecture & DIP)', () {
    late _FakeCodeExportRepository fakeExportRepo;
    late PlaygroundBloc bloc;

    setUp(() {
      fakeExportRepo = _FakeCodeExportRepository();
      const presetRepo = DefaultRailPresetRepository();
      bloc = PlaygroundBloc(
        applyPreset: const ApplyRailPresetUseCase(presetRepo),
        generateFiles: GenerateProjectFilesUseCase(fakeExportRepo),
        exportZip: ExportProjectZipUseCase(fakeExportRepo),
      );
    });

    tearDown(() => bloc.close());

    test('loads Obsidian preset and initial generated files on creation', () {
      expect(bloc.state.activePreset, RailPreset.obsidian);
      expect(bloc.state.themeMode, ThemeMode.dark);
      expect(bloc.state.config.showHeaderWidget, isTrue);
      expect(bloc.state.config.showFooterWidget, isFalse);
      expect(bloc.state.generatedFiles['lib/main.dart'], contains('header=true'));
      expect(fakeExportRepo.generateCalls, 1);
    });

    test('applies presets, updates config, and regenerates exported files',
        () async {
      bloc.add(const PlaygroundPresetApplied(RailPreset.indigo));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.activePreset, RailPreset.indigo);
      expect(bloc.state.config.showFooterWidget, isTrue);
      expect(
        bloc.state.generatedFiles['lib/main.dart'],
        contains('footer=true'),
      );

      bloc.add(const PlaygroundExportArchitectureChanged(ExportArchitecture.bloc));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.exportArchitecture, ExportArchitecture.bloc);
      expect(
        bloc.state.generatedFiles.containsKey('lib/bloc/navigation_bloc.dart'),
        isTrue,
      );
    });

    test('exports ZIP through injected repository and handles failures cleanly',
        () async {
      bloc.add(const PlaygroundZipExportRequested());
      await Future<void>.delayed(Duration.zero);

      expect(fakeExportRepo.exportCalls, 1);
      expect(bloc.state.isExportingZip, isFalse);
      expect(bloc.state.lastExportSavedPath, '/tmp/fake_stateful.zip');
      expect(bloc.state.lastExportError, isNull);

      fakeExportRepo.shouldThrowOnExport = true;
      bloc.add(const PlaygroundZipExportRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.isExportingZip, isFalse);
      expect(bloc.state.lastExportError, contains('Disk full'));
    });
  });
}
