import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_theme.dart';

class PredictionErrorScreen extends StatelessWidget {
  const PredictionErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          "Hasil Prediksi",
          style: TextTheme.of(
            context,
          ).titleMedium?.copyWith(color: AppTheme.textColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Terjadi Kesalahan",
                style: TextTheme.of(
                  context,
                ).titleLarge?.copyWith(color: AppTheme.errorColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Model tidak dapat memprediksi hasil. Pastikan foto merupakan daun dari tanaman dan memiliki pencahayaan yang bagus",
                style: TextTheme.of(context).bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
