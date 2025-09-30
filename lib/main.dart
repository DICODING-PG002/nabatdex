import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_provider/app_provider.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppProvider.globalProviders,
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
      //TODO: Add Option to maintain font size across different font system settings
    );
  }
}
