import 'package:flutter/material.dart';
import 'package:nabatdex/common/shared_widgets/main_app_bar.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class PredictionErrorScreen extends StatelessWidget {
  final String? errorMessage;

  const PredictionErrorScreen({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const MainAppBar(title: "Hasil Prediksi"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppTheme.errorColor,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                "Terjadi Kesalahan",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                errorMessage ?? 
                "Model tidak dapat memprediksi hasil. Pastikan foto merupakan daun dari tanaman dan memiliki pencahayaan yang bagus",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
