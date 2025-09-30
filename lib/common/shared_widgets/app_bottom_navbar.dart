import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/navbar_item.dart';
import 'package:flutter/material.dart';

class AppBottomNavbar extends StatelessWidget {
  final List<NavbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const AppBottomNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppTheme.primaryColor,
      child: Row(
        children: [
          _buildNavItem(item: items[0], index: 0),
          const SizedBox(width: 80),
          _buildNavItem(item: items[1], index: 1),
        ],
      ),
    );
  }

  // Helper method untuk membangun setiap item navigasi
  Widget _buildNavItem({required NavbarItem item, required int index}) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = Colors.white;
    final Color selectedBgColor = AppTheme.secondaryColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTabTapped(index),
        highlightColor: selectedBgColor.withValues(alpha: 0.3),
        splashColor: selectedBgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: itemColor, size: 20),
              if (item.label.isNotEmpty) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
