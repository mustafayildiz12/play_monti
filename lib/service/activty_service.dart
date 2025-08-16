import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/service/authentication_service.dart';

/// TercihService sınıfı, Firebase Realtime Database ile etkileşim için gerekli metodları içerir.
/// Kullanıcı tercihleri, sınav bilgileri ve diğer verilerin yönetimini sağlar.
class ActivityService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  DatabaseReference _refFor(String uid, DateTime dateTime, String activityId) {
    final key = dateKey(dateTime);
      String group = currentMontiUser!.ageActivity!;
    return _realtimeDatabase.ref('userActivities/$uid/$group/$key/$activityId');
  }

  /// Yapıldı olarak işaretle
  Future<void> markDone({
    required DateTime day,
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
    required DateTime day,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    await _refFor(uid, day, activityId).remove();
  }

  Future<bool> isMarked({
    required DateTime dateTime,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    final key = dateKey(dateTime);

    String group = currentMontiUser!.ageActivity!;

    final ref =
        _realtimeDatabase.ref('userActivities/$uid/$group/$key/$activityId');
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
}

final ActivityService activityService = ActivityService();
