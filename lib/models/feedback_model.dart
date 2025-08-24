class ActivityFeedbackModel {
  final String feedbackText;
  final int isLiked; // 0 ise dislike 1 ise like
  final int activityId;
  final String activityGroup;
  final String language;
  final String createDate;

  ActivityFeedbackModel({
    required this.feedbackText,
    required this.isLiked,
    required this.activityId,
    required this.activityGroup,
    required this.language,
    required this.createDate,
  });

  factory ActivityFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ActivityFeedbackModel(
        feedbackText: json['feedbackText'],
        isLiked: json['isLiked'],
        activityId: json['activityId'],
        activityGroup: json['activityGroup'],
        language: json['language'],
        createDate: json['createDate']);
  }

  Map<String, dynamic> toJson() => {
        'feedbackText': feedbackText,
        'isLiked': isLiked,
        'activityId': activityId,
        'activityGroup': activityGroup,
        'language': language,
        'createDate': createDate
      };
}
