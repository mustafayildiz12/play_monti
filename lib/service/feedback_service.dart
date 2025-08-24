import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/models/feedback_model.dart';

class FeedbackService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  /// Yapıldı olarak işaretle
  Future<void> addActivityFeedback({
    required ActivityFeedbackModel feedbackmodel,
  }) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    await _realtimeDatabase.ref('activityFeebacks').child(now.toString()).set(
          feedbackmodel.toJson(),
        );
  }

  Future<void> addAppFeedback(
      {required int isLiked, required String feedbackText}) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    await _realtimeDatabase.ref('appFeebacks').child(now.toString()).set({
      "isLiked": isLiked,
      "feedbackText": feedbackText,
      "createDate": DateTime.now().toIso8601String()
    });
  }
}

final FeedbackService feedbackService = FeedbackService();
