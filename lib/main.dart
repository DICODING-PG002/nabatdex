import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_provider/navigation_provider.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const NabatDexApp(),
    ),
  );
}

class NabatDexApp extends StatelessWidget {
  const NabatDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NabatDex',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initialRoutes,
      routes: AppRoutes.routes,
    );
  }
}
