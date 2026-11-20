import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';
import 'package:side_bar_code_exporter/side_bar_code_exporter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GN Side Navigation Rail Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff121212),
        useMaterial3: true,
      ),
      home: const ExampleHomeScreen(),
    );
  }
}

class ExampleHomeScreen extends StatefulWidget {
  const ExampleHomeScreen({super.key});

  @override
  State<ExampleHomeScreen> createState() => _ExampleHomeScreenState();
}

class _ExampleHomeScreenState extends State<ExampleHomeScreen> {
  late final SideBarController _controller;

  // --- Export Panel State ---
  ExportArchitecture _exportArchitecture = ExportArchitecture.stateful;
  String _selectedExportFile = 'lib/main.dart';
  bool _showLeftExportPanel = true;
  String? _lastExportSavedPath;
  bool _isExportingZip = false;

  // --- State & Controller Mode ---
  bool _useController = true;
  bool _useDirectIsMinimized = false;
  bool _directIsMinimized = false;
  int _initialIndex = 0;
  int? _lastTappedIndex;
  bool? _lastMinimizeCallbackValue;

  // --- Layout & Dimensions ---
  double _widthSwitch = 700;
  double _sideBarWidth = 260;
  double _sideBarSmallWidth = 84;
  double _itemHeight = 48;
  double _itemSpacing = 8;
  double _borderRadius = 20;
  double _itemBorderRadiusValue = 12;
  double _marginAll = 20;
  bool _useCustomContentPadding = false;
  double _contentPaddingHorizontal = 20;
  double _contentPaddingVertical = 24;

  // --- Colors ---
  Color _sideBarColor = const Color(0xff1D1D1D);
  Color _animatedContainerColor = const Color(0xff323232);
  Color _selectedIconColor = Colors.white;
  Color _unselectedIconColor = const Color(0xffA0A5A9);
  bool _useCustomDisabledIconColor = false;
  Color _disabledIconColor = const Color(0xff555555);
  Color _unSelectedTextColor = const Color(0xffA0A5A9);
  bool _useCustomDisabledTextColor = false;
  Color _disabledTextColor = const Color(0xff555555);
  Color _hoverColor = Colors.black38;
  Color _splashColor = Colors.black87;
  Color _highlightColor = Colors.black;

  // --- Typography ---
  bool _useCustomTextStyle = false;
  double _baseFontSize = 16;
  FontWeight _baseFontWeight = FontWeight.normal;
  bool _useCustomSelectedTextStyle = false;
  Color _selectedTextColor = Colors.white;
  double _selectedFontSize = 16;
  FontWeight _selectedFontWeight = FontWeight.w600;
  bool _useCustomDisabledTextStyle = false;
  double _disabledFontSize = 16;
  bool _disabledFontItalic = true;

  // --- Divider Settings ---
  bool _settingsDivider = true;
  Color _dividerColor = const Color(0xff929292);
  double _dividerHeight = 12;
  double _dividerThickness = 0.5;

  // --- Animation & Transitions ---
  SideBarTransitionType _transitionType = SideBarTransitionType.slide;
  int _sideBarAnimationDurationMs = 700;
  int _itemTransitionDurationMs = 400;
  String _curveKey = 'easeOut';
  String _itemTransitionCurveKey = 'easeOutCubic';
  String _customTransitionMode = 'rotateScale';

  // --- Header, Footer & Toggle Button ---
  bool _showHeaderWidget = true;
  bool _showFooterWidget = false;
  bool _showToggleButton = true;
  bool _useCustomToggleButtonColor = false;
  Color _toggleButtonColor = Colors.deepPurpleAccent;
  bool _useCustomToggleWidgets = false;
  String _expandedToggleIconKey = 'menu_open';
  String _collapsedToggleIconKey = 'menu';

  // --- Scroll Physics ---
  String _scrollPhysicsKey = 'bouncing';

  // --- Programmatic Override Controls ---
  SideBarTransitionType _overrideTransitionType = SideBarTransitionType.slide;
  int _overrideDurationMs = 500;
  String _overrideCurveKey = 'easeInOutBack';

  // --- Dynamic Sidebar Items ---
  late List<SideBarItem> _sidebarItems;

  static const Map<String, Curve> _curveOptions = {
    'easeOut': Curves.easeOut,
    'easeIn': Curves.easeIn,
    'easeInOut': Curves.easeInOut,
    'easeOutCubic': Curves.easeOutCubic,
    'easeInOutCubic': Curves.easeInOutCubic,
    'easeInOutBack': Curves.easeInOutBack,
    'elasticOut': Curves.elasticOut,
    'bounceOut': Curves.bounceOut,
    'fastOutSlowIn': Curves.fastOutSlowIn,
    'linear': Curves.linear,
  };

  static const Map<String, IconData> _toggleIconOptions = {
    'menu_open': Icons.menu_open,
    'menu': Icons.menu,
    'space_dashboard': Icons.space_dashboard_outlined,
    'arrow_right': CupertinoIcons.arrow_right,
    'chevron_left': Icons.chevron_left,
    'chevron_right': Icons.chevron_right,
    'unfold_less': Icons.unfold_less,
    'unfold_more': Icons.unfold_more,
  };

  static const Map<String, ScrollPhysics> _physicsOptions = {
    'bouncing': BouncingScrollPhysics(),
    'clamping': ClampingScrollPhysics(),
    'never': NeverScrollableScrollPhysics(),
  };

  static const List<Color> _presetSwatches = [
    Color(0xff1D1D1D),
    Color(0xff1E293B),
    Color(0xff0F172A),
    Color(0xff323232),
    Color(0xff4F46E5),
    Color(0xff7C3AED),
    Color(0xff2563EB),
    Color(0xff059669),
    Color(0xffD97706),
    Color(0xffDC2626),
    Color(0xffEC4899),
    Colors.white,
    Color(0xffA0A5A9),
    Color(0xff929292),
    Color(0xff555555),
    Colors.black38,
    Colors.black87,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _sidebarItems = _defaultItems();
    _controller = SideBarController(
      initialIndex: _initialIndex,
      initialMinimized: false,
    );
  }

