import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/providers/image_scan_provider.dart';
import 'package:nabatdex/features/scanner/presentation/screen/image_preview_screen.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_body.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_content.dart';
import 'package:provider/provider.dart';

class ScanOptionsDialog extends StatefulWidget {
  const ScanOptionsDialog({super.key});

  @override
  State<ScanOptionsDialog> createState() => _ScanOptionsDialogState();
}

class _ScanOptionsDialogState extends State<ScanOptionsDialog> {
  bool _isLoading = false;

  Future<void> _pickOptionsAndNavigate(BuildContext context, ImageSource source) async {
    // Set loading state
    setState(() {
      _isLoading = true;
    });

    final imageProvider = Provider.of<ImageScanProvider>(context, listen: false);
    final bool isSuccess = await imageProvider.pickImage(source);

    // Reset loading state
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    // Check apakah widget masih dalam tree (aktif) & pick image sukses
    if (context.mounted) {
      if (isSuccess) {
        // Gambar berhasil dipilih dan disimpan di provider
        debugPrint('Gambar berhasil dipilih: ${imageProvider.imageFile?.path}');
        
        // Tutup dialog terlebih dahulu
        Navigator.of(context).pop();

        // Navigate ke preview screen untuk melihat, edit, dan analyze gambar
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ImagePreviewScreen(),
          ),
        );
      } else {
        // Gagal mengambil gambar, tampilkan error jika ada
        final state = imageProvider.state;
        if (state is ImageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // User membatalkan pemilihan gambar (tidak perlu tampilkan error)
          debugPrint('User membatalkan pemilihan gambar');
        }
      }
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
            onPressed: _isLoading ? null : () {
              //Logic Camera
              _pickOptionsAndNavigate(context, ImageSource.camera);
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
            onPressed: _isLoading ? null : () {
              //Logic open gallery
              _pickOptionsAndNavigate(context, ImageSource.gallery);
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
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _isLoading ? Colors.grey : AppTheme.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
