// ignore_for_file: use_build_context_synchronously

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

  Future<List<ActivityListModel>> getActivities({required String path}) async {
    final List<ActivityListModel> activities = [];

    final DatabaseReference ref = _realtimeDatabase.ref(path);

    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      for (final entry in data.entries) {
        final Map<String, dynamic> activityData =
            Map<String, dynamic>.from(entry.value);
        activities.add(ActivityListModel.fromJson(activityData));
      }
    }

    return activities;
  }
}

final DatabaseService databaseService = DatabaseService();