  List<SideBarItem> _defaultItems() {
    return [
      const SideBarItem(
        iconSelected: Icons.dashboard,
        iconUnselected: Icons.dashboard_outlined,
        text: 'Dashboard',
        tooltip: 'Overview & KPIs',
      ),
      const SideBarItem(
        iconSelected: Icons.analytics,
        iconUnselected: Icons.analytics_outlined,
        text: 'Analytics',
        tooltip: 'Traffic & conversion metrics',
      ),
      const SideBarItem(
        iconSelected: Icons.notifications,
        iconUnselected: Icons.notifications_none,
        text: 'Notifications',
        tooltip: 'System alerts',
      ),
      const SideBarItem(
        iconSelected: Icons.chat_bubble,
        iconUnselected: Icons.chat_bubble_outline,
        text: 'Messages',
        tooltip: 'Team chat',
      ),
      const SideBarItem(
        iconSelected: Icons.lock,
        iconUnselected: Icons.lock_outline,
        text: 'Security (Disabled)',
        isDisabled: true,
        tooltip: 'You do not have permission to access Security',
      ),
      const SideBarItem(
        iconSelected: Icons.settings,
        iconUnselected: Icons.settings_outlined,
        text: 'Settings',
        tooltip: 'Application preferences',
      ),
    ];
  }

  SideBarExportConfig _buildCurrentExportConfig() {
    return SideBarExportConfig(
      useController: _useController,
      useDirectIsMinimized: _useDirectIsMinimized,
      directIsMinimized: _directIsMinimized,
      initialIndex: _initialIndex.clamp(0, _sidebarItems.length - 1),
      widthSwitch: _widthSwitch,
      sideBarWidth: _sideBarWidth,
      sideBarSmallWidth: _sideBarSmallWidth,
      itemHeight: _itemHeight,
      itemSpacing: _itemSpacing,
      borderRadius: _borderRadius,
      itemBorderRadiusValue: _itemBorderRadiusValue,
      marginAll: _marginAll,
      useCustomContentPadding: _useCustomContentPadding,
      contentPaddingHorizontal: _contentPaddingHorizontal,
      contentPaddingVertical: _contentPaddingVertical,
      sideBarColor: _sideBarColor,
      animatedContainerColor: _animatedContainerColor,
      selectedIconColor: _selectedIconColor,
      unselectedIconColor: _unselectedIconColor,
      useCustomDisabledIconColor: _useCustomDisabledIconColor,
      disabledIconColor: _disabledIconColor,
      unSelectedTextColor: _unSelectedTextColor,
      useCustomDisabledTextColor: _useCustomDisabledTextColor,
      disabledTextColor: _disabledTextColor,
      hoverColor: _hoverColor,
      splashColor: _splashColor,
      highlightColor: _highlightColor,
      useCustomTextStyle: _useCustomTextStyle,
      baseFontSize: _baseFontSize,
      baseFontWeight: _baseFontWeight,
      useCustomSelectedTextStyle: _useCustomSelectedTextStyle,
      selectedTextColor: _selectedTextColor,
      selectedFontSize: _selectedFontSize,
      selectedFontWeight: _selectedFontWeight,
      useCustomDisabledTextStyle: _useCustomDisabledTextStyle,
      disabledFontSize: _disabledFontSize,
      disabledFontItalic: _disabledFontItalic,
      settingsDivider: _settingsDivider,
      dividerColor: _dividerColor,
      dividerHeight: _dividerHeight,
      dividerThickness: _dividerThickness,
      transitionType: _transitionType,
      sideBarAnimationDurationMs: _sideBarAnimationDurationMs,
      itemTransitionDurationMs: _itemTransitionDurationMs,
      curveKey: _curveKey,
      itemTransitionCurveKey: _itemTransitionCurveKey,
      customTransitionMode: _customTransitionMode,
      showHeaderWidget: _showHeaderWidget,
      showFooterWidget: _showFooterWidget,
      showToggleButton: _showToggleButton,
      useCustomToggleButtonColor: _useCustomToggleButtonColor,
      toggleButtonColor: _toggleButtonColor,
      useCustomToggleWidgets: _useCustomToggleWidgets,
      expandedToggleIconKey: _expandedToggleIconKey,
      collapsedToggleIconKey: _collapsedToggleIconKey,
      scrollPhysicsKey: _scrollPhysicsKey,
      sidebarItems: List<SideBarItem>.from(_sidebarItems),
    );
  }

  Map<String, String> _getGeneratedFiles() {
    final config = _buildCurrentExportConfig();
    if (_exportArchitecture == ExportArchitecture.stateful) {
      return CodeExportGenerator.generateStatefulFiles(config);
    } else {
      return CodeExportGenerator.generateBlocFiles(config);
    }
  }

