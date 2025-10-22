import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_provider/plant_database_provider.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
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
  bool _isActivityExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.journalEntry.diseaseName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
        dbProvider.loadDiseaseByName(widget.journalEntry.diseaseName!);
      });
    }
  }

  @override
  void dispose() {
    final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
    dbProvider.clearDiseaseData();
    super.dispose();
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

                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(
                              'Aktivitas Perawatan Anda',
                              style: TextTheme.of(context).titleLarge,
                            ),
                            tilePadding: EdgeInsets.zero,
                            initiallyExpanded: _isActivityExpanded,
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _isActivityExpanded = expanded;
                              });
                            },
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 0, 16.0, 16.0),
                                child: Text(
                                  'Mulai lakukan pencatatan aktivitas anda merawat tanaman ini dengan menyimpan hasil prediksi ke jurnal anda',
                                  style: TextTheme.of(context).bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),
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
          debugPrint('Tombol plus ditekan!');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, size: 32, color: AppTheme.accentColor),
      ),
    );
  }
}