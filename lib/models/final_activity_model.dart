class FinalActivityModel {
  final int day;
  final String activityName;
  final String ageGroup;
  final String activityType;
  final String improvementArea;
  final String materials;
  final String stepByStep;
  final String clue;
  final String emoji;
  final String warningText;
  final String apothegm;

  const FinalActivityModel(
      {required this.day,
      required this.activityName,
      required this.ageGroup,
      required this.activityType,
      required this.improvementArea,
      required this.materials,
      required this.stepByStep,
      required this.clue,
      required this.emoji,
      required this.warningText,
      required this.apothegm});

  factory FinalActivityModel.fromJson(Map<String, dynamic> json) {
    return FinalActivityModel(
        day: json['day'],
        activityName: json['activity_name'],
        ageGroup: json['age_group'],
        activityType: json['activity_type'],
        improvementArea: json['improvement_name'],
        materials: json['materials'],
        stepByStep: json['step_by_step'],
        clue: json['clue'],
        emoji: json['emoji'],
        warningText: json['warning_text'],
        apothegm: json['apothegm']);
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'activity_name': activityName,
        'age_group': ageGroup,
        'activity_type': activityType,
        'improvement_area': improvementArea,
        'materials': materials,
        'step_by_step': stepByStep,
        'clue': clue,
        'emoji': emoji,
        'warning_text': warningText,
        'apothegm': apothegm
      };
}
