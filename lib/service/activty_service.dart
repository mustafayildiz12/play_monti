import 'package:firebase_database/firebase_database.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_localization.dart';
import 'package:play_monti/models/favorite_activity_model.dart';
import 'package:play_monti/models/final_activity_model.dart';
import 'package:play_monti/service/authentication_service.dart';

/// TercihService sınıfı, Firebase Realtime Database ile etkileşim için gerekli metodları içerir.
/// Kullanıcı tercihleri, sınav bilgileri ve diğer verilerin yönetimini sağlar.
class ActivityService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  DatabaseReference _activityRefFor(
      String uid, String dateTime, String activityId) {
    String group = currentMontiUser!.ageActivity!;
    return _realtimeDatabase
        .ref('userActivities/$uid/$group/$dateTime/$activityId');
  }

  DatabaseReference _favoriteRefFor(String uid, String activityId) {
    String group = currentMontiUser!.ageActivity!;
    return _realtimeDatabase.ref('userFavorites/$uid/$group/$activityId');
  }

  /// Yapıldı olarak işaretle
  Future<void> markDone({
    required String day,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    await _activityRefFor(uid, day, activityId).set({
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
    await _activityRefFor(uid, day, activityId).remove();
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

    String language = AppLocalization.getLanguageCodeParam;

    final DatabaseReference ref = _realtimeDatabase.ref(group + language);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);

        FinalActivityModel model = FinalActivityModel.fromJson(activityData);

        if (model.day.toString() == dayIndex) {
          return model.activityName;
        }
      }
    }

    return null;
  }

  Future<FinalActivityModel?> getActivityDetail({
    required String dayIndex,
  }) async {
    final String group = currentMontiUser!.ageActivity!;

    String language = AppLocalization.getLanguageCodeParam;

    final DatabaseReference ref = _realtimeDatabase.ref(group + language);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);

        FinalActivityModel model = FinalActivityModel.fromJson(activityData);

        if (model.day.toString() == dayIndex) {
          return model;
        }
      }
    }

    return null;
  }

  Future<void> addWeeklyActivity(
      {required String ageGroup,
      required String language,
      required FinalActivityModel activityModel}) async {
    String milliSecondTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _realtimeDatabase
        .ref("$ageGroup/$language")
        .child(milliSecondTime)
        .set(activityModel.toJson());
  }

  /// Favorileri Düzenleme

  /// Yapıldı olarak işaretle
  Future<void> markFavorite({
    required String day,
    required FinalActivityModel activityModel,
  }) async {
    final uid = authenticationService.getUser()!.uid;

    FavoriteActivityModel favoriteActivityModel = FavoriteActivityModel(
        day: activityModel.day,
        activityName: activityModel.activityName,
        ageGroup: activityModel.ageGroup,
        activityType: activityModel.activityType,
        improvementArea: activityModel.improvementArea,
        emoji: activityModel.emoji,
        isFavorite: true,
        date: day);
    await _favoriteRefFor(
      uid,
      activityModel.day.toString(),
    ).set(favoriteActivityModel.toJson());
  }

  /// Geri al (yapılmadı)
  Future<void> markUnFavorite({
    required String day,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;
    await _favoriteRefFor(uid, activityId).remove();
  }

  Future<bool> isFavorite({
    required String dateTime,
    required String activityId,
  }) async {
    final uid = authenticationService.getUser()!.uid;

    String group = currentMontiUser!.ageActivity!;

    final ref = _realtimeDatabase.ref('userFavorites/$uid/$group/$activityId');
    final snap = await ref.get();

    if (!snap.exists || snap.value == null) {
      return false; // hiç kayıt yok, yapılmamış
    }

    try {
      final data = Map<String, dynamic>.from(snap.value as Map);
      return data['isFavorite'] == true;
    } catch (_) {
      return false; // beklenmedik format -> yapılmamış say
    }
  }

  Future<List<FavoriteActivityModel>> getFavoriteActivities() async {
    final List<FavoriteActivityModel> favorites = [];

    String uid = authenticationService.getUser()!.uid;

    String group = currentMontiUser!.ageActivity!;

    final DatabaseReference ref =
        _realtimeDatabase.ref('userFavorites/$uid/$group');

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      final raw = snapshot.value;

      if (raw is Map) {
        // Sadece value’lar (yani activity map’leri) ile ilgileniyoruz
        for (final value in raw.values) {
          if (value is Map) {
            final map = Map<String, dynamic>.from(value);
            final model = FavoriteActivityModel.fromJson(map);
            if (model.isFavorite == true) {
              favorites.add(model);
            }
          }
        }
      } // 2) Kaynak veri LIST ise (örn: [null, {...}, null, {...}])
      else if (raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            final model = FavoriteActivityModel.fromJson(map);
            if (model.isFavorite == true) {
              favorites.add(model);
            }
          }
        }
      }
    }

    // 4) Tüm listeyi "day" alanına göre sortla (gün sıralaması doğru mu emin olmak için)
    favorites.sort((a, b) => (a.day ?? 0).compareTo(b.day ?? 0));

    return favorites;
  }

  Future<List<FinalActivityModel>> getAllActivities(
      {required String age, required String language}) async {
    final List<FinalActivityModel> getAllActivities = [];

    final DatabaseReference ref = _realtimeDatabase.ref(age).child(language);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      final raw = snapshot.value;

      if (raw is Map) {
        for (final value in raw.values) {
          if (value is Map) {
            final map = Map<String, dynamic>.from(value);
            final model = FinalActivityModel.fromJson(map);

            getAllActivities.add(model);
          }
        }
      } // 2) Kaynak veri LIST ise (örn: [null, {...}, null, {...}])
      else if (raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            final model = FinalActivityModel.fromJson(map);

            getAllActivities.add(model);
          }
        }
      }
    }

    return getAllActivities;
  }
}

final ActivityService activityService = ActivityService();
