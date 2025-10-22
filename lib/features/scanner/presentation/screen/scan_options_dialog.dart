import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/providers/image_scan_provider.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_body.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_content.dart';
import 'package:provider/provider.dart';

class ScanOptionsDialog extends StatefulWidget {
  const ScanOptionsDialog({super.key});

  @override
  State<ScanOptionsDialog> createState() => _ScanOptionsDialogState();
}

class _ScanOptionsDialogState extends State<ScanOptionsDialog> {
  bool _isProcessing = false;

  /// Handler untuk memilih gambar dan navigate ke loading screen
  Future<void> _pickImageAndNavigate(BuildContext context, ImageSource source) async {
    // Cegah multiple clicks
    if (_isProcessing) return;

    if (mounted) {
      setState(() {
        _isProcessing = true;
      });
    }

    final imageProvider = Provider.of<ImageScanProvider>(context, listen: false);

    // Tutup dialog scan options terlebih dahulu
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Navigate ke loading screen
    if (context.mounted) {
      Navigator.of(context).pushNamed(AppRoutes.scannerLoading);
    }

    // Mulai proses pick & resize image di background
    // Loading screen akan listen ke state changes dan auto-navigate ke preview
    final bool isSuccess = await imageProvider.pickImage(source);

    if (!isSuccess && context.mounted) {
      // pop loading screen Jika user membatalkan pemilihan gambar, 
      final state = imageProvider.state;
      if (state is ImageInitial) {
        debugPrint('User membatalkan pemilihan gambar');
        Navigator.of(context).pop();
      }
    }

    // Check mounted sebelum setState untuk menghindari error
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogBody(
      dialogContent: DialogContent(
        dialogContentChildren: [
          Text(
            'Mulai Scan Prediksi',
            style: TextTheme.of(
              context,
            ).headlineMedium?.copyWith(color: AppTheme.accentColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Penting! Perhatikan hal berikut sebelum mulai scan prediksi:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Foto harus pada bagian daun tanaman (jika tidak, prediksi tidak bisa berjalan)\n• Gunakan pencahayaan yang baik agar hasil lebih akurat',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),

          //Pilihan Scan
          ElevatedButton.icon(
            onPressed: _isProcessing ? null : () {
              // Ambil gambar dari kamera
              _pickImageAndNavigate(context, ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Ambil dari Kamera'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF63A088),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isProcessing ? null : () {
              // Pilih gambar dari galeri
              _pickImageAndNavigate(context, ImageSource.gallery);
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Pilih dari Galeri'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF63A088),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          // Cancel button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _isProcessing ? Colors.grey : AppTheme.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
