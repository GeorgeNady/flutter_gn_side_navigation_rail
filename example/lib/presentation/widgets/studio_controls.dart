import 'package:flutter/material.dart';

import '../theme/studio_theme.dart';

/// Muted section heading for grouping related inspector controls.
class StudioSectionLabel extends StatelessWidget {
  /// Heading text.
  final String title;

  /// Outer padding around the heading.
  final EdgeInsetsGeometry padding;

  /// Creates a section heading.
  const StudioSectionLabel(
    this.title, {
    super.key,
    this.padding = const EdgeInsets.only(top: 16, bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    return Semantics(
      header: true,
      child: Padding(
        padding: padding,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

/// Labeled slider control with a tabular monospace value readout.
class StudioSliderRow extends StatelessWidget {
  /// Control label.
  final String label;

  /// Current numeric value.
  final double value;

  /// Minimum allowed value.
  final double min;

  /// Maximum allowed value.
  final double max;

  /// Number of discrete slider steps.
  final int divisions;

  /// Formatted text displayed beside [label].
  final String valueLabel;

  /// Called when the user drags the slider.
  final ValueChanged<double> onChanged;

  /// Creates a labeled slider row.
  const StudioSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Text(
                  valueLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: valueLabel,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Accessible switch row with a single focus stop and 48dp minimum height.
class StudioSwitchRow extends StatelessWidget {
  /// Primary row title.
  final String title;

  /// Optional helper text shown below [title].
  final String? subtitle;

  /// Whether the switch is currently enabled.
  final bool value;

  /// Called when the row or switch is toggled.
  final ValueChanged<bool> onChanged;

  /// Creates an accessible switch row.
  const StudioSwitchRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    return Semantics(
      toggled: value,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ExcludeFocus(
                  child: ExcludeSemantics(
                    child: Switch(
                      value: value,
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bordered dropdown row that adapts cleanly to narrow widths and large text.
class StudioDropdownRow<T> extends StatelessWidget {
  /// Control label.
  final String label;

  /// Currently selected value.
  final T value;

  /// Available dropdown menu items.
  final List<DropdownMenuItem<T>> items;

  /// Called when the user selects a new value.
  final ValueChanged<T?> onChanged;

  /// Creates a labeled dropdown row.
  const StudioDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.controlBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  itemHeight: null,
                  dropdownColor: colors.surface,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: colors.textSecondary,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textPrimary,
                  ),
                  items: items,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact color token row with an expandable inline swatch picker.
class StudioColorTokenTile extends StatelessWidget {
  /// Token display label.
  final String label;

  /// Current selected color.
  final Color color;

  /// Whether the inline swatch grid is expanded.
  final bool isExpanded;

  /// Called when the row header is tapped to expand or collapse the grid.
  final VoidCallback onToggle;

  /// Called when the user picks a swatch color.
  final ValueChanged<Color> onSelect;

  /// Creates a color token row.
  const StudioColorTokenTile({
    super.key,
    required this.label,
    required this.color,
    required this.isExpanded,
    required this.onToggle,
    required this.onSelect,
  });

  String _formatHex(Color c) {
    final argb = c.toARGB32();
    final alpha = (argb >> 24) & 0xFF;
    final rgb =
        (argb & 0x00FFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
    if (alpha == 0xFF) return '#$rgb';
    final alphaPct = ((alpha / 255) * 100).round();
    return '#$rgb ($alphaPct%)';
  }

  Color _bestContrastInk(Color swatch, Color backdrop) {
    final composed = Color.alphaBlend(swatch, backdrop);
    return composed.computeLuminance() > 0.179
        ? const Color(0xFF0F172A)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final hexLabel = _formatHex(color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: isExpanded,
          excludeSemantics: true,
          label: '$label, color $hexLabel',
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colors.controlBorder),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      hexLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontFamily: 'monospace',
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10, left: 2),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.controlBorder),
                    ),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: StudioPalette.swatches.map((swatch) {
                        final isSelected =
                            swatch.color.toARGB32() == color.toARGB32();
                        final checkColor = _bestContrastInk(
                          swatch.color,
                          colors.surfaceElevated,
                        );
                        return Tooltip(
                          message: swatch.name,
                          excludeFromSemantics: true,
                          child: Semantics(
                            button: true,
                            selected: isSelected,
                            excludeSemantics: true,
                            label: swatch.name,
                            child: InkWell(
                              onTap: () => onSelect(swatch.color),
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: swatch.color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? colors.accentForeground
                                            : colors.controlBorder,
                                        width: isSelected ? 2.5 : 1,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 15,
                                            color: checkColor,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
