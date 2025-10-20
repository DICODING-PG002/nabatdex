class PlantModel {
  final int id;
  final String commonName;
  final String scientificName;
  final String description;
  final String plantType;
  final String lifeCycle;
  final String optimalTemperature;
  final String irqTips;
  final String cultivationGuide;

  PlantModel({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.plantType,
    required this.lifeCycle,
    required this.optimalTemperature,
    required this.irqTips,
    required this.cultivationGuide,
  });

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['plant_master_id'] as int,
      commonName: map['common_name'] as String,
      scientificName: map['scientific_name'] as String,
      description: map['description'] as String,
      plantType: map['plant_type'] as String,
      lifeCycle: map['life_cycle'] as String,
      optimalTemperature: map['optimal_temperature'] as String,
      irqTips: map['irq_tips'] as String,
      cultivationGuide: map['cultivation_guide'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plant_master_id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'description': description,
      'plant_type': plantType,
      'life_cycle': lifeCycle,
      'optimal_temperature': optimalTemperature,
      'irq_tips': irqTips,
      'cultivation_guide': cultivationGuide,
    };
  }
}

