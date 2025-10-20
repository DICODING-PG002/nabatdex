import 'package:flutter/material.dart';
import 'package:nabatdex/core/database/plant_database_helper.dart';
import 'package:nabatdex/core/model/prediction_result_model.dart';
import 'package:nabatdex/core/services/ml_service.dart';

class PredictionProvider with ChangeNotifier {
  final MLService _mlService = MLService();
  final PlantDatabaseHelper _dbHelper = PlantDatabaseHelper.instance;

  PredictionState _state = PredictionInitial();
  PredictionState get state => _state;

  PredictionResultModel? _result;
  PredictionResultModel? get result => _result;

  Future<void> predictPlantDisease(String imagePath) async {
    try {
      _state = PredictionLoading();
      notifyListeners();

      final mlResult = await _mlService.predictImage(imagePath);

      final plantName = mlResult['plantName'] as String;
      final confidence = mlResult['confidence'] as double;
      final diseaseName = mlResult['diseaseName'] as String?;

      final plantData = await _dbHelper.getPlantByName(plantName);
      
      final diseaseData = diseaseName != null 
          ? await _dbHelper.getDiseaseByName(diseaseName)
          : null;

      String? plantImagePath;
      if (plantData != null) {
        plantImagePath = await _dbHelper.getPlantImagePath(plantData.id);
      }

      String? diseaseImagePath;
      if (diseaseData != null) {
        diseaseImagePath = await _dbHelper.getDiseaseImagePath(diseaseData.id);
      }

      _result = PredictionResultModel(
        predictedPlantName: plantName,
        confidenceLevel: confidence,
        diseaseName: diseaseName,
        imagePath: imagePath,
        plantData: plantData,
        diseaseData: diseaseData,
        plantImagePath: plantImagePath,
        diseaseImagePath: diseaseImagePath,
      );

      _state = PredictionSuccess(_result!);
      notifyListeners();
    } catch (e) {
      _state = PredictionError(e.toString());
      notifyListeners();
    }
  }

  void resetPrediction() {
    _state = PredictionInitial();
    _result = null;
    notifyListeners();
  }
}

sealed class PredictionState {}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final PredictionResultModel result;
  PredictionSuccess(this.result);
}

class PredictionError extends PredictionState {
  final String message;
  PredictionError(this.message);
}

