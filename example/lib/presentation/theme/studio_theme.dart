import 'package:flutter/material.dart';

/// Semantic color tokens shared across the studio light and dark themes.
class StudioColors extends ThemeExtension<StudioColors> {
  /// Root scaffold background color.
  final Color canvas;

  /// Primary panel and card background color.
  final Color surface;

  /// Subtle elevated background for segmented controls and swatches.
  final Color surfaceElevated;

  /// Background color for the monospace code viewer.
  final Color codeSurface;

  /// Header bar background color inside the code viewer.
  final Color codeHeader;

  /// Foreground text color inside the code viewer.
  final Color codeForeground;

  /// Structural divider and card border color.
  final Color border;

  /// Hairline divider color between list rows.
  final Color borderSubtle;

  /// High-contrast border color for interactive form controls.
  final Color controlBorder;

  /// Primary text color.
  final Color textPrimary;

  /// Secondary muted text color.
  final Color textSecondary;

  /// Filled accent color for primary buttons and active segments.
  final Color accent;

  /// High-contrast accent color for icons, sliders, and links.
  final Color accentForeground;

  /// Tinted surface behind selected chips and badges.
  final Color accentMuted;

  /// Positive status color for deltas and confirmations.
  final Color success;

  /// Destructive action and error color.
  final Color danger;

  /// Creates a set of studio semantic colors.
  const StudioColors({
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.codeSurface,
    required this.codeHeader,
    required this.codeForeground,
    required this.border,
    required this.borderSubtle,
    required this.controlBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentForeground,
    required this.accentMuted,
    required this.success,
    required this.danger,
  });

  /// Resolves [StudioColors] from the nearest [Theme].
  static StudioColors of(BuildContext context) {
    final ext = Theme.of(context).extension<StudioColors>();
    assert(ext != null, 'StudioColors ThemeExtension is missing from ThemeData');
    return ext!;
  }

  /// Dark studio color tokens.
  static const darkTokens = StudioColors(
    canvas: Color(0xFF0B0F17),
    surface: Color(0xFF111827),
    surfaceElevated: Color(0xFF1A2233),
    codeSurface: Color(0xFF090D14),
    codeHeader: Color(0xFF131B2A),
    codeForeground: Color(0xFFE2E8F0),
    border: Color(0xFF263145),
    borderSubtle: Color(0xFF1C2536),
    controlBorder: Color(0xFF64748B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    accent: Color(0xFF4F46E5),
    accentForeground: Color(0xFF818CF8),
    accentMuted: Color(0x296366F1),
    success: Color(0xFF34D399),
    danger: Color(0xFFF87171),
  );

  /// Light studio color tokens.
  static const lightTokens = StudioColors(
    canvas: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF1F5F9),
    codeSurface: Color(0xFF0F172A),
    codeHeader: Color(0xFF1E293B),
    codeForeground: Color(0xFFE2E8F0),
    border: Color(0xFFE2E8F0),
    borderSubtle: Color(0xFFF1F5F9),
    controlBorder: Color(0xFF64748B),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    accent: Color(0xFF4F46E5),
    accentForeground: Color(0xFF4338CA),
    accentMuted: Color(0xFFEEF2FF),
    success: Color(0xFF047857),
    danger: Color(0xFFB91C1C),
  );

