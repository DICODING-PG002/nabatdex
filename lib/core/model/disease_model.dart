class DiseaseModel {
  final int id;
  final String name;
  final String type;
  final String description;
  final String cause;
  final String controlSolution;
  final String preventionGuide;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.cause,
    required this.controlSolution,
    required this.preventionGuide,
  });

  factory DiseaseModel.fromMap(Map<String, dynamic> map) {
    return DiseaseModel(
      id: map['pest_disease_id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
      cause: map['cause'] as String,
      controlSolution: map['control_solution'] as String,
      preventionGuide: map['prevention_guide'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pest_disease_id': id,
      'name': name,
      'type': type,
      'description': description,
      'cause': cause,
      'control_solution': controlSolution,
      'prevention_guide': preventionGuide,
    };
  }
}

