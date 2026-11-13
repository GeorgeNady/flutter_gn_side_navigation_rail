import 'package:flutter/material.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GN Side Navigation Rail Demo',
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
  SideBarTransitionType _transitionType = SideBarTransitionType.slide;

  final List<SideBarItem> _sidebarItems = [
    const SideBarItem(
      iconSelected: Icons.dashboard,
      iconUnselected: Icons.dashboard_outlined,
      text: 'Dashboard',
    ),
    const SideBarItem(
      iconSelected: Icons.analytics,
      iconUnselected: Icons.analytics_outlined,
      text: 'Analytics',
    ),
    const SideBarItem(
      iconSelected: Icons.notifications,
      iconUnselected: Icons.notifications_none,
      text: 'Notifications',
    ),
    const SideBarItem(
      iconSelected: Icons.chat_bubble,
      iconUnselected: Icons.chat_bubble_outline,
      text: 'Messages',
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
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = SideBarController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final activeItem = _sidebarItems[_controller.selectedIndex];

        return Scaffold(
          body: Row(
            children: [
              SideBarAnimated(
                controller: _controller,
                widthSwitch: 700,
                sidebarItems: _sidebarItems,
                transitionType: _transitionType,
                itemTransitionDuration: const Duration(milliseconds: 400),
                itemTransitionCurve: Curves.easeOutCubic,
                headerWidget: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 44,
                      height: 44,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.rocket_launch,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                    if (!_controller.isMinimized) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'MyApp',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
                expandedToggleIcon: Icons.menu_open,
                collapsedToggleIcon: Icons.menu,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(activeItem.iconSelected,
                                  size: 32, color: Colors.white),
                              const SizedBox(width: 16),
                              Text(
                                activeItem.text,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: () => _controller.toggleMinimize(),
                                icon: Icon(_controller.isMinimized
                                    ? Icons.unfold_more
                                    : Icons.unfold_less),
                                label: Text(_controller.isMinimized
                                    ? 'Expand Rail'
                                    : 'Collapse Rail'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xff323232)),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to ${activeItem.text}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Transition Animation Control:\n'
                            'Choose an animation style below to control how the selection indicator transitions when switching items.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: SideBarTransitionType.values
                                .where((t) => t != SideBarTransitionType.custom)
                                .map((type) {
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
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xff323232)),
                          const SizedBox(height: 16),
                          const Text(
                            'Programmatic Navigation with Transition Overrides:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
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
                            ],
                          ),
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
}
