import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_provider/navigation_provider.dart';
import 'package:nabatdex/common/shared_widgets/app_bottom_navbar.dart';
import 'package:nabatdex/core/model/navbar_item.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationItems});

  final List<NavbarItem> navigationItems;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = Provider.of<NavigationProvider>(
      context,
    ).selectedIndex;

    return Scaffold(
      body: navigationItems[selectedIndex].page,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/screen');
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AppBottomNavbar(
        items: navigationItems,
        currentIndex: selectedIndex,
        onTabTapped: (index) {
          Provider.of<NavigationProvider>(
            context,
            listen: false,
          ).setIndex(index);
        },
      ),
    );
  }
}
