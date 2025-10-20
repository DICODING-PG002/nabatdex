import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/core/model/prediction_result_model.dart';

class PredictionResultScreen extends StatelessWidget {
  final PredictionResultModel result;

  const PredictionResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final plantData = result.plantData;
    final diseaseData = result.diseaseData;
    final isHealthy = result.isHealthy;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const MainAppBar(title: "Hasil Prediksi"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(result.imagePath),
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
                              plantData?.commonName ?? result.predictedPlantName.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isHealthy
                                  ? 'Tanaman anda sehat (${result.confidencePercentage})'
                                  : 'Terindikasi penyakit ${diseaseData?.name ?? result.diseaseName} (${result.confidencePercentage})',
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
            onPressed: () {
              debugPrint('Simpan Ke Jurnal ditekan');
            },
            backgroundColor: AppTheme.primaryColor,
            label: Text(
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
