import 'package:nabatdex/core/model/disease_model.dart';
import 'package:nabatdex/core/model/plant_model.dart';

class PredictionResultModel {
  final String predictedPlantName;
  final double confidenceLevel;
  final String? diseaseName;
  final String imagePath;
  final PlantModel? plantData;
  final DiseaseModel? diseaseData;
  final String? plantImagePath;
  final String? diseaseImagePath;

  PredictionResultModel({
    required this.predictedPlantName,
    required this.confidenceLevel,
    this.diseaseName,
    required this.imagePath,
    this.plantData,
    this.diseaseData,
    this.plantImagePath,
    this.diseaseImagePath,
  });

  bool get isHealthy => diseaseName == null;

  String get confidencePercentage => '${(confidenceLevel * 100).toStringAsFixed(1)}%';
}