  @override
  StudioColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceElevated,
    Color? codeSurface,
    Color? codeHeader,
    Color? codeForeground,
    Color? border,
    Color? borderSubtle,
    Color? controlBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? accentForeground,
    Color? accentMuted,
    Color? success,
    Color? danger,
  }) {
    return StudioColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      codeSurface: codeSurface ?? this.codeSurface,
      codeHeader: codeHeader ?? this.codeHeader,
      codeForeground: codeForeground ?? this.codeForeground,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      controlBorder: controlBorder ?? this.controlBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      accentMuted: accentMuted ?? this.accentMuted,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  StudioColors lerp(covariant ThemeExtension<StudioColors>? other, double t) {
    if (other is! StudioColors) return this;
    return StudioColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      codeSurface: Color.lerp(codeSurface, other.codeSurface, t)!,
      codeHeader: Color.lerp(codeHeader, other.codeHeader, t)!,
      codeForeground: Color.lerp(codeForeground, other.codeForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      controlBorder: Color.lerp(controlBorder, other.controlBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground:
          Color.lerp(accentForeground, other.accentForeground, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

/// Builds Material 3 light and dark themes for the studio app.
class StudioTheme {
  /// Returns the dark [ThemeData] for the studio.
  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        tokens: StudioColors.darkTokens,
      );

  /// Returns the light [ThemeData] for the studio.
  static ThemeData light() => _build(
        brightness: Brightness.light,
        tokens: StudioColors.lightTokens,
      );

  static ThemeData _build({
    required Brightness brightness,
    required StudioColors tokens,
  }) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.accent,
      onPrimary: Colors.white,
      primaryContainer: tokens.accentMuted,
      onPrimaryContainer:
          isDark ? const Color(0xFFE0E7FF) : tokens.accentForeground,
      secondary: tokens.surfaceElevated,
      onSecondary: tokens.textPrimary,
      secondaryContainer: tokens.surfaceElevated,
      onSecondaryContainer: tokens.textPrimary,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
      surfaceContainerHighest: tokens.surfaceElevated,
      onSurfaceVariant: tokens.textSecondary,
      error: tokens.danger,
      onError: Colors.white,
      outline: tokens.controlBorder,
      outlineVariant: tokens.borderSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.canvas,
      dividerColor: tokens.border,
      focusColor: tokens.accentForeground.withValues(alpha: 0.28),
      extensions: [tokens],
      dividerTheme: DividerThemeData(
        color: tokens.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: tokens.textSecondary, size: 20),
      sliderTheme: SliderThemeData(
        activeTrackColor: tokens.accentForeground,
        inactiveTrackColor: tokens.controlBorder,
        thumbColor: tokens.accentForeground,
        overlayColor: tokens.accentForeground.withValues(alpha: 0.16),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return tokens.controlBorder;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.accent;
          return tokens.surfaceElevated;
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.accent;
            }
            return tokens.surfaceElevated;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return tokens.textPrimary;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: tokens.controlBorder)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceElevated,
        selectedColor: tokens.accentMuted,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: tokens.textPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFE0E7FF) : tokens.accentForeground,
        ),
        side: BorderSide(color: tokens.controlBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.textPrimary,
          side: BorderSide(color: tokens.controlBorder),
          minimumSize: const Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.padded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

/// Named color option shown in the inline swatch picker.
class StudioSwatch {
  /// Swatch color value.
  final Color color;

  /// Accessible display name shown in tooltips and screen readers.
  final String name;

  /// Creates a named color swatch.
  const StudioSwatch(this.color, this.name);
}

/// Curated color swatches available in the inspector color pickers.
class StudioPalette {
  /// Default twelve-swatch palette covering neutrals, accents, and subtle ink.
  static const List<StudioSwatch> swatches = [
    StudioSwatch(Color(0xFF161B22), 'Obsidian'),
    StudioSwatch(Color(0xFF252D3A), 'Graphite'),
    StudioSwatch(Color(0xFF1E1B4B), 'Midnight Indigo'),
    StudioSwatch(Color(0xFF4F46E5), 'Indigo'),
    StudioSwatch(Color(0xFF2563EB), 'Cobalt'),
    StudioSwatch(Color(0xFF059669), 'Emerald'),
    StudioSwatch(Color(0xFFD97706), 'Amber'),
    StudioSwatch(Color(0xFFE11D48), 'Rose'),
    StudioSwatch(Color(0xFF94A3B8), 'Cool Slate'),
    StudioSwatch(Color(0xFF475569), 'Slate Gray'),
    StudioSwatch(Color(0xFFFFFFFF), 'Snow White'),
    StudioSwatch(Color(0x2E000000), 'Subtle Ink'),
  ];
}
