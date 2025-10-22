import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/providers/image_scan_provider.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/image_processing_loader.dart';
import 'package:provider/provider.dart';

/// Screen loading yang ditampilkan saat memproses gambar
/// Akan otomatis navigate ke preview screen ketika proses selesai
class ImageLoadingScreen extends StatefulWidget {
  const ImageLoadingScreen({super.key});

  @override
  State<ImageLoadingScreen> createState() => _ImageLoadingScreenState();
}

class _ImageLoadingScreenState extends State<ImageLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Listen ke perubahan state dari provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToImageState();
    });
  }

  /// Listen ke state changes dari ImageScanProvider
  void _listenToImageState() {
    final provider = Provider.of<ImageScanProvider>(context, listen: false);
    
    // Add listener untuk auto-navigate ketika state berubah
    provider.addListener(_onImageStateChanged);
  }

  /// Callback ketika state berubah
  void _onImageStateChanged() {
    if (!mounted) return;

    final provider = Provider.of<ImageScanProvider>(context, listen: false);
    final state = provider.state;

    if (state is ImageLoaded) {
      // Gambar berhasil diproses, navigate ke preview screen
      debugPrint('Navigasi ke preview screen');
      
      // Remove listener sebelum navigate
      provider.removeListener(_onImageStateChanged);
      
      // Navigate dengan replacement agar user tidak bisa back ke loading screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.scannerPreview);
    } else if (state is ImageError) {
      // Terjadi error saat memproses gambar
      debugPrint('Error saat memproses gambar: ${state.message}');
      
      // Remove listener
      provider.removeListener(_onImageStateChanged);
      
      // Tampilkan error dan back
      _showErrorAndBack(state.message);
    }
  }

  /// Tampilkan error dialog dan kembali ke screen sebelumnya
  void _showErrorAndBack(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.whiteColor,
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Gagal',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
        content: Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Back to previous screen
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan listener di-remove saat widget di-dispose
    final provider = Provider.of<ImageScanProvider>(context, listen: false);
    provider.removeListener(_onImageStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Loading widget
              const ImageProcessingLoader(
                message: 'Sedang memproses gambar',
                size: 56.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

