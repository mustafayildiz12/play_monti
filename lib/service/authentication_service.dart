// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/monti_user_model.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// AuthenticationService, kullanıcı kimlik doğrulama işlemlerini yöneten servis sınıfıdır.
/// Firebase Authentication kullanarak kullanıcı girişi, kayıt, çıkış ve anonim giriş gibi
/// işlemleri gerçekleştirir.
class AuthenticationService {
  factory AuthenticationService() {
    return _singleton;
  }

  AuthenticationService._internal();
  // Singleton pattern uygulaması - yalnızca tek bir nesne üzerinden işlem yapılır
  static final AuthenticationService _singleton =
      AuthenticationService._internal();

  // Firebase Authentication nesnesi
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Kullanıcı girişi yapar
  ///
  /// [context] - BuildContext
  /// [email] - Kullanıcı e-posta adresi
  /// [password] - Kullanıcı şifresi
  ///
  /// Başarılı giriş durumunda kullanıcıyı tercihExamsPath sayfasına yönlendirir.
  /// Hata durumunda uygun hata mesajını gösterir.
  Future<void> login(BuildContext context,
      {required String email, required String password}) async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential userCredential) async {
        final bool isUserExist =
            await checkUserExist(userCredential: userCredential);

        final bool isUserDataExist = await databaseService
            .getAdminBasicInfoFromRealTime(userCredential.user!.uid);

        final bool isUserDetailExist =
            await databaseService.isUserDetailExist(userCredential.user!.uid);

        if (isUserExist && isUserDataExist) {
          if (currentMontiUser?.status != 1) {
            if (isUserDetailExist) {
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.navigationBarPage, (route) => false);
            } else {
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.onboFlowPage, (route) => false);
            }
          } else {
            customSnackBar.error("account_deleted".tr);
            await logoutFromFirebase(context);
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar.warning("Kullanıcı Bulunamadı");
      } else if (e.code == 'wrong-password') {
        customSnackBar.warning("Hatalı kullanıcı adı ya da şifre");
      } else {
        customSnackBar.warning("Hatalı kullanıcı adı ya da şifre");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Yeni kullanıcı kaydı oluşturur
  ///
  /// [email] - Kullanıcı e-posta adresi
  /// [password] - Kullanıcı şifresi
  /// [context] - BuildContext
  ///
  /// Başarılı kayıt durumunda kullanıcıyı tercihExamsPath sayfasına yönlendirir.
  /// Hata durumunda uygun hata mesajını gösterir.
  Future<void> registerAndSaveUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final bool isUserExist = await checkUserExist(userCredential: credential);
      if (isUserExist) {
        await Future.wait([
          databaseService.addUserToRealTime(
            MontiUserModel(
                completedActivities: 0,
                uid: credential.user!.uid,
                userEmail: email,
                userPassword: password,
                createDateTimeStamp: DateTime.now().millisecondsSinceEpoch),
          ),
        ]);

        await databaseService
            .getAdminBasicInfoFromRealTime(credential.user!.uid);

        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.onboFlowPage, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar.warning("Kullanıcı Bulunamadı");
      } else if (e.code == 'wrong-password') {
        customSnackBar.warning("Hatalı kullanıcı adı ya da şifre");
      }
    }
  }

  /// Kullanıcının var olup olmadığını kontrol eder
  ///
  /// [userCredential] - Firebase'den dönen kullanıcı bilgileri
  ///
  /// Kullanıcı varsa true, yoksa false döner
  Future<bool> checkUserExist({required UserCredential userCredential}) async {
    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    bool isSendResetEmailSuccess = false;
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
      isSendResetEmailSuccess = true;
      customSnackBar
          .success("Şifre sıfırlama isteği mail adresinize gönderildi.");
    } catch (e) {
      isSendResetEmailSuccess = false;
      customSnackBar.error(
          "Şifre sıfırlama isteği gönderildi. Lütfen daha sonra tekrar deneyiniz.");
    }
    return isSendResetEmailSuccess;
  }

  /// Mevcut kullanıcının ID'sini döndürür
  Future<String?> userId() async {
    return firebaseAuth.currentUser!.uid;
  }

  /// Mevcut kullanıcı nesnesini döndürür
  User? getUser() {
    return firebaseAuth.currentUser;
  }

  /// Kullanıcı çıkışı yapar
  ///
  /// [context] - BuildContext
  ///
  /// Google hesabından çıkış yapar, Firebase'den çıkış yapar,
  /// abonelikleri iptal eder ve kullanıcıyı tercihLoginPath sayfasına yönlendirir.
  Future<void> logoutFromFirebase(BuildContext context) async {
    try {
      await firebaseAuth.signOut();

      final User? currentUser = getUser();

      currentMontiUser = null;
      // kullanıcının çıktığından emin olduktan sonra
      // locali silme ve navgationu temizleme işlemi yapıyoruz.
      if (currentUser == null) {
        await localStorage.erase();

        await Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginPage, (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Google hesabı ile giriş yapar
  ///
  /// [context] - BuildContext
  ///
  /// Google hesabı ile giriş yapar, kullanıcı bilgilerini Firebase'e kaydeder
  /// ve tercihExamsPath sayfasına yönlendirir.
  /// Hata durumunda uygun hata mesajını gösterir.
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;

        /// isUserDataExist true ise bu kullanıcı db'ye kaydedilmiş demektir
        final bool isUserDataExist =
            await databaseService.getAdminBasicInfoFromRealTime(uid);

        final bool isUserDetailExist =
            await databaseService.isUserDetailExist(uid);

        if (!isUserDataExist) {
          final Map<String, dynamic>? profile =
              userCredential.additionalUserInfo?.profile;
          await databaseService
              .addUserToRealTime(
            MontiUserModel(
                uid: uid,
                completedActivities: 0,
                userEmail: profile!['email'],
                userName: profile['name'],
                createDateTimeStamp: DateTime.now().millisecondsSinceEpoch),
          )
              .then((v) async {
            await databaseService.getAdminBasicInfoFromRealTime(uid);
          });
        }

        if (isUserDetailExist) {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.navigationBarPage, (route) => false);
        } else {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.onboFlowPage, (route) => false);
        }
      } else {
        debugPrint("User bulunamadı.");
      }
    } catch (e) {
      customSnackBar.warning("Giriş Yapılamadı.");
      debugPrint("Hata: $e");
      if (e is PlatformException) {
        debugPrint("PlatformException: ${e.message}");
        debugPrint("Details: ${e.details}");
      }
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        nonce: nonce,
      );

      final AuthCredential appleAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
        accessToken: credential.authorizationCode,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);

      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;

        /// isUserDataExist true ise bu kullanıcı db'ye kaydedilmiş demektir
        final bool isUserDataExist =
            await databaseService.getAdminBasicInfoFromRealTime(uid);

        final bool isUserDetailExist =
            await databaseService.isUserDetailExist(uid);

        if (!isUserDataExist) {
          final Map<String, dynamic>? profile =
              userCredential.additionalUserInfo?.profile;

          await databaseService
              .addUserToRealTime(
            MontiUserModel(
                uid: uid,
                completedActivities: 0,
                userEmail: profile!['email'] ?? "",
                createDateTimeStamp: DateTime.now().millisecondsSinceEpoch),
          )
              .then((v) async {
            await databaseService.getAdminBasicInfoFromRealTime(uid);
          });
        }

        if (isUserDetailExist) {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.navigationBarPage, (route) => false);
        } else {
          await Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.onboFlowPage, (route) => false);
        }
      } else {
        debugPrint("User bulunamadı.");
      }
    } catch (e) {
      customSnackBar.warning("Giriş Yapılamadı.");
      debugPrint("Hata: $e");

      if (e is PlatformException) {
        debugPrint("PlatformException: ${e.message}");
        debugPrint("Details: ${e.details}");
      }
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// Singleton instance
final AuthenticationService authenticationService = AuthenticationService();
