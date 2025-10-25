import 'package:nabatdex/core/model/navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:nabatdex/features/journal/presentation/screen/journal_home_screen.dart';
import 'package:nabatdex/features/ensiklopedia/presentation/screen/encyclopedia_page.dart';

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
      icon: Icons.menu_book_outlined,
      label: 'Ensiklopedia',
      page: const EncyclopediaPage(),
      key: Key('ensiklopedia_screen'),
    ),
  ];
}
