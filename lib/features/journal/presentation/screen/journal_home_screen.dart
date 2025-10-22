import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_provider/journal_refresh_provider.dart';
import 'package:nabatdex/common/shared_provider/plant_database_provider.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:provider/provider.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
      dbProvider.loadAllJournalEntries();
      
      final refreshProvider = Provider.of<JournalRefreshProvider>(context, listen: false);
      refreshProvider.addListener(_onRefreshRequested);
    });
  }

  @override
  void dispose() {
    final refreshProvider = Provider.of<JournalRefreshProvider>(context, listen: false);
    refreshProvider.removeListener(_onRefreshRequested);
    super.dispose();
  }

  void _onRefreshRequested() {
    final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
    dbProvider.loadAllJournalEntries();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Consumer<PlantDatabaseProvider>(
        builder: (context, dbProvider, child) {
          final journalState = dbProvider.journalState;
          
          if (journalState is JournalLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }
          
          if (journalState is JournalError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    journalState.message,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          final journalEntries = dbProvider.journalEntries;
          
          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jurnal Tanaman", style: TextTheme.of(context).displaySmall),
                    Text(
                      "Lihat tanaman yang anda sudah scan disini",
                      style: TextTheme.of(
                        context,
                      ).titleSmall?.copyWith(color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 32),

                    if (journalEntries.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              'Belum ada jurnal',
                              style: TextTheme.of(context).titleMedium?.copyWith(
                                color: AppTheme.textColor.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mulai scan tanaman untuk membuat jurnal',
                              style: TextTheme.of(context).bodySmall?.copyWith(
                                color: AppTheme.textColor.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: journalEntries.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entry = journalEntries[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.journalPlant,
                                arguments: entry,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dialogTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 12,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.2,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: File(entry.imagePath).existsSync()
                                            ? Image.file(
                                                File(entry.imagePath),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/image/image_not_found.png',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 4,
                                      children: [
                                        Text(
                                          entry.plantName,
                                          style: TextTheme.of(context).titleLarge?.copyWith(
                                            color: AppTheme.whiteColor,
                                          ),
                                        ),
                                        Text(
                                          entry.isHealthy
                                              ? "Tanaman Sehat"
                                              : "Terindikasi Penyakit ${entry.diseaseName}",
                                          style: TextTheme.of(
                                            context,
                                          ).bodySmall?.copyWith(color: AppTheme.whiteColor),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            Icon(
                                              Symbols.schedule,
                                              color: AppTheme.whiteColor.withValues(
                                                alpha: 0.4,
                                              ),
                                              size: 14,
                                            ),
                                            Text(
                                              entry.formattedDate,
                                              style: TextTheme.of(context).bodySmall
                                                  ?.copyWith(
                                                    color: AppTheme.whiteColor.withValues(
                                                      alpha: 0.4,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    entry.isHealthy ? Symbols.check_circle : Symbols.syringe,
                                    color: entry.isHealthy 
                                        ? AppTheme.secondaryColor 
                                        : AppTheme.errorColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
