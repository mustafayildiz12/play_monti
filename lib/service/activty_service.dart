import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/service/authentication_service.dart';

/// TercihService sınıfı, Firebase Realtime Database ile etkileşim için gerekli metodları içerir.
/// Kullanıcı tercihleri, sınav bilgileri ve diğer verilerin yönetimini sağlar.
class ActivityService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  DatabaseReference _refFor(String uid, String dateTime, String activityId) {
    String group = currentMontiUser!.ageActivity!;
    return _realtimeDatabase
        .ref('userActivities/$uid/$group/$dateTime/$activityId');
  }

  /// Yapıldı olarak işaretle
  Future<void> markDone({
    required String day,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    await _refFor(uid, day, activityId).set({
      'isDone': true,
      'doneAt': ServerValue.timestamp,
    });
  }

  /// Geri al (yapılmadı)
  Future<void> markUndone({
    required String day,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    await _refFor(uid, day, activityId).remove();
  }

  Future<bool> isMarked({
    required String dateTime,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;

    String group = currentMontiUser!.ageActivity!;

    final ref = _realtimeDatabase
        .ref('userActivities/$uid/$group/$dateTime/$activityId');
    final snap = await ref.get();

    if (!snap.exists || snap.value == null) {
      return false; // hiç kayıt yok, yapılmamış
    }

    try {
      final data = Map<String, dynamic>.from(snap.value as Map);
      return data['isDone'] == true;
    } catch (_) {
      return false; // beklenmedik format -> yapılmamış say
    }
  }

  /// Tarihi "YYYY-MM-DD" formatına çevirir.
  /// Yani saat/dakika/saniye olmadan sadece günü kullanır.
  String dateKey(DateTime d) {
    final day = DateTime(d.year, d.month, d.day); // sadece tarih, saat yok
    return "${day.year.toString().padLeft(4, '0')}-"
        "${day.month.toString().padLeft(2, '0')}-"
        "${day.day.toString().padLeft(2, '0')}";
  }

  Future<String?> getIndexActivityName({
    required String dayIndex,
  }) async {
    final String group = currentMontiUser!.ageActivity!;

    final DatabaseReference ref = _realtimeDatabase.ref(group);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);

        ActivityListModel model = ActivityListModel.fromJson(activityData);

        if (model.day.toString() == dayIndex) {
          return model.activityName;
        }
      }
    }

    return null;
  }

  Future<ActivityListModel?> getActivityDetail({
    required String dayIndex,
  }) async {
    final String group = currentMontiUser!.ageActivity!;

    final DatabaseReference ref = _realtimeDatabase.ref(group);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);

        ActivityListModel model = ActivityListModel.fromJson(activityData);

        if (model.day.toString() == dayIndex) {
          return model;
        }
      }
    }

    return null;
  }
}

final ActivityService activityService = ActivityService();
