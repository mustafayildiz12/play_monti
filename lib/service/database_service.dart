// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/models/activity_list_model.dart';
import 'package:play_monti/models/monti_user_model.dart';
import 'package:play_monti/service/authentication_service.dart';

/// TercihService sınıfı, Firebase Realtime Database ile etkileşim için gerekli metodları içerir.
/// Kullanıcı tercihleri, sınav bilgileri ve diğer verilerin yönetimini sağlar.
class DatabaseService {
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  /// Kullanıcının temel bilgilerini Firebase'den alır ve mevcut kullanıcı nesnesine atar.
  /// @param userId - Kullanıcının benzersiz kimliği
  /// @return bool - Kullanıcı bilgilerinin başarıyla alınıp alınmadığını belirten boolean değer
  Future<bool> getAdminBasicInfoFromRealTime(String userId) async {
    bool isExist = false;

    final MontiUserModel? userModel =
        await getDataFromRealtimeDatabase<MontiUserModel?>(
            "users/$userId", (d) => MontiUserModel.fromMap(d));

    if (userModel != null) {
      isExist = true;
      currentTercihUser = userModel;
      /*
      if (userModel.isAnonymous == false) {
        await InAppPurchaseService().loginSubscription();
      }
       */
    }

    return isExist;
  }

  Future<bool> isUserDetailExist(String userId) async {
    bool isExist = false;

    final MontiUserModel? userModel =
        await getDataFromRealtimeDatabase<MontiUserModel?>(
            "users/$userId", (d) => MontiUserModel.fromMap(d));

    if (userModel != null &&
        userModel.ageActivity != null &&
        userModel.userName != null) {
      isExist = true;

      /*
      if (userModel.isAnonymous == false) {
        await InAppPurchaseService().loginSubscription();
      }
       */
    }

    return isExist;
  }

