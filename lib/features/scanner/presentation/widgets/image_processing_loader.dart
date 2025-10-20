import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

/// Widget loading yang reusable untuk proses image processing
/// Menampilkan circular progress indicator dengan pesan
class ImageProcessingLoader extends StatelessWidget {
  const ImageProcessingLoader({
    super.key,
    this.message = 'Memproses gambar...',
    this.size = 48.0,
  });

  final String message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 4.0,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Message
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Sub message
          Text(
            'Harap tunggu sebentar...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.bodyTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

