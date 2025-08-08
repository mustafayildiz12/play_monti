import 'dart:convert';

class ActivityListModel {
  final int day;
  final String activityName;
  final String ageGroup;
  final String activityType;
  final String improvementName;
  final String materials;
  final String stepByStep;
  final String clue;

  const ActivityListModel({
    required this.day,
    required this.activityName,
    required this.ageGroup,
    required this.activityType,
    required this.improvementName,
    required this.materials,
    required this.stepByStep,
    required this.clue,
  });

  /// Robust int parse: int/double/string hepsini dener.
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final s = value.trim();
      final m = RegExp(r'-?\d+').firstMatch(s);
      if (m != null) return int.parse(m.group(0)!);
    }
    throw FormatException('day alanı sayıya çevrilemedi: $value');
  }

  /// Null/olmayan alanlar için güvenli string
  static String _s(dynamic v) => (v ?? '').toString().trim();

  factory ActivityListModel.fromJson(Map<String, dynamic> json) {
    return ActivityListModel(
      day: _parseInt(json['day']),
      activityName: _s(json['activity_name']),
      ageGroup: _s(json['age_group']),
      activityType: _s(json['activity_type']),
      improvementName: _s(json['improvement_name']),
      materials: _s(json['materials']),
      stepByStep: _s(json['step_by_step']),
      clue: _s(json['clue']),
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'activity_name': activityName,
        'age_group': ageGroup,
        'activity_type': activityType,
        'improvement_name': improvementName,
        'materials': materials,
        'step_by_step': stepByStep,
        'clue': clue,
      };

  ActivityListModel copyWith({
    int? day,
    String? activityName,
    String? ageGroup,
    String? activityType,
    String? improvementName,
    String? materials,
    String? stepByStep,
    String? clue,
  }) {
    return ActivityListModel(
      day: day ?? this.day,
      activityName: activityName ?? this.activityName,
      ageGroup: ageGroup ?? this.ageGroup,
      activityType: activityType ?? this.activityType,
      improvementName: improvementName ?? this.improvementName,
      materials: materials ?? this.materials,
      stepByStep: stepByStep ?? this.stepByStep,
      clue: clue ?? this.clue,
    );
  }

  @override
  String toString() => 'Activity(day: $day, activityName: $activityName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityListModel &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          activityName == other.activityName &&
          ageGroup == other.ageGroup &&
          activityType == other.activityType &&
          improvementName == other.improvementName &&
          materials == other.materials &&
          stepByStep == other.stepByStep &&
          clue == other.clue;

  @override
  int get hashCode =>
      day.hashCode ^
      activityName.hashCode ^
      ageGroup.hashCode ^
      activityType.hashCode ^
      improvementName.hashCode ^
      materials.hashCode ^
      stepByStep.hashCode ^
      clue.hashCode;

  // --- Liste yardımcıları ---

  /// JSON string -> List<Activity>
  static List<ActivityListModel> listFromJsonString(String jsonStr) {
    final raw = json.decode(jsonStr);
    if (raw is List) {
      return raw
          .map((e) => ActivityListModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Beklenen liste değil');
  }

  /// dynamic (List veya String) -> List<Activity>
  static List<ActivityListModel> listFromDynamic(dynamic data) {
    if (data is String) return listFromJsonString(data);
    if (data is List) {
      return data
          .map((e) => ActivityListModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Liste verisi bekleniyordu');
  }

  /// List<Activity> -> JSON string
  static String listToJsonString(List<ActivityListModel> list) {
    return json.encode(list.map((e) => e.toJson()).toList());
  }
}
