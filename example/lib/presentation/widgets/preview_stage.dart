import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

import '../../domain/entities/studio_enums.dart';
import '../bloc/playground_bloc.dart';
import '../bloc/playground_event.dart';
import '../bloc/playground_state.dart';
import '../theme/studio_theme.dart';

/// Center live workspace preview rendered beside `SideBarAnimated`.
class PreviewStage extends StatelessWidget {
  /// Current playground state snapshot.
  final PlaygroundState state;

  /// Whether the shell is currently in desktop docked layout.
  final bool isDesktop;

  /// Callback invoked on compact screens to open the inspector drawer.
  final VoidCallback onOpenInspector;

  /// Creates a preview stage for [state].
  const PreviewStage({
    super.key,
    required this.state,
    required this.isDesktop,
    required this.onOpenInspector,
  });

  String _transitionName(SideBarTransitionType type) => switch (type) {
        SideBarTransitionType.slide => 'Slide',
        SideBarTransitionType.fade => 'Fade',
        SideBarTransitionType.scale => 'Scale',
        SideBarTransitionType.fadeSlide => 'Fade + Slide',
        SideBarTransitionType.none => 'None',
        SideBarTransitionType.custom => 'Custom',
      };

  String _heightModeName(RailHeightMode mode) => switch (mode) {
        RailHeightMode.full => 'Full height',
        RailHeightMode.wrap => 'Wrap content',
        RailHeightMode.fixed => '${state.config.customHeight.round()} px fixed',
      };

