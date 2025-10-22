import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/providers/image_scan_provider.dart';
import 'package:nabatdex/features/scanner/presentation/providers/prediction_provider.dart';
import 'package:provider/provider.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const MainAppBar(title: "Preview Gambar"),
      body: Consumer<ImageScanProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          // Jika sedang loading (proses resize/crop)
          if (state is ImageLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memproses gambar...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          // Jika tidak ada gambar, tampilkan pesan error
          if (provider.imageFile == null) {
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
                    'Tidak ada gambar yang dipilih',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info Card
                  Card(
                    color: AppTheme.whiteColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pastikan foto daun jelas dengan pencahayaan yang baik',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Preview Image Container
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1, // 1:1 ratio
                        child: Image.file(
                          File(provider.imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Image Size Info
                  Center(
                    child: Text(
                      'Ukuran gambar: 256 x 256 px',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.bodyTextColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Analyze Button
                  ElevatedButton.icon(
                    onPressed: () {
                      _handleAnalyze(context, provider);
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('Analisis Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.whiteColor,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      // Clear image dan kembali
                      provider.clearImage();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Batal',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAnalyze(BuildContext context, ImageScanProvider provider) {
    if (provider.imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada gambar untuk dianalisis'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final predictionProvider = Provider.of<PredictionProvider>(
      context,
      listen: false,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.predictionLoading,
      arguments: {
        'imagePath': provider.imageFile!.path,
        'predictionProvider': predictionProvider,
      },
    );
  }
}

