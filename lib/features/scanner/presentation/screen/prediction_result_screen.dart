import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_provider/journal_refresh_provider.dart';
import 'package:nabatdex/common/shared_provider/plant_database_provider.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/journal_entry_model.dart';
import 'package:nabatdex/core/model/prediction_result_model.dart';
import 'package:provider/provider.dart';

class PredictionResultScreen extends StatefulWidget {
  final PredictionResultModel result;

  const PredictionResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<PredictionResultScreen> createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  bool _isSaving = false;

  Future<void> _saveToJournal() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final journalEntry = JournalEntryModel(
        plantName: widget.result.plantData?.commonName ?? widget.result.predictedPlantName,
        diseaseName: widget.result.diseaseName,
        confidenceLevel: widget.result.confidenceLevel,
        imagePath: widget.result.imagePath,
        scanDate: DateTime.now(),
        isHealthy: widget.result.isHealthy,
        plantId: widget.result.plantData?.id,
        diseaseId: widget.result.diseaseData?.id,
      );

      final dbProvider = Provider.of<PlantDatabaseProvider>(context, listen: false);
      final success = await dbProvider.saveJournalEntry(journalEntry);

      if (mounted && success) {
        Provider.of<JournalRefreshProvider>(context, listen: false).notifyJournalUpdate();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Berhasil disimpan ke jurnal'),
            backgroundColor: AppTheme.secondaryColor,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              textColor: AppTheme.whiteColor,
              onPressed: () {},
            ),
          ),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantData = widget.result.plantData;
    final diseaseData = widget.result.diseaseData;
    final isHealthy = widget.result.isHealthy;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const MainAppBar(title: "Hasil Prediksi"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(widget.result.imagePath),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppTheme.whiteColor,
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
                              plantData?.commonName ?? widget.result.predictedPlantName.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isHealthy
                                  ? 'Tanaman anda sehat (${widget.result.confidencePercentage})'
                                  : 'Terindikasi penyakit ${diseaseData?.name ?? widget.result.diseaseName} (${widget.result.confidencePercentage})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isHealthy ? Symbols.check_circle : Symbols.syringe,
                        color: isHealthy ? AppTheme.secondaryColor : AppTheme.errorColor,
                        size: 40,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (!isHealthy && diseaseData != null) ...[
                    Text(
                      diseaseData.cause,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Solusi & Pengendalian',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diseaseData.controlSolution,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text(
                    'Aktivitas Perawatan Anda',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai lakukan pencatatan aktivitas anda merawat tanaman ini dengan menyimpan hasil prediksi ke jurnal anda',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: _isSaving ? null : _saveToJournal,
            backgroundColor: _isSaving ? Colors.grey : AppTheme.primaryColor,
            label: _isSaving
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.whiteColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Menyimpan...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.whiteColor,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Simpan Ke Jurnal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.whiteColor,
                    ),
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
