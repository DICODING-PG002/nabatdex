import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_provider/plant_database_provider.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
import 'package:nabatdex/features/journal/presentation/providers/plant_activity_provider.dart';
import 'package:nabatdex/features/journal/presentation/screen/activity_form_screen.dart';
import 'package:nabatdex/features/journal/presentation/widgets/activity_card.dart';
import 'package:nabatdex/features/journal/presentation/widgets/journal_action_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PlantJournalScreen extends StatefulWidget {
  final JournalEntryModel journalEntry;

  const PlantJournalScreen({
    super.key,
    required this.journalEntry,
  });

  @override
  State<PlantJournalScreen> createState() => _PlantJournalScreenState();
}

class _PlantJournalScreenState extends State<PlantJournalScreen> {
  bool _isSolutionExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.journalEntry.diseaseName != null) {
        final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
        dbProvider.loadDiseaseByName(widget.journalEntry.diseaseName!);
      }
      
      final activityProvider = Provider.of<PlantActivityProvider>(context, listen: false);
      activityProvider.loadActivities(widget.journalEntry.id!);
    });
  }

  @override
  void dispose() {
    final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
    dbProvider.clearDiseaseData();
    
    final activityProvider = Provider.of<PlantActivityProvider>(context, listen: false);
    activityProvider.clearActivities();
    
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(int activityId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.whiteColor,
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus aktivitas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final activityProvider = Provider.of<PlantActivityProvider>(context, listen: false);
      final success = await activityProvider.deleteActivity(
        activityId,
        widget.journalEntry.id!,
      );

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aktivitas berhasil dihapus'),
            backgroundColor: AppTheme.secondaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "Jurnal Tanaman"),
      body: Consumer<PlantDatabaseProvider>(
        builder: (context, dbProvider, child) {
          final diseaseState = dbProvider.diseaseState;
          final diseaseData = dbProvider.currentDisease;
          
          final isLoading = widget.journalEntry.diseaseName != null && 
                           diseaseState is DiseaseLoading;
          
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }
          
          return SingleChildScrollView(
              child: Column(
                children: [
                  File(widget.journalEntry.imagePath).existsSync()
                      ? Image.file(
                          File(widget.journalEntry.imagePath),
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/image/image_not_found.png',
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.journalEntry.plantName,
                                    style: TextTheme.of(context).headlineLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.journalEntry.isHealthy
                                        ? 'Tanaman sehat (${widget.journalEntry.confidencePercentage})'
                                        : 'Terindikasi penyakit ${widget.journalEntry.diseaseName} (${widget.journalEntry.confidencePercentage})',
                                    style: TextTheme.of(context).titleMedium,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              widget.journalEntry.isHealthy
                                  ? Symbols.check_circle
                                  : Symbols.syringe,
                              color: widget.journalEntry.isHealthy
                                  ? AppTheme.secondaryColor
                                  : AppTheme.errorColor,
                              size: 40,
                            ),
                          ],
                        ),

                        if (!widget.journalEntry.isHealthy &&
                            diseaseData != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            diseaseData.cause,
                            textAlign: TextAlign.justify,
                            style: TextTheme.of(context).bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                'Solusi & Pengendalian',
                                style: TextTheme.of(context).titleLarge,
                              ),
                              tilePadding: EdgeInsets.zero,
                              initiallyExpanded: _isSolutionExpanded,
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _isSolutionExpanded = expanded;
                                });
                              },
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 0, 16.0, 16.0),
                                  child: Text(
                                    diseaseData.controlSolution,
                                    textAlign: TextAlign.justify,
                                    style: TextTheme.of(context).bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (widget.journalEntry.isHealthy) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Tanaman Anda dalam kondisi sehat! Lanjutkan perawatan rutin untuk menjaga kesehatan tanaman.',
                            textAlign: TextAlign.justify,
                            style: TextTheme.of(context).bodyMedium,
                          ),
                          const SizedBox(height: 24),
                        ],

                        Consumer<PlantActivityProvider>(
                          builder: (context, activityProvider, child) {
                            final activityState = activityProvider.state;
                            final activities = activityProvider.activities;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Aktivitas Perawatan',
                                      style: TextTheme.of(context).titleLarge,
                                    ),
                                    if (activityState is ActivityLoading)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                if (activities.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        Text(
                                          'Belum ada aktivitas perawatan',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: AppTheme.bodyTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Mulai catat aktivitas perawatan tanaman Anda dengan menekan tombol + di bawah',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppTheme.bodyTextColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: activities.length,
                                    itemBuilder: (context, index) {
                                      final activity = activities[index];
                                      return ActivityCard(
                                        activity: activity,
                                        onEdit: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ActivityFormScreen(
                                                journalEntryId: widget.journalEntry.id!,
                                                existingActivity: activity,
                                              ),
                                            ),
                                          );
                                        },
                                        onDelete: () => _showDeleteConfirmation(activity.id!),
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                    ),
                  ],
                ),
              );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => JournalActionBottomSheet(
              journalEntry: widget.journalEntry,
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, size: 32, color: AppTheme.accentColor),
      ),
    );
  }
}