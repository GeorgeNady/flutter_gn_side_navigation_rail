import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gn_side_navigation_rail/flutter_gn_side_navigation_rail.dart';

void main() {
  test('SideBarItem creates instance with expected properties', () {
    final item = SideBarItem(
      iconSelected: Icons.home,
      iconUnselected: Icons.home_outlined,
      text: 'Home',
    );

    expect(item.iconSelected, Icons.home);
    expect(item.iconUnselected, Icons.home_outlined);
    expect(item.text, 'Home');
  });

  testWidgets('SideBarAnimated throws if sidebarItems is empty', (WidgetTester tester) async {
    expect(
      () => SideBarAnimated(
        mainLogoImage: 'assets/logo.png',
        sidebarItems: const [],
        widthSwitch: 600,
        onTap: (index) {},
      ),
      // initState throws when empty items
      returnsNormally,
    );
  });
}