  /// Firebase'den belirli bir yoldaki veriyi alır ve istenen tipe dönüştürür.
  /// @param path - Verinin alınacağı yol
  /// @param fromMap - Veriyi dönüştürecek fonksiyon
  /// @return Future<`T`?> - Dönüştürülmüş veri
  Future<T?> getDataFromRealtimeDatabase<T>(
      String path, T Function(Map<String, dynamic>) fromMap) async {
    try {
      final DataSnapshot snapshot = await _realtimeDatabase.ref(path).get();

      if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
        //  print(snapshot.value);
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        return fromMap(data);
      }
    } catch (e) {
      debugPrint("Firebase veri çekme hatası: $e");
    }
    return null;
  }

  /// Yeni bir kullanıcıyı Firebase'e ekler.
  /// @param user - Eklenecek kullanıcı modeli
  Future<void> addUserToRealTime(MontiUserModel user) async {
    await _realtimeDatabase.ref('users').child(user.uid!).set(user.toMap());
  }

  Future<void> updateUserTimeData(
      {required String ageActivity,
      required String userName,
      required String language}) async {
    User? user = authenticationService.getUser();
    await _realtimeDatabase.ref('users').child(user!.uid).update({
      "userName": userName,
      "ageActivity": ageActivity,
      "language": language
    });
  }

  /// Kullanıcı hesabını siler.
  /// @param context - BuildContext nesnesi
  Future<void> deleteAccount(BuildContext context) async {
    await _realtimeDatabase
        .ref("users")
        .child(currentTercihUser!.uid!)
        .update({"status": 1});
    await authenticationService.logoutFromFirebase(context);
  }

  Future<void> add1824({required Map<String, dynamic> item}) async {
    String milliSecondTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _realtimeDatabase.ref("18-24").child(milliSecondTime).set(item);
  }

  Future<void> add2436({required Map<String, dynamic> item}) async {
    String milliSecondTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _realtimeDatabase.ref("24-36").child(milliSecondTime).set(item);
  }

  Future<void> add3648({required Map<String, dynamic> item}) async {
    String milliSecondTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _realtimeDatabase.ref("36-48").child(milliSecondTime).set(item);
  }

  Future<void> add4860({required Map<String, dynamic> item}) async {
    String milliSecondTime = DateTime.now().millisecondsSinceEpoch.toString();
    await _realtimeDatabase.ref("48-60").child(milliSecondTime).set(item);
  }

  /// 1) Başlangıç tarihini yaz (kullanıcı kayıt akışında çağır)
  Future<void> setStartDate({required String startDate}) async {
    final uid = authenticationService.getUser()!.uid;
    // Basit validasyon (parse edilemezse hata fırlat)

    await _realtimeDatabase
        .ref('users')
        .child(uid)
        .update({'startDate': startDate});
  }

  /// 2-3) Bugün kaçıncı gündeyiz? (1-based)
  /// - günFarkı 0 ise 1. gün
  /// - günFarkı 5 ise 6. gün
  Future<int> getCurrentDayIndex() async {
    final uid = authenticationService.getUser()!.uid;
    final snap = await _realtimeDatabase
        .ref("users")
        .child(uid)
        .child('startDate')
        .get();
    if (!snap.exists || snap.value == null) {
      // Başlangıç tarihi hiç setlenmediyse "bugün"ü başlangıç kabul edelim
      final todayStr = DateTime.now().toIso8601String();
      await _realtimeDatabase
          .ref("users")
          .child(uid)
          .update({'startDate': todayStr});
      return 1;
    }

    final startStr = snap.value.toString();
    DateTime start;
    try {
      start = DateTime.parse(startStr);
    } catch (_) {
      // Bozuk veri gelirse otomatik düzelt: bugünü başlangıç yap
      final todayStr = DateTime.now().toIso8601String();
      await _realtimeDatabase
          .ref("users")
          .child(uid)
          .update({'startDate': todayStr});
      return 1;
    }

    final now = DateTime.now();
    // Sadece tarih bazlı fark (saat önemsiz), o yüzden midnight’a indir
    final startDate = DateTime(start.year, start.month, start.day);
    final todayDate = DateTime(now.year, now.month, now.day);

    final diff = todayDate.difference(startDate).inDays;

    // Gelecek tarihe setlenmişse (negatif fark), 1. güne sabitle
    final dayIndex = (diff < 0) ? 1 : diff + 1;
    return dayIndex;
  }

  /// 4) Gün indexine göre "day" numaralarını üret:
  /// 1.gün -> [1,2]
  /// 5.gün -> [9,10]
  /// 20.gün -> [39,40]
  List<int> _dayNumbersForIndex(int dayIndex) {
    final startDay = (dayIndex - 1) * 2 + 1;
    return [startDay, startDay + 1];
  }

  /// 5) Bugün gösterilecek iki aktivite
  Future<List<ActivityListModel>> getTodayActivities({
    required String activitiesPath,
  }) async {
    final dayIndex = await getCurrentDayIndex();
    final days = _dayNumbersForIndex(dayIndex);
    // Aktiviteleri çek ve sadece gerekli 2 "day"i filtrele
    final list = await getActivities(path: activitiesPath, onlyDays: days);
    return list;
  }

  Future<List<ActivityListModel>> getActivities({
    required String path,
    List<int>? onlyDays, // sadece bu day’leri döndürmek için
  }) async {
    final List<ActivityListModel> activities = [];

    final DatabaseReference ref = _realtimeDatabase.ref(path);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);

        ActivityListModel model = ActivityListModel.fromJson(activityData);

        if (onlyDays == null || (onlyDays.contains(model.day))) {
          activities.add(model);
        }
      }
    }

    // 4) Tüm listeyi "day" alanına göre sortla (gün sıralaması doğru mu emin olmak için)
    activities.sort((a, b) => (a.day ?? 0).compareTo(b.day ?? 0));

    return activities;
  }
}

final DatabaseService databaseService = DatabaseService();
