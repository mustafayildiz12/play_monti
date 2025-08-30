import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/models/feedback_model.dart';
import 'package:play_monti/service/authentication_service.dart';

class FeedbackService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  /// Yapıldı olarak işaretle
  Future<void> addActivityFeedback({
    required ActivityFeedbackModel feedbackmodel,
  }) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    await _realtimeDatabase.ref('activityFeedbacks').child(now.toString()).set(
          feedbackmodel.toJson(),
        );
  }

  Future<void> addAppFeedback(
      {required int isLiked, required String feedbackText}) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    await _realtimeDatabase.ref('appFeedbacks').child(now.toString()).set({
      "isLiked": isLiked,
      "feedbackText": feedbackText,
      "createDate": DateTime.now().toIso8601String(),
      "userId": authenticationService.userId(),
      "userEmail": currentMontiUser?.userEmail ?? "",
      "userName": currentMontiUser?.userName ?? ""
    });
  }
}

final FeedbackService feedbackService = FeedbackService();
