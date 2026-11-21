import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

import '../../domain/entities/studio_enums.dart';
import '../bloc/playground_bloc.dart';
import '../bloc/playground_event.dart';
import '../bloc/playground_state.dart';
import '../theme/studio_theme.dart';
import 'code_export_view.dart';
import 'studio_controls.dart';

/// Right-hand studio inspector switching between Customize controls and Code export.
class InspectorPanel extends StatefulWidget {
  /// Whether this panel is rendered inside a compact drawer.
  final bool isDrawer;

  /// Called when the user closes the compact drawer.
  final VoidCallback? onClose;

  /// Creates an inspector panel.
  const InspectorPanel({
    super.key,
    this.isDrawer = false,
    this.onClose,
  });

  @override
  State<InspectorPanel> createState() => _InspectorPanelState();
}

class _InspectorPanelState extends State<InspectorPanel> {
  String? _expandedColorKey;

  void _toggleColorKey(String key) {
    setState(() {
      _expandedColorKey = _expandedColorKey == key ? null : key;
    });
  }

  void _updateConfig(BuildContext context, SideBarExportConfig config) {
    context.read<PlaygroundBloc>().add(PlaygroundConfigUpdated(config));
  }

  String _transitionLabel(SideBarTransitionType type) => switch (type) {
        SideBarTransitionType.slide => 'Slide',
        SideBarTransitionType.fade => 'Fade',
        SideBarTransitionType.scale => 'Scale',
        SideBarTransitionType.fadeSlide => 'Fade + Slide',
        SideBarTransitionType.none => 'None',
        SideBarTransitionType.custom => 'Custom',
      };

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);

    return BlocBuilder<PlaygroundBloc, PlaygroundState>(
      builder: (context, state) {
        return SafeArea(
          left: false,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              border: widget.isDrawer
                  ? null
                  : Border(left: BorderSide(color: colors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopHeader(context, colors, state),
                Divider(height: 1, color: colors.border),
                if (state.inspectorMode == InspectorMode.code)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CodeExportView(),
                    ),
                  )
                else ...[
                  _buildPresetsStrip(context, colors, state),
                  _buildTabStrip(context, colors, state),
                  Divider(height: 1, color: colors.borderSubtle),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        _buildActiveTabContent(context, state),
                        const SizedBox(height: 16),
                        _buildAdvancedDisclosure(context, colors, state),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    StudioColors colors,
    PlaygroundState state,
  ) {
    final bloc = context.read<PlaygroundBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<InspectorMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: InspectorMode.customize,
                  icon: Icon(Icons.tune, size: 16),
                  label: Text('Customize'),
                ),
                ButtonSegment(
                  value: InspectorMode.code,
                  icon: Icon(Icons.code, size: 16),
                  label: Text('Code'),
                ),
              ],
              selected: {state.inspectorMode},
              onSelectionChanged: (selection) {
                bloc.add(PlaygroundInspectorModeChanged(selection.first));
              },
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Reset defaults',
            onPressed: () => bloc.add(const PlaygroundResetRequested()),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.restart_alt, size: 20, color: colors.textSecondary),
          ),
          if (widget.isDrawer)
            IconButton(
              tooltip: 'Close inspector',
              onPressed: widget.onClose,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: Icon(Icons.close, size: 20, color: colors.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetsStrip(
    BuildContext context,
    StudioColors colors,
    PlaygroundState state,
  ) {
    final bloc = context.read<PlaygroundBloc>();
    final isLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;

    Widget buildPresetChip(RailPreset preset) {
      final isSelected = state.activePreset == preset;
      return Semantics(
        button: true,
        selected: isSelected,
        excludeSemantics: true,
        label: '${preset.label} preset',
        child: InkWell(
          onTap: () => bloc.add(PlaygroundPresetApplied(preset)),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colors.accentMuted : colors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    isSelected ? colors.accentForeground : colors.controlBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: isLargeText ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: preset.previewColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: preset.accentColor,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    preset.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: isLargeText
          ? Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RailPreset.values.map(buildPresetChip).toList(),
            )
          : Row(
              children: [
                for (var i = 0; i < RailPreset.values.length; i++) ...[
                  Expanded(child: buildPresetChip(RailPreset.values[i])),
                  if (i < RailPreset.values.length - 1)
                    const SizedBox(width: 6),
                ],
              ],
            ),
    );
  }

  Widget _buildTabStrip(
    BuildContext context,
    StudioColors colors,
    PlaygroundState state,
  ) {
    final bloc = context.read<PlaygroundBloc>();
    const tabs = [
      (CustomizeTab.style, 'Style'),
      (CustomizeTab.layout, 'Layout'),
      (CustomizeTab.motion, 'Motion'),
      (CustomizeTab.items, 'Items'),
    ];
    final isLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;

    final tabWidgets = tabs.map((entry) {
      final tab = entry.$1;
      final label = entry.$2;
      final isSelected = state.customizeTab == tab;
      final item = Semantics(
        button: true,
        selected: isSelected,
        excludeSemantics: true,
        label: '$label tab',
        child: InkWell(
          onTap: () => bloc.add(PlaygroundCustomizeTabChanged(tab)),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 68),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? colors.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border:
                  isSelected ? Border.all(color: colors.controlBorder) : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ),
        ),
      );
      return isLargeText ? item : Expanded(child: item);
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: isLargeText
            ? Wrap(
                spacing: 4,
                runSpacing: 4,
                children: tabWidgets,
              )
            : Row(children: tabWidgets),
      ),
    );
  }

  Widget _buildActiveTabContent(BuildContext context, PlaygroundState state) {
    switch (state.customizeTab) {
      case CustomizeTab.style:
        return _buildStyleTab(context, state);
      case CustomizeTab.layout:
        return _buildLayoutTab(context, state);
      case CustomizeTab.motion:
        return _buildMotionTab(context, state);
      case CustomizeTab.items:
        return _buildItemsTab(context, state);
    }
  }

  Widget _buildStyleTab(BuildContext context, PlaygroundState state) {
    final cfg = state.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StudioSectionLabel(
          'Header, Footer & Chrome',
          padding: EdgeInsets.only(top: 6, bottom: 4),
        ),
        StudioSwitchRow(
          title: 'Show Header',
          subtitle: 'Brand logo and workspace title',
          value: cfg.showHeaderWidget,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(showHeaderWidget: v)),
        ),
        StudioSwitchRow(
          title: 'Show Footer',
          subtitle: 'Bottom profile slot',
          value: cfg.showFooterWidget,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(showFooterWidget: v)),
        ),
        StudioSwitchRow(
          title: 'Collapse Toggle',
          subtitle: 'Built-in expand and collapse button',
          value: cfg.showToggleButton,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(showToggleButton: v)),
        ),
        StudioSwitchRow(
          title: 'Trailing Divider',
          subtitle: 'Separator before final navigation item',
          value: cfg.settingsDivider,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(settingsDivider: v)),
        ),
        const StudioSectionLabel('Colors'),
        StudioColorTokenTile(
          label: 'Sidebar Surface',
          color: cfg.sideBarColor,
          isExpanded: _expandedColorKey == 'sideBarColor',
          onToggle: () => _toggleColorKey('sideBarColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(sideBarColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Active Indicator',
          color: cfg.animatedContainerColor,
          isExpanded: _expandedColorKey == 'animatedContainerColor',
          onToggle: () => _toggleColorKey('animatedContainerColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(animatedContainerColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Active Icon',
          color: cfg.selectedIconColor,
          isExpanded: _expandedColorKey == 'selectedIconColor',
          onToggle: () => _toggleColorKey('selectedIconColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(selectedIconColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Inactive Icon',
          color: cfg.unselectedIconColor,
          isExpanded: _expandedColorKey == 'unselectedIconColor',
          onToggle: () => _toggleColorKey('unselectedIconColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(unselectedIconColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Inactive Label',
          color: cfg.unSelectedTextColor,
          isExpanded: _expandedColorKey == 'unSelectedTextColor',
          onToggle: () => _toggleColorKey('unSelectedTextColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(unSelectedTextColor: c)),
        ),
      ],
    );
  }

  Widget _buildLayoutTab(BuildContext context, PlaygroundState state) {
    final bloc = context.read<PlaygroundBloc>();
    final cfg = state.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StudioSectionLabel(
          'Height Mode',
          padding: EdgeInsets.only(top: 6, bottom: 8),
        ),
        SegmentedButton<RailHeightMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: RailHeightMode.full, label: Text('Full')),
            ButtonSegment(value: RailHeightMode.wrap, label: Text('Wrap')),
            ButtonSegment(value: RailHeightMode.fixed, label: Text('Fixed')),
          ],
          selected: {state.heightMode},
          onSelectionChanged: (selection) =>
              bloc.add(PlaygroundHeightModeChanged(selection.first)),
        ),
        if (cfg.useCustomHeight) ...[
          const SizedBox(height: 8),
          StudioSliderRow(
            label: 'Fixed Height',
            value: cfg.customHeight,
            min: 200,
            max: 900,
            divisions: 70,
            valueLabel: '${cfg.customHeight.round()} px',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(customHeight: v)),
          ),
        ],
        const StudioSectionLabel('Dimensions'),
        StudioSliderRow(
          label: 'Expanded Width',
          value: cfg.sideBarWidth,
          min: 180,
          max: 420,
          divisions: 48,
          valueLabel: '${cfg.sideBarWidth.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(sideBarWidth: v)),
        ),
        StudioSliderRow(
          label: 'Collapsed Width',
          value: cfg.sideBarSmallWidth,
          min: 64,
          max: 150,
          divisions: 43,
          valueLabel: '${cfg.sideBarSmallWidth.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(sideBarSmallWidth: v)),
        ),
        StudioSliderRow(
          label: 'Outer Radius',
          value: cfg.borderRadius,
          min: 0,
          max: 48,
          divisions: 48,
          valueLabel: '${cfg.borderRadius.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(borderRadius: v)),
        ),
        StudioSliderRow(
          label: 'Item Radius',
          value: cfg.itemBorderRadiusValue,
          min: 0,
          max: 36,
          divisions: 36,
          valueLabel: '${cfg.itemBorderRadiusValue.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(itemBorderRadiusValue: v)),
        ),
        StudioSliderRow(
          label: 'Item Height',
          value: cfg.itemHeight,
          min: 36,
          max: 80,
          divisions: 44,
          valueLabel: '${cfg.itemHeight.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(itemHeight: v)),
        ),
        StudioSliderRow(
          label: 'Item Spacing',
          value: cfg.itemSpacing,
          min: 0,
          max: 32,
          divisions: 32,
          valueLabel: '${cfg.itemSpacing.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(itemSpacing: v)),
        ),
      ],
    );
  }

  Widget _buildMotionTab(BuildContext context, PlaygroundState state) {
    final cfg = state.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StudioSectionLabel(
          'Selection Transition',
          padding: EdgeInsets.only(top: 6, bottom: 8),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SideBarTransitionType.values.map((type) {
            final isSelected = cfg.transitionType == type;
            return ChoiceChip(
              showCheckmark: false,
              label: Text(_transitionLabel(type)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _updateConfig(context, cfg.copyWith(transitionType: type));
                }
              },
            );
          }).toList(),
        ),
        if (cfg.transitionType == SideBarTransitionType.custom) ...[
          const SizedBox(height: 10),
          StudioDropdownRow<String>(
            label: 'Custom Effect',
            value: cfg.customTransitionMode,
            items: const [
              DropdownMenuItem(
                value: 'rotateScale',
                child: Text('Rotate + Scale'),
              ),
              DropdownMenuItem(
                value: 'horizontalSlide',
                child: Text('Horizontal Slide'),
              ),
              DropdownMenuItem(
                value: 'sizeExpand',
                child: Text('Horizontal Reveal'),
              ),
            ],
            onChanged: (v) {
              if (v != null) {
                _updateConfig(context, cfg.copyWith(customTransitionMode: v));
              }
            },
          ),
        ],
        const StudioSectionLabel('Timing & Curves'),
        StudioSliderRow(
          label: 'Rail Speed',
          value: cfg.sideBarAnimationDurationMs.toDouble(),
          min: 50,
          max: 2000,
          divisions: 39,
          valueLabel: '${cfg.sideBarAnimationDurationMs} ms',
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(sideBarAnimationDurationMs: v.round()),
          ),
        ),
        StudioSliderRow(
          label: 'Indicator Speed',
          value: cfg.itemTransitionDurationMs.toDouble(),
          min: 50,
          max: 2000,
          divisions: 39,
          valueLabel: '${cfg.itemTransitionDurationMs} ms',
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(itemTransitionDurationMs: v.round()),
          ),
        ),
        const SizedBox(height: 4),
        StudioDropdownRow<String>(
          label: 'Rail Curve',
          value: cfg.curveKey,
          items: PlaygroundBloc.curveOptions.keys
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              _updateConfig(context, cfg.copyWith(curveKey: v));
            }
          },
        ),
        StudioDropdownRow<String>(
          label: 'Indicator Curve',
          value: cfg.itemTransitionCurveKey,
          items: PlaygroundBloc.curveOptions.keys
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              _updateConfig(context, cfg.copyWith(itemTransitionCurveKey: v));
            }
          },
        ),
      ],
    );
  }

  Widget _buildItemsTab(BuildContext context, PlaygroundState state) {
    final bloc = context.read<PlaygroundBloc>();
    final colors = StudioColors.of(context);
    final items = state.config.sidebarItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => bloc.add(const PlaygroundItemAdded()),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Item'),
              ),
              OutlinedButton.icon(
                onPressed: () => bloc.add(const PlaygroundItemsReset()),
                icon: const Icon(Icons.restore, size: 18),
                label: const Text('Reset'),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                    child: Row(
                      children: [
                        Icon(
                          item.iconSelected,
                          size: 18,
                          color: item.isDisabled
                              ? colors.textSecondary
                              : colors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.text,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: item.isDisabled
                                      ? colors.textSecondary
                                      : colors.textPrimary,
                                ),
                              ),
                              if (item.tooltip != null &&
                                  item.tooltip!.isNotEmpty)
                                Text(
                                  item.tooltip!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message:
                              item.isDisabled ? 'Enable item' : 'Disable item',
                          excludeFromSemantics: true,
                          child: Semantics(
                            label: 'Disable ${item.text}',
                            container: true,
                            child: Switch(
                              value: item.isDisabled,
                              onChanged: (_) => bloc
                                  .add(PlaygroundItemDisabledToggled(index)),
                            ),
                          ),
                        ),
                        if (items.length > 2)
                          IconButton(
                            tooltip: 'Remove ${item.text}',
                            constraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 48,
                            ),
                            onPressed: () =>
                                bloc.add(PlaygroundItemRemoved(index)),
                            icon: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: colors.danger,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: colors.borderSubtle),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedDisclosure(
    BuildContext context,
    StudioColors colors,
    PlaygroundState state,
  ) {
    final bloc = context.read<PlaygroundBloc>();
    final isExpanded = state.showAdvanced;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceElevated.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.controlBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: isExpanded,
            excludeSemantics: true,
            label: 'Advanced settings: Controller, typography, ink, fine-tuning',
            child: InkWell(
              onTap: () =>
                  bloc.add(PlaygroundAdvancedVisibilityChanged(!isExpanded)),
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Advanced',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Controller, typography, ink, fine-tuning',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
              child: _buildAdvancedBody(context, colors, state),
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedBody(
    BuildContext context,
    StudioColors colors,
    PlaygroundState state,
  ) {
    final bloc = context.read<PlaygroundBloc>();
    final cfg = state.config;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 1, color: colors.border),
        const StudioSectionLabel('Controller & Overrides'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildMiniBadge(
              colors,
              'Index',
              '${state.controllerSelectedIndex}',
            ),
            _buildMiniBadge(
              colors,
              'Minimized',
              '${state.controllerIsMinimized}',
            ),
            _buildMiniBadge(
              colors,
              'Last Tap',
              state.lastTappedIndex?.toString() ?? 'None',
            ),
            _buildMiniBadge(
              colors,
              'Last Callback',
              state.lastMinimizeCallbackValue?.toString() ?? 'None',
            ),
          ],
        ),
        const SizedBox(height: 8),
        StudioSwitchRow(
          title: 'Attach SideBarController',
          subtitle:
              'Disable to let SideBarAnimated manage state via initialIndex',
          value: cfg.useController,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(useController: v)),
        ),
        StudioSwitchRow(
          title: 'Explicit isMinimized Prop',
          subtitle: 'Drive collapse state directly via widget prop',
          value: cfg.useDirectIsMinimized,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(useDirectIsMinimized: v)),
        ),
        if (cfg.useDirectIsMinimized)
          StudioSwitchRow(
            title: 'Direct isMinimized Value',
            value: cfg.directIsMinimized,
            onChanged: (v) {
              _updateConfig(context, cfg.copyWith(directIsMinimized: v));
              if (cfg.useController) {
                bloc.sideBarController.setMinimized(v);
              }
            },
          ),
        StudioSliderRow(
          label: 'Initial Index',
          value: cfg.initialIndex.toDouble(),
          min: 0,
          max: (cfg.sidebarItems.length - 1).toDouble(),
          divisions: (cfg.sidebarItems.length - 1).clamp(1, 20),
          valueLabel: '${cfg.initialIndex}',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(initialIndex: v.round())),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed:
                  cfg.useController ? bloc.sideBarController.expand : null,
              child: const Text('Expand'),
            ),
            OutlinedButton(
              onPressed:
                  cfg.useController ? bloc.sideBarController.collapse : null,
              child: const Text('Collapse'),
            ),
            OutlinedButton(
              onPressed: cfg.useController
                  ? bloc.sideBarController.toggleMinimize
                  : null,
              child: const Text('Toggle'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        StudioDropdownRow<SideBarTransitionType>(
          label: 'Override Transition',
          value: state.overrideTransitionType,
          items: SideBarTransitionType.values
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(_transitionLabel(t)),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) {
              bloc.add(PlaygroundOverrideTransitionChanged(v));
            }
          },
        ),
        StudioDropdownRow<String>(
          label: 'Override Curve',
          value: state.overrideCurveKey,
          items: PlaygroundBloc.curveOptions.keys
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) {
            if (v != null) bloc.add(PlaygroundOverrideCurveChanged(v));
          },
        ),
        StudioSliderRow(
          label: 'Override Duration',
          value: state.overrideDurationMs.toDouble(),
          min: 0,
          max: 2000,
          divisions: 40,
          valueLabel: '${state.overrideDurationMs} ms',
          onChanged: (v) =>
              bloc.add(PlaygroundOverrideDurationChanged(v.round())),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(cfg.sidebarItems.length, (index) {
            final item = cfg.sidebarItems[index];
            final disableAnimations = MediaQuery.disableAnimationsOf(context);
            return Tooltip(
              message: 'Jump to ${item.text}',
              child: ActionChip(
                label: Text(item.text, style: const TextStyle(fontSize: 11.5)),
                onPressed: !cfg.useController || item.isDisabled
                    ? null
                    : () => bloc.sideBarController.selectIndex(
                          index,
                          transitionType: disableAnimations
                              ? SideBarTransitionType.none
                              : state.overrideTransitionType,
                          duration: disableAnimations
                              ? Duration.zero
                              : Duration(
                                  milliseconds: state.overrideDurationMs,
                                ),
                          curve: PlaygroundBloc
                              .curveOptions[state.overrideCurveKey],
                        ),
              ),
            );
          }),
        ),
        const StudioSectionLabel('Typography'),
        StudioSwitchRow(
          title: 'Custom Base TextStyle',
          value: cfg.useCustomTextStyle,
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(useCustomTextStyle: v)),
        ),
        if (cfg.useCustomTextStyle) ...[
          StudioSliderRow(
            label: 'Base Font Size',
            value: cfg.baseFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${cfg.baseFontSize.round()} pt',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(baseFontSize: v)),
          ),
          _buildFontWeightDropdown(
            label: 'Base Font Weight',
            value: cfg.baseFontWeight,
            onChanged: (w) =>
                _updateConfig(context, cfg.copyWith(baseFontWeight: w)),
          ),
        ],
        StudioSwitchRow(
          title: 'Custom Selected TextStyle',
          value: cfg.useCustomSelectedTextStyle,
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(useCustomSelectedTextStyle: v),
          ),
        ),
        if (cfg.useCustomSelectedTextStyle) ...[
          StudioSliderRow(
            label: 'Selected Font Size',
            value: cfg.selectedFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${cfg.selectedFontSize.round()} pt',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(selectedFontSize: v)),
          ),
          _buildFontWeightDropdown(
            label: 'Selected Font Weight',
            value: cfg.selectedFontWeight,
            onChanged: (w) =>
                _updateConfig(context, cfg.copyWith(selectedFontWeight: w)),
          ),
          StudioColorTokenTile(
            label: 'Selected Text Color',
            color: cfg.selectedTextColor,
            isExpanded: _expandedColorKey == 'selectedTextColor',
            onToggle: () => _toggleColorKey('selectedTextColor'),
            onSelect: (c) =>
                _updateConfig(context, cfg.copyWith(selectedTextColor: c)),
          ),
        ],
        StudioSwitchRow(
          title: 'Custom Disabled TextStyle',
          value: cfg.useCustomDisabledTextStyle,
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(useCustomDisabledTextStyle: v),
          ),
        ),
        if (cfg.useCustomDisabledTextStyle) ...[
          StudioSliderRow(
            label: 'Disabled Font Size',
            value: cfg.disabledFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${cfg.disabledFontSize.round()} pt',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(disabledFontSize: v)),
          ),
          StudioSwitchRow(
            title: 'Italicize Disabled Labels',
            value: cfg.disabledFontItalic,
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(disabledFontItalic: v)),
          ),
        ],
        const StudioSectionLabel('Interaction & Disabled Colors'),
        StudioColorTokenTile(
          label: 'Hover Ink',
          color: cfg.hoverColor,
          isExpanded: _expandedColorKey == 'hoverColor',
          onToggle: () => _toggleColorKey('hoverColor'),
          onSelect: (c) => _updateConfig(context, cfg.copyWith(hoverColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Splash Ink',
          color: cfg.splashColor,
          isExpanded: _expandedColorKey == 'splashColor',
          onToggle: () => _toggleColorKey('splashColor'),
          onSelect: (c) => _updateConfig(context, cfg.copyWith(splashColor: c)),
        ),
        StudioColorTokenTile(
          label: 'Highlight Ink',
          color: cfg.highlightColor,
          isExpanded: _expandedColorKey == 'highlightColor',
          onToggle: () => _toggleColorKey('highlightColor'),
          onSelect: (c) =>
              _updateConfig(context, cfg.copyWith(highlightColor: c)),
        ),
        StudioSwitchRow(
          title: 'Custom Disabled Icon Color',
          value: cfg.useCustomDisabledIconColor,
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(useCustomDisabledIconColor: v),
          ),
        ),
        if (cfg.useCustomDisabledIconColor)
          StudioColorTokenTile(
            label: 'Disabled Icon Color',
            color: cfg.disabledIconColor,
            isExpanded: _expandedColorKey == 'disabledIconColor',
            onToggle: () => _toggleColorKey('disabledIconColor'),
            onSelect: (c) =>
                _updateConfig(context, cfg.copyWith(disabledIconColor: c)),
          ),
        StudioSwitchRow(
          title: 'Custom Disabled Label Color',
          value: cfg.useCustomDisabledTextColor,
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(useCustomDisabledTextColor: v),
          ),
        ),
        if (cfg.useCustomDisabledTextColor)
          StudioColorTokenTile(
            label: 'Disabled Label Color',
            color: cfg.disabledTextColor,
            isExpanded: _expandedColorKey == 'disabledTextColor',
            onToggle: () => _toggleColorKey('disabledTextColor'),
            onSelect: (c) =>
                _updateConfig(context, cfg.copyWith(disabledTextColor: c)),
          ),
        const StudioSectionLabel('Fine-Tuning'),
        StudioSliderRow(
          label: 'Auto-Collapse Width',
          value: cfg.widthSwitch,
          min: 300,
          max: 1600,
          divisions: 130,
          valueLabel: '${cfg.widthSwitch.round()} px',
          onChanged: (v) =>
              _updateConfig(context, cfg.copyWith(widthSwitch: v)),
        ),
        StudioSliderRow(
          label: 'Outer Margin',
          value: cfg.marginAll,
          min: 0,
          max: 48,
          divisions: 48,
          valueLabel: '${cfg.marginAll.round()} px',
          onChanged: (v) => _updateConfig(context, cfg.copyWith(marginAll: v)),
        ),
        StudioSwitchRow(
          title: 'Custom Content Padding',
          value: cfg.useCustomContentPadding,
          onChanged: (v) => _updateConfig(
            context,
            cfg.copyWith(useCustomContentPadding: v),
          ),
        ),
        if (cfg.useCustomContentPadding) ...[
          StudioSliderRow(
            label: 'Horizontal Padding',
            value: cfg.contentPaddingHorizontal,
            min: 4,
            max: 48,
            divisions: 44,
            valueLabel: '${cfg.contentPaddingHorizontal.round()} px',
            onChanged: (v) => _updateConfig(
              context,
              cfg.copyWith(contentPaddingHorizontal: v),
            ),
          ),
          StudioSliderRow(
            label: 'Vertical Padding',
            value: cfg.contentPaddingVertical,
            min: 4,
            max: 64,
            divisions: 60,
            valueLabel: '${cfg.contentPaddingVertical.round()} px',
            onChanged: (v) => _updateConfig(
              context,
              cfg.copyWith(contentPaddingVertical: v),
            ),
          ),
        ],
        if (cfg.settingsDivider) ...[
          StudioSliderRow(
            label: 'Divider Height',
            value: cfg.dividerHeight,
            min: 2,
            max: 48,
            divisions: 46,
            valueLabel: '${cfg.dividerHeight.round()} px',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(dividerHeight: v)),
          ),
          StudioSliderRow(
            label: 'Divider Thickness',
            value: cfg.dividerThickness,
            min: 0.2,
            max: 6.0,
            divisions: 29,
            valueLabel: '${cfg.dividerThickness.toStringAsFixed(1)} px',
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(dividerThickness: v)),
          ),
          StudioColorTokenTile(
            label: 'Divider Color',
            color: cfg.dividerColor,
            isExpanded: _expandedColorKey == 'dividerColor',
            onToggle: () => _toggleColorKey('dividerColor'),
            onSelect: (c) =>
                _updateConfig(context, cfg.copyWith(dividerColor: c)),
          ),
        ],
        if (cfg.showToggleButton) ...[
          StudioSwitchRow(
            title: 'Custom Toggle Widgets',
            value: cfg.useCustomToggleWidgets,
            onChanged: (v) =>
                _updateConfig(context, cfg.copyWith(useCustomToggleWidgets: v)),
          ),
          if (!cfg.useCustomToggleWidgets) ...[
            StudioDropdownRow<String>(
              label: 'Expanded Toggle Icon',
              value: cfg.expandedToggleIconKey,
              items: PlaygroundBloc.toggleIconOptions.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  _updateConfig(
                    context,
                    cfg.copyWith(expandedToggleIconKey: v),
                  );
                }
              },
            ),
            StudioDropdownRow<String>(
              label: 'Collapsed Toggle Icon',
              value: cfg.collapsedToggleIconKey,
              items: PlaygroundBloc.toggleIconOptions.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  _updateConfig(
                    context,
                    cfg.copyWith(collapsedToggleIconKey: v),
                  );
                }
              },
            ),
          ],
          StudioSwitchRow(
            title: 'Custom Toggle Color',
            value: cfg.useCustomToggleButtonColor,
            onChanged: (v) => _updateConfig(
              context,
              cfg.copyWith(useCustomToggleButtonColor: v),
            ),
          ),
          if (cfg.useCustomToggleButtonColor)
            StudioColorTokenTile(
              label: 'Toggle Button Color',
              color: cfg.toggleButtonColor,
              isExpanded: _expandedColorKey == 'toggleButtonColor',
              onToggle: () => _toggleColorKey('toggleButtonColor'),
              onSelect: (c) =>
                  _updateConfig(context, cfg.copyWith(toggleButtonColor: c)),
            ),
        ],
        StudioDropdownRow<String>(
          label: 'Scroll Physics',
          value: cfg.scrollPhysicsKey,
          items: const [
            DropdownMenuItem(value: 'bouncing', child: Text('Bouncing')),
            DropdownMenuItem(value: 'clamping', child: Text('Clamping')),
            DropdownMenuItem(value: 'never', child: Text('Never Scroll')),
          ],
          onChanged: (v) {
            if (v != null) {
              _updateConfig(context, cfg.copyWith(scrollPhysicsKey: v));
            }
          },
        ),
      ],
    );
  }

  Widget _buildFontWeightDropdown({
    required String label,
    required FontWeight value,
    required ValueChanged<FontWeight> onChanged,
  }) {
    const weights = [
      (FontWeight.w300, 'Light (w300)'),
      (FontWeight.normal, 'Regular (w400)'),
      (FontWeight.w500, 'Medium (w500)'),
      (FontWeight.w600, 'SemiBold (w600)'),
      (FontWeight.bold, 'Bold (w700)'),
    ];
    final safeValue =
        weights.any((e) => e.$1 == value) ? value : FontWeight.normal;

    return StudioDropdownRow<FontWeight>(
      label: label,
      value: safeValue,
      items: weights
          .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
          .toList(),
      onChanged: (w) {
        if (w != null) onChanged(w);
      },
    );
  }

  Widget _buildMiniBadge(StudioColors colors, String label, String value) {
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
