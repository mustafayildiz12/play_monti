class ActivityFeedbackModel {
  final String userName;
  final String userId;
  final String feedbackText;
  final int isLiked; // 0 ise dislike 1 ise like
  final int activityId;
  final String activityGroup;
  final String language;
  final String createDate;
  final String userEmail;

  ActivityFeedbackModel(
      {required this.feedbackText,
      required this.isLiked,
      required this.activityId,
      required this.activityGroup,
      required this.language,
      required this.createDate,
      required this.userId,
      required this.userName,
      required this.userEmail});

  factory ActivityFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ActivityFeedbackModel(
        userName: json['userName'],
        feedbackText: json['feedbackText'],
        isLiked: json['isLiked'],
        activityId: json['activityId'],
        activityGroup: json['activityGroup'],
        language: json['language'],
        createDate: json['createDate'],
        userId: json['userId'],
        userEmail: json['userEmail']);
  }

  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'userName': userName,
        'userId': userId,
        'feedbackText': feedbackText,
        'isLiked': isLiked,
        'activityId': activityId,
        'activityGroup': activityGroup,
        'language': language,
        'createDate': createDate
      };
}
