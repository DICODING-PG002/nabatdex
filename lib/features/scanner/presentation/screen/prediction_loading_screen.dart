import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class PredictionLoadingScreen extends StatelessWidget {
  const PredictionLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              "Proses prediksi sedang berlangsung",
              style: TextTheme.of(
                context,
              ).titleLarge?.copyWith(color: AppTheme.textColor),
            ),
            Text(
              "Harap jangan tutup aplikasi",
              style: TextTheme.of(context).bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
