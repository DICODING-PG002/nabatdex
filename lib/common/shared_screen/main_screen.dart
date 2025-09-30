import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_provider/navigation_provider.dart';
import 'package:nabatdex/common/shared_widgets/app_bottom_navbar.dart';
import 'package:nabatdex/core/model/navbar_item.dart';
import 'package:nabatdex/features/scanner/presentation/screen/scan_options_dialog.dart';
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
          showGeneralDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            barrierDismissible: true,
            barrierLabel: 'ScanOptionsDialog',
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, __, ___) {
              return ScanOptionsDialog();
            },
          );
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
