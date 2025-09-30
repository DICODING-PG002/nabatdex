import 'package:flutter/widgets.dart';

class NavbarItem {
  final IconData icon;
  final String label;
  final Widget page;
  final Key key;

  const NavbarItem({
    required this.icon,
    required this.label,
    required this.page,
    required this.key,
  });
}
