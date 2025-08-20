class FavoriteActivityModel {
  final int day;
  final String date;
  final String activityName;
  final String ageGroup;
  final String activityType;
  final String improvementArea;
  final String emoji;
  final bool isFavorite;

  const FavoriteActivityModel(
      {required this.day,
      required this.activityName,
      required this.ageGroup,
      required this.activityType,
      required this.improvementArea,
      required this.emoji,
      required this.isFavorite,
      required this.date});

  factory FavoriteActivityModel.fromJson(Map<String, dynamic> json) {
    return FavoriteActivityModel(
        day: json['day'],
        activityName: json['activity_name'],
        ageGroup: json['age_group'],
        activityType: json['activity_type'],
        improvementArea: json['improvement_area'],
        emoji: json['emoji'],
        isFavorite: json['isFavorite'],
        date: json['date']);
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'activity_name': activityName,
        'age_group': ageGroup,
        'activity_type': activityType,
        'improvement_area': improvementArea,
        'emoji': emoji,
        'isFavorite': isFavorite,
        'date': date
      };
}
