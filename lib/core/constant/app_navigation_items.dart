import 'package:nabatdex/core/model/navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:nabatdex/features/journal/presentation/screen/journal_home_screen.dart';

class AppNavigationItems {
  AppNavigationItems._();

  static List<NavbarItem> get listItem => [
    NavbarItem(
      icon: Icons.book_outlined,
      label: 'Jurnal',
      page: JournalHomeScreen(),
      key: Key('journal_screen'),
    ),
    NavbarItem(
      icon: Icons.person_outline,
      label: 'Ensiklopedia',
      page: Scaffold(
        body: Center(
          child: Text(
            "Untuk menampilkan halaman Ensiklopedia, ubah properti page di lib/core/constant/app_navigation_items menjadi Screen nya",
          ),
        ),
      ),
      key: Key('ensiklopedia_screen'),
    ),
  ];
}
