import 'package:nabatdex/core/constant/activity_type.dart';

class PlantActivityModel {
  final int? id;
  final int journalEntryId;
  final ActivityType activityType;
  final String activityName;
  final String notes;
  final DateTime activityDateTime;

  PlantActivityModel({
    this.id,
    required this.journalEntryId,
    required this.activityType,
    required this.activityName,
    required this.notes,
    required this.activityDateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'journal_entry_id': journalEntryId,
      'activity_type': activityType.displayName,
      'activity_name': activityName,
      'notes': notes,
      'activity_date_time': activityDateTime.toIso8601String(),
    };
  }

  factory PlantActivityModel.fromMap(Map<String, dynamic> map) {
    return PlantActivityModel(
      id: map['id'] as int?,
      journalEntryId: map['journal_entry_id'] as int,
      activityType: ActivityType.fromString(map['activity_type'] as String),
      activityName: map['activity_name'] as String,
      notes: map['notes'] as String,
      activityDateTime: DateTime.parse(map['activity_date_time'] as String),
    );
  }

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final day = activityDateTime.day;
    final month = months[activityDateTime.month - 1];
    final year = activityDateTime.year;
    
    return "$day $month $year";
  }

  String get formattedTime {
    final hour = activityDateTime.hour.toString().padLeft(2, '0');
    final minute = activityDateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  String get formattedDateTime {
    return "$formattedDate, $formattedTime WIB";
  }

  PlantActivityModel copyWith({
    int? id,
    int? journalEntryId,
    ActivityType? activityType,
    String? activityName,
    String? notes,
    DateTime? activityDateTime,
  }) {
    return PlantActivityModel(
      id: id ?? this.id,
      journalEntryId: journalEntryId ?? this.journalEntryId,
      activityType: activityType ?? this.activityType,
      activityName: activityName ?? this.activityName,
      notes: notes ?? this.notes,
      activityDateTime: activityDateTime ?? this.activityDateTime,
    );
  }
}

