import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../bloc/playground_bloc.dart';
import '../bloc/playground_event.dart';
import '../bloc/playground_state.dart';
import '../theme/studio_theme.dart';

/// Displays generated Dart project files and triggers ZIP exports via BLoC.
class CodeExportView extends StatefulWidget {
  /// Creates a code export view.
  const CodeExportView({super.key});

  @override
  State<CodeExportView> createState() => _CodeExportViewState();
}

class _CodeExportViewState extends State<CodeExportView> {
  bool _copied = false;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _copyActiveFile(String fileName, String content) {
    Clipboard.setData(ClipboardData(text: content)).catchError((Object _) {});
    _copyTimer?.cancel();
    setState(() => _copied = true);
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Copied $fileName to clipboard'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    final bloc = context.read<PlaygroundBloc>();

    return BlocConsumer<PlaygroundBloc, PlaygroundState>(
      listenWhen: (previous, current) =>
          previous.isExportingZip && !current.isExportingZip,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
        if (state.lastExportError != null) {
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFB91C1C),
              content: Text(
                'Failed to export ZIP: ${state.lastExportError}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
          return;
        }
        if (state.lastExportSavedPath != null) {
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF065F46),
              content: Text(
                'Exported ${state.generatedFiles.length} files to: ${state.lastExportSavedPath}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final files = state.generatedFiles;
        final fileNames = files.keys.toList();
        final activeFileKey = files.containsKey(state.selectedExportFile)
            ? state.selectedExportFile
            : fileNames.first;
        final activeFileContent = files[activeFileKey] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<ExportArchitecture>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: ExportArchitecture.stateful,
                  icon: Icon(Icons.widgets_outlined, size: 16),
                  label: Text('StatefulWidget'),
                ),
                ButtonSegment(
                  value: ExportArchitecture.bloc,
                  icon: Icon(Icons.account_tree_outlined, size: 16),
                  label: Text('BLoC'),
                ),
              ],
              selected: {state.exportArchitecture},
              onSelectionChanged: (selection) {
                bloc.add(PlaygroundExportArchitectureChanged(selection.first));
              },
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: fileNames.map((fileName) {
                  final isSelected = fileName == activeFileKey;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        fileName,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) =>
                          bloc.add(PlaygroundExportFileSelected(fileName)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.codeSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 4, 6, 4),
                      decoration: BoxDecoration(
                        color: colors.codeHeader,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 14,
                            color: colors.codeForeground.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              activeFileKey,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                color: colors.codeForeground,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: _copied
                                  ? const Color(0xFF34D399)
                                  : colors.codeForeground,
                              minimumSize: const Size(48, 48),
                              tapTargetSize: MaterialTapTargetSize.padded,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () =>
                                _copyActiveFile(activeFileKey, activeFileContent),
                            icon: Icon(
                              _copied ? Icons.check : Icons.copy_outlined,
                              size: 14,
                            ),
                            label: Text(
                              _copied ? 'Copied' : 'Copy',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(14),
                        child: SelectableText(
                          activeFileContent,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5,
                            color: colors.codeForeground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.lastExportSavedPath != null) ...[
              const SizedBox(height: 10),
              Semantics(
                container: true,
                liveRegion: true,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.success.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 15,
                        color: colors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Saved: ${state.lastExportSavedPath}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: state.isExportingZip
                  ? null
                  : () => bloc.add(const PlaygroundZipExportRequested()),
              icon: state.isExportingZip
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                    )
                  : const Icon(Icons.folder_zip_outlined, size: 18),
              label: Text(
                state.isExportingZip ? 'Exporting...' : 'Export .ZIP',
              ),
            ),
          ],
        );
      },
    );
  }
}
