import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_body.dart';
import 'package:nabatdex/features/scanner/presentation/widgets/dialog_content.dart';

class ScanOptionsDialog extends StatelessWidget {
  const ScanOptionsDialog({super.key});

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
            onPressed: () {
              //Logic scan by camera
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Ambil dari Kamera'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF63A088),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              //Logic open gallery
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Pilih dari Galeri'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF63A088),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Cancel button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
