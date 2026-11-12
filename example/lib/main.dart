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
  int _selectedIndex = 0;

  final List<SideBarItem> _sidebarItems = [
    SideBarItem(
      iconSelected: Icons.dashboard,
      iconUnselected: Icons.dashboard_outlined,
      text: 'Dashboard',
    ),
    SideBarItem(
      iconSelected: Icons.analytics,
      iconUnselected: Icons.analytics_outlined,
      text: 'Analytics',
    ),
    SideBarItem(
      iconSelected: Icons.notifications,
      iconUnselected: Icons.notifications_none,
      text: 'Notifications',
    ),
    SideBarItem(
      iconSelected: Icons.chat_bubble,
      iconUnselected: Icons.chat_bubble_outline,
      text: 'Messages',
    ),
    SideBarItem(
      iconSelected: Icons.settings,
      iconUnselected: Icons.settings_outlined,
      text: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeItem = _sidebarItems[_selectedIndex];

    return Scaffold(
      body: Row(
        children: [
          SideBarAnimated(
            mainLogoImage: 'assets/logo.png',
            widthSwitch: 700,
            sidebarItems: _sidebarItems,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(activeItem.iconSelected, size: 32, color: Colors.white),
                        const SizedBox(width: 16),
                        Text(
                          activeItem.text,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xff323232)),
                    const SizedBox(height: 24),
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
                      'This screen demonstrates flutter_gn_side_navigation_rail in action.\n\n'
                      '• Try clicking different items to watch the floating selection indicator animate.\n'
                      '• Resize your window below 700px width or click the toggle button at the bottom of the sidebar to collapse/expand.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
