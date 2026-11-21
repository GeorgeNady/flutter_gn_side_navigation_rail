# GN Side Navigation Rail example

This example app is an interactive playground and code exporter for `flutter_gn_side_navigation_rail`. You can edit rail presets, colors, dimensions, transitions, header and footer slots, and navigation items, then copy or export a runnable Flutter project as a StatefulWidget or BLoC app.

## Folder layout

The example module splits code into three layers under `lib/`:

```text
lib/
├── main.dart
├── domain/
│   ├── entities/
│   │   └── studio_enums.dart
│   ├── repositories/
│   │   ├── code_export_repository.dart
│   │   └── rail_preset_repository.dart
│   └── usecases/
│       └── studio_usecases.dart
├── data/
│   └── repositories/
│       ├── default_rail_preset_repository.dart
│       └── side_bar_code_export_repository.dart
└── presentation/
    ├── bloc/
    │   ├── playground_bloc.dart
    │   ├── playground_event.dart
    │   └── playground_state.dart
    ├── theme/
    │   └── studio_theme.dart
    └── widgets/
        ├── code_export_view.dart
        ├── inspector_panel.dart
        ├── live_navigation_rail.dart
        ├── preview_stage.dart
        └── studio_controls.dart
```

## How state flows

`PlaygroundBloc` holds the current `SideBarExportConfig`, active preset, theme mode, inspector tabs, and generated files inside a single immutable `PlaygroundState`. Widgets read state through `BlocBuilder`, `BlocSelector`, and `BlocConsumer`, and send user actions back as sealed `PlaygroundEvent` classes.

When `config` or `exportArchitecture` changes, `PlaygroundBloc` runs `GenerateProjectFilesUseCase` once and stores the updated file map in state. The code pane renders that map directly without regenerating Dart strings during widget builds.

## SOLID boundaries

Each file owns one job. `LiveNavigationRail` renders `SideBarAnimated`, `PreviewStage` renders the active destination screen, `InspectorPanel` edits settings, and `CodeExportView` previews and exports generated files.

`PlaygroundBloc` and the domain use cases depend on the abstract `CodeExportRepository` and `RailPresetRepository` interfaces. `MyApp` accepts optional repository overrides in its constructor, so tests or custom builds can swap in another preset catalog or export backend without editing the BLoC or UI widgets.

## Running the app and tests

```sh
flutter pub get
flutter run
```

Run static analysis and all widget and BLoC tests from the `example/` directory:

```sh
flutter analyze
flutter test
```