  Future<void> _exportToZip() async {
    setState(() {
      _isExportingZip = true;
    });
    try {
      final files = _getGeneratedFiles();
      final zipName = _exportArchitecture == ExportArchitecture.stateful
          ? 'gn_side_nav_stateful_export.zip'
          : 'gn_side_nav_bloc_export.zip';
      final savedPath = await ZipExporter.exportZipFile(
        files: files,
        fileName: zipName,
      );
      if (!mounted) return;
      setState(() {
        _lastExportSavedPath = savedPath ?? zipName;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xff059669),
          content: Text(
            savedPath != null
                ? 'Exported ZIP with ${files.length} files to: $savedPath'
                : 'ZIP archive generated ($zipName)',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Failed to export ZIP: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExportingZip = false;
        });
      }
    }
  }

  void _resetAllSettings() {
    setState(() {
      _useController = true;
      _useDirectIsMinimized = false;
      _directIsMinimized = false;
      _initialIndex = 0;

      _widthSwitch = 700;
      _sideBarWidth = 260;
      _sideBarSmallWidth = 84;
      _itemHeight = 48;
      _itemSpacing = 8;
      _borderRadius = 20;
      _itemBorderRadiusValue = 12;
      _marginAll = 20;
      _useCustomContentPadding = false;
      _contentPaddingHorizontal = 20;
      _contentPaddingVertical = 24;

      _sideBarColor = const Color(0xff1D1D1D);
      _animatedContainerColor = const Color(0xff323232);
      _selectedIconColor = Colors.white;
      _unselectedIconColor = const Color(0xffA0A5A9);
      _useCustomDisabledIconColor = false;
      _disabledIconColor = const Color(0xff555555);
      _unSelectedTextColor = const Color(0xffA0A5A9);
      _useCustomDisabledTextColor = false;
      _disabledTextColor = const Color(0xff555555);
      _hoverColor = Colors.black38;
      _splashColor = Colors.black87;
      _highlightColor = Colors.black;

      _useCustomTextStyle = false;
      _baseFontSize = 16;
      _baseFontWeight = FontWeight.normal;
      _useCustomSelectedTextStyle = false;
      _selectedTextColor = Colors.white;
      _selectedFontSize = 16;
      _selectedFontWeight = FontWeight.w600;
      _useCustomDisabledTextStyle = false;
      _disabledFontSize = 16;
      _disabledFontItalic = true;

      _settingsDivider = true;
      _dividerColor = const Color(0xff929292);
      _dividerHeight = 12;
      _dividerThickness = 0.5;

      _transitionType = SideBarTransitionType.slide;
      _sideBarAnimationDurationMs = 700;
      _itemTransitionDurationMs = 400;
      _curveKey = 'easeOut';
      _itemTransitionCurveKey = 'easeOutCubic';
      _customTransitionMode = 'rotateScale';

      _showHeaderWidget = true;
      _showFooterWidget = false;
      _showToggleButton = true;
      _useCustomToggleButtonColor = false;
      _toggleButtonColor = Colors.deepPurpleAccent;
      _useCustomToggleWidgets = false;
      _expandedToggleIconKey = 'menu_open';
      _collapsedToggleIconKey = 'menu';
      _scrollPhysicsKey = 'bouncing';

      _sidebarItems = _defaultItems();
      _controller.selectIndex(0, transitionType: SideBarTransitionType.none);
      _controller.expand();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCustomTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    switch (_customTransitionMode) {
      case 'rotateScale':
        return RotationTransition(
          turns: Tween<double>(begin: -0.04, end: 0.0).animate(animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      case 'horizontalSlide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.35, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      case 'sizeExpand':
      default:
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final effectiveIndex = (_useController
                ? _controller.selectedIndex
                : (_lastTappedIndex ?? _initialIndex))
            .clamp(0, _sidebarItems.length - 1);
        final activeItem = _sidebarItems[effectiveIndex];
        final isCurrentlyMinimized = _useController
            ? _controller.isMinimized
            : (_useDirectIsMinimized
                ? _directIsMinimized
                : (_lastMinimizeCallbackValue ?? false));

        final screenWidth = MediaQuery.sizeOf(context).width;
        final isWideEnoughForSplit = screenWidth >= 1050;

        return Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                controller: _useController ? _controller : null,
                isMinimized: _useDirectIsMinimized ? _directIsMinimized : null,
                initialIndex: _initialIndex.clamp(0, _sidebarItems.length - 1),
                onTap: (index) {
                  setState(() {
                    _lastTappedIndex = index;
                  });
                },
                onMinimizeChanged: (minimized) {
                  setState(() {
                    _lastMinimizeCallbackValue = minimized;
                    if (_useDirectIsMinimized) {
                      _directIsMinimized = minimized;
                    }
                  });
                },
                sidebarItems: _sidebarItems,
                widthSwitch: _widthSwitch,
                sideBarWidth: _sideBarWidth,
                sideBarSmallWidth: _sideBarSmallWidth,
                itemHeight: _itemHeight,
                itemSpacing: _itemSpacing,
                borderRadius: _borderRadius,
                itemBorderRadius:
                    BorderRadius.circular(_itemBorderRadiusValue),
                margin: EdgeInsets.all(_marginAll),
                contentPadding: _useCustomContentPadding
                    ? EdgeInsets.symmetric(
                        horizontal: _contentPaddingHorizontal,
                        vertical: _contentPaddingVertical,
                      )
                    : null,
                sideBarColor: _sideBarColor,
                animatedContainerColor: _animatedContainerColor,
                selectedIconColor: _selectedIconColor,
                unselectedIconColor: _unselectedIconColor,
                disabledIconColor:
                    _useCustomDisabledIconColor ? _disabledIconColor : null,
                unSelectedTextColor: _unSelectedTextColor,
                disabledTextColor:
                    _useCustomDisabledTextColor ? _disabledTextColor : null,
                textStyle: _useCustomTextStyle
                    ? TextStyle(
                        fontSize: _baseFontSize,
                        fontWeight: _baseFontWeight,
                      )
                    : null,
                selectedTextStyle: _useCustomSelectedTextStyle
                    ? TextStyle(
                        color: _selectedTextColor,
                        fontSize: _selectedFontSize,
                        fontWeight: _selectedFontWeight,
                      )
                    : null,
                disabledTextStyle: _useCustomDisabledTextStyle
                    ? TextStyle(
                        fontSize: _disabledFontSize,
                        fontStyle: _disabledFontItalic
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: _useCustomDisabledTextColor
                            ? _disabledTextColor
                            : _unSelectedTextColor.withValues(alpha: 0.38),
                      )
                    : null,
                settingsDivider: _settingsDivider,
                dividerColor: _dividerColor,
                dividerHeight: _dividerHeight,
                dividerThickness: _dividerThickness,
                hoverColor: _hoverColor,
                splashColor: _splashColor,
                highlightColor: _highlightColor,
                curve: _curveOptions[_curveKey] ?? Curves.easeOut,
                sideBarAnimationDuration:
                    Duration(milliseconds: _sideBarAnimationDurationMs),
                transitionType: _transitionType,
                itemTransitionDuration:
                    Duration(milliseconds: _itemTransitionDurationMs),
                itemTransitionCurve:
                    _curveOptions[_itemTransitionCurveKey] ??
                        Curves.easeOutCubic,
                itemTransitionBuilder: _buildCustomTransition,
                headerWidget: _showHeaderWidget
                    ? Row(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            width: 44,
                            height: 44,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.rocket_launch,
                              size: 36,
                              color: _selectedIconColor,
                            ),
                          ),
                          if (!isCurrentlyMinimized) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'MyApp',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : null,
                footerWidget: _showFooterWidget
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.person,
                                  size: 16, color: Colors.white),
                            ),
                            if (!isCurrentlyMinimized) ...[
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'George N.',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : null,
                showToggleButton: _showToggleButton,
                expandedToggleIcon:
                    _toggleIconOptions[_expandedToggleIconKey] ??
                        Icons.menu_open,
                collapsedToggleIcon:
                    _toggleIconOptions[_collapsedToggleIconKey] ?? Icons.menu,
                expandedToggleWidget: _useCustomToggleWidgets
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.first_page,
                                size: 18, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Hide',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white)),
                          ],
                        ),
                      )
                    : null,
                collapsedToggleWidget: _useCustomToggleWidgets
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.last_page,
                            size: 18, color: Colors.white),
                      )
                    : null,
                toggleButtonColor:
                    _useCustomToggleButtonColor ? _toggleButtonColor : null,
                scrollPhysics: _physicsOptions[_scrollPhysicsKey] ??
                    const BouncingScrollPhysics(),
              ),
              if (_showLeftExportPanel && isWideEnoughForSplit)
                SizedBox(
                  width: 440,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 16, bottom: 20),
                    child: _buildLeftExportSection(),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderBar(activeItem, isCurrentlyMinimized),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xff323232)),
                          const SizedBox(height: 12),
                          Text(
                            'Welcome to ${activeItem.text}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Interactive Playground: Control every parameter of SideBarAnimated, SideBarController, and SideBarItem in real time.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          if (_showLeftExportPanel && !isWideEnoughForSplit) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 520,
                              child: _buildLeftExportSection(),
                            ),
                          ],
                          const SizedBox(height: 16),
                          _buildQuickTransitionChips(),
                          const SizedBox(height: 20),
                          _buildControllerAndStateSection(isCurrentlyMinimized),
                          const SizedBox(height: 12),
                          _buildAnimationSection(),
                          const SizedBox(height: 12),
                          _buildLayoutDimensionsSection(),
                          const SizedBox(height: 12),
                          _buildColorsSection(),
                          const SizedBox(height: 12),
                          _buildTypographySection(),
                          const SizedBox(height: 12),
                          _buildDividerSection(),
                          const SizedBox(height: 12),
                          _buildSlotsAndToggleSection(),
                          const SizedBox(height: 12),
                          _buildItemsConfigSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Left Panel: Export Settings to Dart Code & ZIP Package
  // ---------------------------------------------------------------------------
  Widget _buildLeftExportSection() {
    final files = _getGeneratedFiles();
    final fileNames = files.keys.toList();
    final activeFileKey =
        files.containsKey(_selectedExportFile) ? _selectedExportFile : fileNames.first;
    final activeFileContent = files[activeFileKey] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1A1A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff343446)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: Colors.deepPurpleAccent, size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Export Dart Code & ZIP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Hide Export Panel',
                onPressed: () => setState(() => _showLeftExportPanel = false),
                icon: const Icon(Icons.close, size: 18, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose architecture (StatefulWidget or BLoC) to preview live generated files or export a complete runnable ZIP archive with pubspec.yaml.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ExportArchitecture>(
              segments: const [
                ButtonSegment(
                  value: ExportArchitecture.stateful,
                  icon: Icon(Icons.widgets_outlined, size: 18),
                  label: Text('StatefulWidget'),
                ),
                ButtonSegment(
                  value: ExportArchitecture.bloc,
                  icon: Icon(Icons.account_tree_outlined, size: 18),
                  label: Text('BLoC Pattern'),
                ),
              ],
              selected: {_exportArchitecture},
              onSelectionChanged: (selection) {
                setState(() {
                  _exportArchitecture = selection.first;
                  _selectedExportFile = 'lib/main.dart';
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Included Requirement & Source Files:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: fileNames.map((fileName) {
                final isSelected = fileName == activeFileKey;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      fileName,
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedExportFile = fileName;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff111116),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xff2B2B3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xff1F1F2B),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(11)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_outlined,
                            size: 14, color: Colors.deepPurpleAccent),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            activeFileKey,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: activeFileContent),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Copied $activeFileKey to clipboard'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        activeFileContent,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.45,
                          color: Color(0xffE2E8F0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_lastExportSavedPath != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff059669).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xff059669).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 15, color: Color(0xff34D399)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Saved: $_lastExportSavedPath',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xffA7F3D0),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isExportingZip ? null : _exportToZip,
              icon: _isExportingZip
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.folder_zip_outlined),
              label: Text(
                _exportArchitecture == ExportArchitecture.stateful
                    ? 'Export StatefulWidget Project (.ZIP)'
                    : 'Export BLoC Project + Requirements (.ZIP)',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(SideBarItem activeItem, bool isCurrentlyMinimized) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(activeItem.iconSelected, size: 32, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              activeItem.text,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  setState(() => _showLeftExportPanel = !_showLeftExportPanel),
              icon: Icon(
                  _showLeftExportPanel ? Icons.code_off : Icons.code),
              label: Text(_showLeftExportPanel
                  ? 'Hide Export Code Panel'
                  : 'Show Export Code Panel'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                if (_useController) {
                  _controller.toggleMinimize();
                } else {
                  setState(() {
                    _useDirectIsMinimized = true;
                    _directIsMinimized = !_directIsMinimized;
                  });
                }
              },
              icon: Icon(isCurrentlyMinimized
                  ? Icons.unfold_more
                  : Icons.unfold_less),
              label: Text(
                  isCurrentlyMinimized ? 'Expand Rail' : 'Collapse Rail'),
            ),
            FilledButton.tonalIcon(
              onPressed: _resetAllSettings,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Defaults'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickTransitionChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transition Animation Type (transitionType):',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SideBarTransitionType.values.map((type) {
            final isSelected = _transitionType == type;
            return ChoiceChip(
              label: Text(type.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _transitionType = type;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Controller & State Section
  // ---------------------------------------------------------------------------
  Widget _buildControllerAndStateSection(bool isCurrentlyMinimized) {
    return _buildSectionCard(
      title: '1. Controller, Callbacks & Programmatic Navigation',
      icon: Icons.gamepad_outlined,
      initiallyExpanded: true,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildStatusBadge(
              'Controller Selected Index',
              '${_controller.selectedIndex}',
            ),
            _buildStatusBadge(
              'Controller isMinimized',
              '${_controller.isMinimized}',
            ),
            _buildStatusBadge(
              'Last onTap(index)',
              _lastTappedIndex?.toString() ?? 'None',
            ),
            _buildStatusBadge(
              'Last onMinimizeChanged',
              _lastMinimizeCallbackValue?.toString() ?? 'None',
            ),
            _buildStatusBadge(
              'Last Transition Override',
              _controller.lastTransitionType?.name ?? 'Default',
            ),
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Attach SideBarController (controller)'),
          subtitle: const Text(
              'When disabled, SideBarAnimated manages selection internally using initialIndex'),
          value: _useController,
          onChanged: (v) => setState(() => _useController = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Pass Explicit isMinimized Prop (isMinimized)'),
          subtitle: const Text(
              'Directly control collapsed/expanded state via widget parameter'),
          value: _useDirectIsMinimized,
          onChanged: (v) => setState(() => _useDirectIsMinimized = v),
        ),
        if (_useDirectIsMinimized)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Direct isMinimized Value'),
            value: _directIsMinimized,
            onChanged: (v) => setState(() {
              _directIsMinimized = v;
              if (_useController) {
                _controller.setMinimized(v);
              }
            }),
          ),
        _buildSliderRow(
          label: 'initialIndex (used when controller is null)',
          value: _initialIndex.toDouble(),
          min: 0,
          max: (_sidebarItems.length - 1).toDouble(),
          divisions: (_sidebarItems.length - 1).clamp(1, 20),
          valueLabel: '$_initialIndex',
          onChanged: (v) => setState(() => _initialIndex = v.round()),
        ),
        const Divider(color: Color(0xff323232)),
        const Text(
          'Controller Methods (expand / collapse / toggleMinimize / setMinimized):',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: _useController ? () => _controller.expand() : null,
              icon: const Icon(Icons.keyboard_double_arrow_right, size: 18),
              label: const Text('controller.expand()'),
            ),
            ElevatedButton.icon(
              onPressed: _useController ? () => _controller.collapse() : null,
              icon: const Icon(Icons.keyboard_double_arrow_left, size: 18),
              label: const Text('controller.collapse()'),
            ),
            ElevatedButton.icon(
              onPressed:
                  _useController ? () => _controller.toggleMinimize() : null,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('controller.toggleMinimize()'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Programmatic Navigation with Transition Overrides (controller.selectIndex):',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildDropdownRow<SideBarTransitionType>(
              label: 'Override Type',
              value: _overrideTransitionType,
              items: SideBarTransitionType.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _overrideTransitionType = v);
              },
            ),
            _buildDropdownRow<String>(
              label: 'Override Curve',
              value: _overrideCurveKey,
              items: _curveOptions.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _overrideCurveKey = v);
              },
            ),
          ],
        ),
        _buildSliderRow(
          label: 'Override Duration',
          value: _overrideDurationMs.toDouble(),
          min: 0,
          max: 2000,
          divisions: 40,
          valueLabel: '${_overrideDurationMs}ms',
          onChanged: (v) => setState(() => _overrideDurationMs = v.round()),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => _controller.selectIndex(
                0,
                transitionType: SideBarTransitionType.slide,
              ),
              child: const Text('Dashboard (Slide)'),
            ),
            ElevatedButton(
              onPressed: () => _controller.selectIndex(
                1,
                transitionType: SideBarTransitionType.fade,
              ),
              child: const Text('Analytics (Fade)'),
            ),
            ElevatedButton(
              onPressed: () => _controller.selectIndex(
                3,
                transitionType: SideBarTransitionType.scale,
              ),
              child: const Text('Messages (Scale)'),
            ),
            ElevatedButton(
              onPressed: () => _controller.selectIndex(
                5,
                transitionType: SideBarTransitionType.none,
              ),
              child: const Text('Settings (Instant)'),
            ),
            ...List.generate(_sidebarItems.length, (index) {
              final item = _sidebarItems[index];
              return OutlinedButton(
                onPressed: item.isDisabled
                    ? null
                    : () => _controller.selectIndex(
                          index,
                          transitionType: _overrideTransitionType,
                          duration:
                              Duration(milliseconds: _overrideDurationMs),
                          curve: _curveOptions[_overrideCurveKey],
                        ),
                child: Text(
                    'Go to #${index + 1} ${item.text} (${_overrideTransitionType.name})'),
              );
            }),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Animation & Transitions Section
  // ---------------------------------------------------------------------------
  Widget _buildAnimationSection() {
    return _buildSectionCard(
      title: '2. Animation & Transition Settings',
      icon: Icons.animation,
      children: [
        _buildSliderRow(
          label: 'sideBarAnimationDuration (Expand/Collapse)',
          value: _sideBarAnimationDurationMs.toDouble(),
          min: 50,
          max: 2000,
          divisions: 39,
          valueLabel: '${_sideBarAnimationDurationMs}ms',
          onChanged: (v) =>
              setState(() => _sideBarAnimationDurationMs = v.round()),
        ),
        _buildSliderRow(
          label: 'itemTransitionDuration (Selection Indicator)',
          value: _itemTransitionDurationMs.toDouble(),
          min: 50,
          max: 2000,
          divisions: 39,
          valueLabel: '${_itemTransitionDurationMs}ms',
          onChanged: (v) =>
              setState(() => _itemTransitionDurationMs = v.round()),
        ),
        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            _buildDropdownRow<String>(
              label: 'Sidebar Expand/Collapse Curve (curve)',
              value: _curveKey,
              items: _curveOptions.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _curveKey = v);
              },
            ),
            _buildDropdownRow<String>(
              label: 'Item Transition Curve (itemTransitionCurve)',
              value: _itemTransitionCurveKey,
              items: _curveOptions.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _itemTransitionCurveKey = v);
              },
            ),
            _buildDropdownRow<String>(
              label: 'Custom Builder Preset (itemTransitionBuilder)',
              value: _customTransitionMode,
              items: const [
                DropdownMenuItem(
                  value: 'rotateScale',
                  child: Text('Rotate + Scale + Fade'),
                ),
                DropdownMenuItem(
                  value: 'horizontalSlide',
                  child: Text('Horizontal Slide + Fade'),
                ),
                DropdownMenuItem(
                  value: 'sizeExpand',
                  child: Text('Horizontal Size Reveal'),
                ),
              ],
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _customTransitionMode = v;
                    _transitionType = SideBarTransitionType.custom;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Layout & Dimensions Section
  // ---------------------------------------------------------------------------
  Widget _buildLayoutDimensionsSection() {
    return _buildSectionCard(
      title: '3. Layout, Dimensions & Spacing',
      icon: Icons.straighten,
      children: [
        _buildSliderRow(
          label: 'widthSwitch (Auto-collapse screen width threshold)',
          value: _widthSwitch,
          min: 300,
          max: 1600,
          divisions: 130,
          valueLabel: '${_widthSwitch.round()} px',
          onChanged: (v) => setState(() => _widthSwitch = v),
        ),
        _buildSliderRow(
          label: 'sideBarWidth (Expanded width)',
          value: _sideBarWidth,
          min: 180,
          max: 420,
          divisions: 48,
          valueLabel: '${_sideBarWidth.round()} px',
          onChanged: (v) => setState(() => _sideBarWidth = v),
        ),
        _buildSliderRow(
          label: 'sideBarSmallWidth (Collapsed rail width)',
          value: _sideBarSmallWidth,
          min: 64,
          max: 150,
          divisions: 43,
          valueLabel: '${_sideBarSmallWidth.round()} px',
          onChanged: (v) => setState(() => _sideBarSmallWidth = v),
        ),
        _buildSliderRow(
          label: 'itemHeight (Navigation tile height)',
          value: _itemHeight,
          min: 36,
          max: 80,
          divisions: 44,
          valueLabel: '${_itemHeight.round()} px',
          onChanged: (v) => setState(() => _itemHeight = v),
        ),
        _buildSliderRow(
          label: 'itemSpacing (Gap between items)',
          value: _itemSpacing,
          min: 0,
          max: 32,
          divisions: 32,
          valueLabel: '${_itemSpacing.round()} px',
          onChanged: (v) => setState(() => _itemSpacing = v),
        ),
        _buildSliderRow(
          label: 'borderRadius (Sidebar outer corner radius)',
          value: _borderRadius,
          min: 0,
          max: 48,
          divisions: 48,
          valueLabel: '${_borderRadius.round()} px',
          onChanged: (v) => setState(() => _borderRadius = v),
        ),
        _buildSliderRow(
          label: 'itemBorderRadius (Item & indicator corner radius)',
          value: _itemBorderRadiusValue,
          min: 0,
          max: 36,
          divisions: 36,
          valueLabel: '${_itemBorderRadiusValue.round()} px',
          onChanged: (v) => setState(() => _itemBorderRadiusValue = v),
        ),
        _buildSliderRow(
          label: 'margin (Outer margin around sidebar)',
          value: _marginAll,
          min: 0,
          max: 48,
          divisions: 48,
          valueLabel: 'EdgeInsets.all(${_marginAll.round()})',
          onChanged: (v) => setState(() => _marginAll = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Override contentPadding'),
          value: _useCustomContentPadding,
          onChanged: (v) => setState(() => _useCustomContentPadding = v),
        ),
        if (_useCustomContentPadding) ...[
          _buildSliderRow(
            label: 'contentPadding Horizontal',
            value: _contentPaddingHorizontal,
            min: 4,
            max: 48,
            divisions: 44,
            valueLabel: '${_contentPaddingHorizontal.round()} px',
            onChanged: (v) => setState(() => _contentPaddingHorizontal = v),
          ),
          _buildSliderRow(
            label: 'contentPadding Vertical',
            value: _contentPaddingVertical,
            min: 4,
            max: 64,
            divisions: 60,
            valueLabel: '${_contentPaddingVertical.round()} px',
            onChanged: (v) => setState(() => _contentPaddingVertical = v),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Colors Section
  // ---------------------------------------------------------------------------
  Widget _buildColorsSection() {
    return _buildSectionCard(
      title: '4. Colors & Ink Interaction Effects',
      icon: Icons.palette_outlined,
      children: [
        _buildColorSelector(
          label: 'sideBarColor (Sidebar Background)',
          currentColor: _sideBarColor,
          onSelect: (c) => setState(() => _sideBarColor = c),
        ),
        _buildColorSelector(
          label: 'animatedContainerColor (Floating Selection Indicator)',
          currentColor: _animatedContainerColor,
          onSelect: (c) => setState(() => _animatedContainerColor = c),
        ),
        _buildColorSelector(
          label: 'selectedIconColor',
          currentColor: _selectedIconColor,
          onSelect: (c) => setState(() => _selectedIconColor = c),
        ),
        _buildColorSelector(
          label: 'unselectedIconColor',
          currentColor: _unselectedIconColor,
          onSelect: (c) => setState(() => _unselectedIconColor = c),
        ),
        _buildColorSelector(
          label: 'unSelectedTextColor',
          currentColor: _unSelectedTextColor,
          onSelect: (c) => setState(() => _unSelectedTextColor = c),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Custom disabledIconColor'),
          value: _useCustomDisabledIconColor,
          onChanged: (v) => setState(() => _useCustomDisabledIconColor = v),
        ),
        if (_useCustomDisabledIconColor)
          _buildColorSelector(
            label: 'disabledIconColor',
            currentColor: _disabledIconColor,
            onSelect: (c) => setState(() => _disabledIconColor = c),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Custom disabledTextColor'),
          value: _useCustomDisabledTextColor,
          onChanged: (v) => setState(() => _useCustomDisabledTextColor = v),
        ),
        if (_useCustomDisabledTextColor)
          _buildColorSelector(
            label: 'disabledTextColor',
            currentColor: _disabledTextColor,
            onSelect: (c) => setState(() => _disabledTextColor = c),
          ),
        _buildColorSelector(
          label: 'hoverColor (Item Hover Ink)',
          currentColor: _hoverColor,
          onSelect: (c) => setState(() => _hoverColor = c),
        ),
        _buildColorSelector(
          label: 'splashColor (Item Tap Splash)',
          currentColor: _splashColor,
          onSelect: (c) => setState(() => _splashColor = c),
        ),
        _buildColorSelector(
          label: 'highlightColor (Item Press Highlight)',
          currentColor: _highlightColor,
          onSelect: (c) => setState(() => _highlightColor = c),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Typography Section
  // ---------------------------------------------------------------------------
  Widget _buildTypographySection() {
    return _buildSectionCard(
      title: '5. Typography & Text Styles',
      icon: Icons.text_fields,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Custom Base textStyle'),
          value: _useCustomTextStyle,
          onChanged: (v) => setState(() => _useCustomTextStyle = v),
        ),
        if (_useCustomTextStyle) ...[
          _buildSliderRow(
            label: 'Base Font Size',
            value: _baseFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${_baseFontSize.round()} pt',
            onChanged: (v) => setState(() => _baseFontSize = v),
          ),
          _buildDropdownRow<FontWeight>(
            label: 'Base Font Weight',
            value: _baseFontWeight,
            items: const [
              DropdownMenuItem(
                  value: FontWeight.w300, child: Text('Light (w300)')),
              DropdownMenuItem(
                  value: FontWeight.normal, child: Text('Regular (w400)')),
              DropdownMenuItem(
                  value: FontWeight.w500, child: Text('Medium (w500)')),
              DropdownMenuItem(
                  value: FontWeight.w600, child: Text('SemiBold (w600)')),
              DropdownMenuItem(
                  value: FontWeight.bold, child: Text('Bold (w700)')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _baseFontWeight = v);
            },
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Custom selectedTextStyle'),
          value: _useCustomSelectedTextStyle,
          onChanged: (v) => setState(() => _useCustomSelectedTextStyle = v),
        ),
        if (_useCustomSelectedTextStyle) ...[
          _buildSliderRow(
            label: 'Selected Font Size',
            value: _selectedFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${_selectedFontSize.round()} pt',
            onChanged: (v) => setState(() => _selectedFontSize = v),
          ),
          _buildDropdownRow<FontWeight>(
            label: 'Selected Font Weight',
            value: _selectedFontWeight,
            items: const [
              DropdownMenuItem(
                  value: FontWeight.normal, child: Text('Regular (w400)')),
              DropdownMenuItem(
                  value: FontWeight.w500, child: Text('Medium (w500)')),
              DropdownMenuItem(
                  value: FontWeight.w600, child: Text('SemiBold (w600)')),
              DropdownMenuItem(
                  value: FontWeight.bold, child: Text('Bold (w700)')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _selectedFontWeight = v);
            },
          ),
          _buildColorSelector(
            label: 'Selected Text Color',
            currentColor: _selectedTextColor,
            onSelect: (c) => setState(() => _selectedTextColor = c),
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Custom disabledTextStyle'),
          value: _useCustomDisabledTextStyle,
          onChanged: (v) => setState(() => _useCustomDisabledTextStyle = v),
        ),
        if (_useCustomDisabledTextStyle) ...[
          _buildSliderRow(
            label: 'Disabled Font Size',
            value: _disabledFontSize,
            min: 11,
            max: 24,
            divisions: 13,
            valueLabel: '${_disabledFontSize.round()} pt',
            onChanged: (v) => setState(() => _disabledFontSize = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Italicize Disabled Items'),
            value: _disabledFontItalic,
            onChanged: (v) => setState(() => _disabledFontItalic = v),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Divider Settings Section
  // ---------------------------------------------------------------------------
  Widget _buildDividerSection() {
    return _buildSectionCard(
      title: '6. Trailing Divider Settings',
      icon: Icons.horizontal_rule,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Settings Divider (settingsDivider)'),
          subtitle:
              const Text('Renders a divider before the final navigation item'),
          value: _settingsDivider,
          onChanged: (v) => setState(() => _settingsDivider = v),
        ),
        if (_settingsDivider) ...[
          _buildSliderRow(
            label: 'dividerHeight (Total vertical space allocated)',
            value: _dividerHeight,
            min: 2,
            max: 48,
            divisions: 46,
            valueLabel: '${_dividerHeight.round()} px',
            onChanged: (v) => setState(() => _dividerHeight = v),
          ),
          _buildSliderRow(
            label: 'dividerThickness (Line stroke thickness)',
            value: _dividerThickness,
            min: 0.2,
            max: 6.0,
            divisions: 29,
            valueLabel: '${_dividerThickness.toStringAsFixed(1)} px',
            onChanged: (v) => setState(() => _dividerThickness = v),
          ),
          _buildColorSelector(
            label: 'dividerColor',
            currentColor: _dividerColor,
            onSelect: (c) => setState(() => _dividerColor = c),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Header, Footer, Toggle Button & Scroll Physics Section
  // ---------------------------------------------------------------------------
  Widget _buildSlotsAndToggleSection() {
    return _buildSectionCard(
      title: '7. Header, Footer, Toggle Button & Scroll Physics',
      icon: Icons.view_sidebar_outlined,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Header Widget (headerWidget)'),
          value: _showHeaderWidget,
          onChanged: (v) => setState(() => _showHeaderWidget = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Footer Widget (footerWidget)'),
          value: _showFooterWidget,
          onChanged: (v) => setState(() => _showFooterWidget = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Collapse Toggle Button (showToggleButton)'),
          value: _showToggleButton,
          onChanged: (v) => setState(() => _showToggleButton = v),
        ),
        if (_showToggleButton) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
                'Use Custom Toggle Widgets (expandedToggleWidget / collapsedToggleWidget)'),
            value: _useCustomToggleWidgets,
            onChanged: (v) => setState(() => _useCustomToggleWidgets = v),
          ),
          if (!_useCustomToggleWidgets)
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _buildDropdownRow<String>(
                  label: 'expandedToggleIcon',
                  value: _expandedToggleIconKey,
                  items: _toggleIconOptions.keys
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _expandedToggleIconKey = v);
                    }
                  },
                ),
                _buildDropdownRow<String>(
                  label: 'collapsedToggleIcon',
                  value: _collapsedToggleIconKey,
                  items: _toggleIconOptions.keys
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _collapsedToggleIconKey = v);
                    }
                  },
                ),
              ],
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Custom toggleButtonColor'),
            value: _useCustomToggleButtonColor,
            onChanged: (v) => setState(() => _useCustomToggleButtonColor = v),
          ),
          if (_useCustomToggleButtonColor)
            _buildColorSelector(
              label: 'toggleButtonColor',
              currentColor: _toggleButtonColor,
              onSelect: (c) => setState(() => _toggleButtonColor = c),
            ),
        ],
        const SizedBox(height: 8),
        _buildDropdownRow<String>(
          label: 'Scroll Physics (scrollPhysics)',
          value: _scrollPhysicsKey,
          items: const [
            DropdownMenuItem(
                value: 'bouncing', child: Text('BouncingScrollPhysics')),
            DropdownMenuItem(
                value: 'clamping', child: Text('ClampingScrollPhysics')),
            DropdownMenuItem(
                value: 'never', child: Text('NeverScrollableScrollPhysics')),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _scrollPhysicsKey = v);
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 8. Sidebar Items Configuration Section
  // ---------------------------------------------------------------------------
  Widget _buildItemsConfigSection() {
    return _buildSectionCard(
      title: '8. Sidebar Items (SideBarItem Properties)',
      icon: Icons.list_alt,
      children: [
        const Text(
          'Toggle isDisabled, tooltips, or add/remove items dynamically:',
          style: TextStyle(fontSize: 13, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        ...List.generate(_sidebarItems.length, (index) {
          final item = _sidebarItems[index];
          return Card(
            color: const Color(0xff262626),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(item.iconSelected, color: Colors.white),
              title: Text(item.text),
              subtitle: Text('Tooltip: ${item.tooltip ?? "(none)"}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Disabled:', style: TextStyle(fontSize: 12)),
                  Switch(
                    value: item.isDisabled,
                    onChanged: (disabled) {
                      setState(() {
                        _sidebarItems[index] = SideBarItem(
                          iconSelected: item.iconSelected,
                          iconUnselected: item.iconUnselected,
                          text: item.text.replaceAll(' (Disabled)', ''),
                          isDisabled: disabled,
                          tooltip: item.tooltip,
                        );
                      });
                    },
                  ),
                  if (_sidebarItems.length > 2)
                    IconButton(
                      tooltip: 'Remove item',
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _sidebarItems.removeAt(index);
                          if (_controller.selectedIndex >=
                              _sidebarItems.length) {
                            _controller.selectIndex(
                              _sidebarItems.length - 1,
                              transitionType: SideBarTransitionType.none,
                            );
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  final nextNum = _sidebarItems.length + 1;
                  _sidebarItems.insert(
                    _sidebarItems.length - 1,
                    SideBarItem(
                      iconSelected: Icons.folder,
                      iconUnselected: Icons.folder_outlined,
                      text: 'Project $nextNum',
                      tooltip: 'Custom item #$nextNum',
                    ),
                  );
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Navigation Item'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _sidebarItems = _defaultItems();
                  _controller.selectIndex(0,
                      transitionType: SideBarTransitionType.none);
                });
              },
              icon: const Icon(Icons.restore),
              label: const Text('Reset Items'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // UI Helper Builders
  // ---------------------------------------------------------------------------
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff2C2C2C)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Icon(icon, color: Colors.deepPurpleAccent),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff262626),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff383838)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
              Text(
                valueLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
        const SizedBox(width: 8),
        DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorSelector({
    required String label,
    required Color currentColor,
    required ValueChanged<Color> onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetSwatches.map((color) {
              final isSelected = currentColor.toARGB32() == color.toARGB32();
              return InkWell(
                onTap: () => onSelect(color),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.deepPurpleAccent
                          : Colors.white24,
                      width: isSelected ? 2.5 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
