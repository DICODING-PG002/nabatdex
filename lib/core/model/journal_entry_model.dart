class JournalEntryModel {
  final int? id;
  final String plantName;
  final String? diseaseName;
  final double confidenceLevel;
  final String imagePath;
  final DateTime scanDate;
  final bool isHealthy;
  final int? plantId;
  final int? diseaseId;

  JournalEntryModel({
    this.id,
    required this.plantName,
    this.diseaseName,
    required this.confidenceLevel,
    required this.imagePath,
    required this.scanDate,
    required this.isHealthy,
    this.plantId,
    this.diseaseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plant_name': plantName,
      'disease_name': diseaseName,
      'confidence_level': confidenceLevel,
      'image_path': imagePath,
      'scan_date': scanDate.toIso8601String(),
      'is_healthy': isHealthy ? 1 : 0,
      'plant_id': plantId,
      'disease_id': diseaseId,
    };
  }

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] as int?,
      plantName: map['plant_name'] as String,
      diseaseName: map['disease_name'] as String?,
      confidenceLevel: map['confidence_level'] as double,
      imagePath: map['image_path'] as String,
      scanDate: DateTime.parse(map['scan_date'] as String),
      isHealthy: (map['is_healthy'] as int) == 1,
      plantId: map['plant_id'] as int?,
      diseaseId: map['disease_id'] as int?,
    );
  }

  String get confidencePercentage => '${(confidenceLevel * 100).toStringAsFixed(1)}%';
  
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final day = scanDate.day;
    final month = months[scanDate.month - 1];
    final year = scanDate.year.toString().substring(2);
    final hour = scanDate.hour.toString().padLeft(2, '0');
    final minute = scanDate.minute.toString().padLeft(2, '0');
    
    return "$day $month '$year, $hour:$minute WIB";
  }
}

