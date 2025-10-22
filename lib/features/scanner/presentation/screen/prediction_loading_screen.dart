import 'package:flutter/material.dart';
import 'package:nabatdex/core/constant/app_routes.dart';
import 'package:nabatdex/core/constant/app_theme.dart';
import 'package:nabatdex/features/scanner/presentation/providers/prediction_provider.dart';

class PredictionLoadingScreen extends StatefulWidget {
  final String imagePath;
  final PredictionProvider predictionProvider;

  const PredictionLoadingScreen({
    super.key,
    required this.imagePath,
    required this.predictionProvider,
  });

  @override
  State<PredictionLoadingScreen> createState() => _PredictionLoadingScreenState();
}

class _PredictionLoadingScreenState extends State<PredictionLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPrediction();
    });
  }

  void _startPrediction() {
    widget.predictionProvider.addListener(_onPredictionStateChanged);
    widget.predictionProvider.predictPlantDisease(widget.imagePath);
  }

  void _onPredictionStateChanged() {
    if (!mounted) return;

    final state = widget.predictionProvider.state;

    if (state is PredictionSuccess) {
      widget.predictionProvider.removeListener(_onPredictionStateChanged);
      
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.predictionResult,
        arguments: state.result,
      );
    } else if (state is PredictionError) {
      widget.predictionProvider.removeListener(_onPredictionStateChanged);
      
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.predictionError,
        arguments: state.message,
      );
    }
  }

  @override
  void dispose() {
    widget.predictionProvider.removeListener(_onPredictionStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 4,
            ),
            const SizedBox(height: 24),
            Text(
              'Proses prediksi sedang berlangsung',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Harap jangan tutup aplikasi',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.bodyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