  @override
  Widget build(BuildContext context) {
    final colors = StudioColors.of(context);
    final activeItem = state.activeItem;
    final isMinimized = state.isCurrentlyMinimized;
    final isDark = state.themeMode == ThemeMode.dark;

    return SafeArea(
      left: false,
      right: !isDesktop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPad = constraints.maxWidth < 360
              ? 12.0
              : (constraints.maxWidth < 760 ? 22.0 : 32.0);
          final isCompactScale =
              MediaQuery.textScalerOf(context).scale(1) > 1.3 ||
                  constraints.maxWidth < 340;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(
                context,
                colors: colors,
                activeItem: activeItem,
                isMinimized: isMinimized,
                isDark: isDark,
                horizontalPad: horizontalPad,
              ),
              Divider(height: 1, color: colors.border),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPad,
                    vertical: 28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDestinationHeader(colors, activeItem),
                          const SizedBox(height: 24),
                          _buildDestinationBody(
                            context,
                            colors,
                            activeItem,
                            (constraints.maxWidth - (horizontalPad * 2))
                                .clamp(0.0, 1200.0),
                            isCompactScale,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colors.border),
              _buildTelemetryStrip(
                colors: colors,
                isMinimized: isMinimized,
                horizontalPad: horizontalPad,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context, {
    required StudioColors colors,
    required SideBarItem activeItem,
    required bool isMinimized,
    required bool isDark,
    required double horizontalPad,
  }) {
    final bloc = context.read<PlaygroundBloc>();
    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad - 6, 8),
      color: colors.canvas,
      child: Row(
        children: [
          Icon(
            activeItem.iconSelected,
            size: 20,
            color: colors.accentForeground,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              activeItem.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: isMinimized ? 'Expand Rail' : 'Collapse Rail',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => bloc.add(const PlaygroundRailMinimizeToggled()),
            icon: Icon(
              isMinimized ? Icons.unfold_more : Icons.unfold_less,
              size: 20,
              color: colors.textSecondary,
            ),
          ),
          IconButton(
            tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => bloc.add(const PlaygroundThemeToggled()),
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: colors.textSecondary,
            ),
          ),
          IconButton(
            tooltip: isDesktop
                ? (state.showDesktopInspector
                    ? 'Hide Inspector'
                    : 'Show Inspector')
                : 'Open Inspector',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: isDesktop
                ? () => bloc.add(const PlaygroundDesktopInspectorToggled())
                : onOpenInspector,
            icon: Icon(
              Icons.tune,
              size: 20,
              color: isDesktop && state.showDesktopInspector
                  ? colors.accentForeground
                  : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationHeader(StudioColors colors, SideBarItem item) {
    final subtitle = (item.tooltip != null && item.tooltip!.isNotEmpty)
        ? item.tooltip!
        : 'Active navigation destination';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            item.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationBody(
    BuildContext context,
    StudioColors colors,
    SideBarItem item,
    double contentWidth,
    bool isCompactScale,
  ) {
    switch (item.text) {
      case 'Dashboard':
        return _buildDashboardPreview(colors, contentWidth, isCompactScale);
      case 'Analytics':
        return _buildAnalyticsPreview(colors, contentWidth, isCompactScale);
      case 'Notifications':
        return _buildNotificationsPreview(colors, isCompactScale);
      case 'Messages':
        return _buildMessagesPreview(context, colors, isCompactScale);
      case 'Settings':
        return _buildSettingsPreview(colors, isCompactScale);
      default:
        return _buildCustomDestinationPreview(colors, item);
    }
  }

  Widget _buildDashboardPreview(
    StudioColors colors,
    double contentWidth,
    bool isCompactScale,
  ) {
    const metrics = [
      ('Active Sessions', '1,284', '+12.4%'),
      ('Completion Rate', '94.2%', '+2.1%'),
      ('Avg. Transition', '360 ms', '60 fps'),
    ];
    const events = [
      ('Navigation state synced', 'PlaygroundBloc + SideBarController', '2m ago'),
      ('Preset configuration loaded', 'Obsidian theme', '14m ago'),
      ('Export bundle verified', 'StatefulWidget', '1h ago'),
      ('Responsive threshold checked', '700 px breakpoint', '3h ago'),
    ];

    final isWide = contentWidth >= 520 && !isCompactScale;
    final useTwoColumn = contentWidth >= 700 && !isCompactScale;
    final cfg = state.config;

    final activityPanel = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Semantics(
              header: true,
              child: Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: colors.border),
          for (var i = 0; i < events.length; i++) ...[
            MergeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: isCompactScale
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            events[i].$1,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${events[i].$2} · ${events[i].$3}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events[i].$1,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  events[i].$2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              events[i].$3,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (i < events.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );

    final summaryRows = [
      ('Preset', state.activePreset?.label ?? 'Custom'),
      ('Header Slot', cfg.showHeaderWidget ? 'Visible' : 'Hidden'),
      ('Footer Slot', cfg.showFooterWidget ? 'Visible' : 'Hidden'),
      (
        'Rail Width',
        '${cfg.sideBarWidth.round()} / ${cfg.sideBarSmallWidth.round()} px',
      ),
    ];

    final railSummaryPanel = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Semantics(
              header: true,
              child: Text(
                'Live Rail Snapshot',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: colors.border),
          for (var i = 0; i < summaryRows.length; i++) ...[
            MergeSemantics(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        summaryRows[i].$1,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        summaryRows[i].$2,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i < summaryRows.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: isWide
              ? IntrinsicHeight(
                  child: Row(
                    children: [
                      for (var i = 0; i < metrics.length; i++) ...[
                        Expanded(
                          child: _buildMetricCell(colors, metrics[i]),
                        ),
                        if (i < metrics.length - 1)
                          VerticalDivider(width: 1, color: colors.border),
                      ],
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < metrics.length; i++) ...[
                      _buildMetricCell(colors, metrics[i]),
                      if (i < metrics.length - 1)
                        Divider(height: 1, color: colors.border),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 20),
        if (useTwoColumn)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: activityPanel),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: railSummaryPanel),
            ],
          )
        else ...[
          activityPanel,
          const SizedBox(height: 16),
          railSummaryPanel,
        ],
      ],
    );
  }

  Widget _buildMetricCell(
    StudioColors colors,
    (String, String, String) metric,
  ) {
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metric.$1,
              style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              metric.$2,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              metric.$3,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsPreview(
    StudioColors colors,
    double contentWidth,
    bool isCompactScale,
  ) {
    const channels = [
      ('Direct Workspace', 0.78, '78%'),
      ('Command Palette', 0.56, '56%'),
      ('Rail Shortcuts', 0.44, '44%'),
      ('Deep Links', 0.29, '29%'),
    ];
    const highlights = [
      ('Avg. Time to Navigate', '1.4 s', 'Faster with rail'),
      ('Collapse Usage', '38%', 'Split-window users'),
      ('Keyboard Focus Pass', '100%', 'Zero trapped panes'),
    ];

    final sourcesPanel = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Navigation Entry Sources',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < channels.length; i++) ...[
            Semantics(
              label: '${channels[i].$1} share',
              value: channels[i].$3,
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channels[i].$1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        channels[i].$3,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'monospace',
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 8,
                      color: colors.surfaceElevated,
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: channels[i].$2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.accentForeground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < channels.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );

    final highlightsPanel = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < highlights.length; i++) ...[
            _buildMetricCell(colors, highlights[i]),
            if (i < highlights.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );

    if (contentWidth >= 700 && !isCompactScale) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: sourcesPanel),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: highlightsPanel),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sourcesPanel,
        const SizedBox(height: 16),
        highlightsPanel,
      ],
    );
  }

  Widget _buildNotificationsPreview(
    StudioColors colors,
    bool isCompactScale,
  ) {
    const alerts = [
      (
        'Release 2.2.0 build passed',
        'All widget & layout checks green',
        'Just now',
        true,
      ),
      (
        'BLoC export templates ready',
        'Generated 4 Dart source files',
        '28m ago',
        true,
      ),
      (
        'Width threshold triggered',
        'Auto-collapsed below 700 px',
        'Yesterday',
        false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < alerts.length; i++) ...[
            MergeSemantics(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        alerts[i].$4
                            ? Icons.mark_email_unread_outlined
                            : Icons.done_all,
                        size: 16,
                        semanticLabel: alerts[i].$4 ? 'Unread' : 'Read',
                        color: alerts[i].$4
                            ? colors.accentForeground
                            : colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alerts[i].$1,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alerts[i].$2,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: colors.textSecondary,
                            ),
                          ),
                          if (isCompactScale) ...[
                            const SizedBox(height: 4),
                            Text(
                              alerts[i].$3,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isCompactScale) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          alerts[i].$3,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (i < alerts.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );
  }

  Widget _buildMessagesPreview(
    BuildContext context,
    StudioColors colors,
    bool isCompactScale,
  ) {
    const threads = [
      (
        'AL',
        'Alex Lin',
        'Verified the Snow light rail contrast on desktop.',
        '10:42',
      ),
      (
        'MR',
        'Maya Rao',
        'Updated the BLoC export directory structure.',
        '09:15',
      ),
      (
        'DK',
        'Devon Kim',
        'Compact preset fits nicely inside split windows.',
        'Yesterday',
      ),
    ];
    final avatarForeground = Theme.of(context).colorScheme.onPrimaryContainer;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < threads.length; i++) ...[
            MergeSemantics(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colors.accentMuted,
                        child: Text(
                          threads[i].$1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: avatarForeground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            threads[i].$2,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            threads[i].$3,
                            maxLines: isCompactScale ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: colors.textSecondary,
                            ),
                          ),
                          if (isCompactScale) ...[
                            const SizedBox(height: 4),
                            Text(
                              threads[i].$4,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontFamily: 'monospace',
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isCompactScale) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          threads[i].$4,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontFamily: 'monospace',
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (i < threads.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsPreview(StudioColors colors, bool isCompactScale) {
    final cfg = state.config;
    final rows = [
      ('Active Preset', state.activePreset?.label ?? 'Custom'),
      (
        'State Management',
        cfg.useController ? 'PlaygroundBloc + Controller' : 'Internal State',
      ),
      ('Export Target', state.exportArchitecture.name.toUpperCase()),
      ('Studio Theme', state.themeMode == ThemeMode.dark ? 'Dark' : 'Light'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            MergeSemantics(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: isCompactScale
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rows[i].$1,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rows[i].$2,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'monospace',
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              rows[i].$1,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              rows[i].$2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (i < rows.length - 1)
              Divider(height: 1, color: colors.borderSubtle),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomDestinationPreview(
    StudioColors colors,
    SideBarItem item,
  ) {
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.iconSelected, color: colors.accentForeground),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Slot #${state.effectiveIndex + 1} · Ready for destination content',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryStrip({
    required StudioColors colors,
    required bool isMinimized,
    required double horizontalPad,
  }) {
    final cfg = state.config;
    final items = [
      'Item #${state.effectiveIndex + 1}',
      isMinimized ? 'Collapsed' : 'Expanded',
      _transitionName(cfg.transitionType),
      _heightModeName(state.heightMode),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 10),
      color: colors.surface,
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: items.map((label) {
          return Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: colors.textSecondary,
            ),
          );
        }).toList(),
      ),
    );
  }
}
