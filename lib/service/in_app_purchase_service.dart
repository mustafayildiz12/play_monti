// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Abonelik ürünlerinin listesi
List<StoreProduct>? _subsProducts;

/// Müşteri bilgileri
CustomerInfo? _customerInfo;

/// Abonelik ürünlerinin listesini döndürür
List<StoreProduct>? get getSubsProducts => _subsProducts;

/// Müşteri bilgilerini döndürür
CustomerInfo? get customerInfo => _customerInfo;

/// Müşteri bilgilerini ayarlar
set customerInfo(CustomerInfo? customerInfo) => _customerInfo = customerInfo;

/// InAppPurchaseService, uygulama içi satın alma işlemlerini yöneten servis sınıfıdır.
/// RevenueCat kütüphanesi kullanılarak abonelik ve tek seferlik satın alma işlemleri gerçekleştirilir.
class InAppPurchaseService {
  factory InAppPurchaseService() {
    return _singleton;
  }

  InAppPurchaseService._internal();
  // Singleton pattern uygulaması - yalnızca tek bir nesne üzerinden işlem yapılır
  static final InAppPurchaseService _singleton =
      InAppPurchaseService._internal();

  /// RevenueCat platformunu başlatır ve yapılandırır
  ///
  /// Platform türüne göre (Android, iOS) uygun API anahtarını kullanarak
  /// RevenueCat'i yapılandırır ve müşteri bilgilerini dinlemeye başlar.
  Future<void> initPlatformState() async {
    try {
      PurchasesConfiguration configuration;

      if (Platform.isAndroid) {
        configuration =
            PurchasesConfiguration("goog_KhJZbIYacfxpdXQccIQmyKXRgXl");
      } else if (Platform.isIOS) {
        configuration =
            PurchasesConfiguration("appl_lQFGTBNRCQWNZZgOpSqTYPUQHsu");
        print(configuration.store?.name);
      } else {
        configuration = PurchasesConfiguration("");
        debugPrint("Not supported platform");
      }
      await Purchases.configure(configuration);

      await Purchases.setLogLevel(LogLevel.debug);

      Purchases.addCustomerInfoUpdateListener((info) {
        customerInfo = info;
      });
    } catch (e) {
      customSnackBar.error("İnitiliaze Error. ${e.toString()}");
    }
  }

  /// Önceki satın alımları geri yükler
  ///
  /// Kullanıcının önceki satın alımlarını RevenueCat üzerinden geri yükler.
  /// Hata durumunda uygun hata mesajını gösterir.
  Future<void> restorePurchases() async {
    try {
      final CustomerInfo customerInfo = await Purchases.restorePurchases();

      final entitlements = customerInfo.entitlements.active;

      if (entitlements.containsKey('premium')) {
        // Kullanıcının Premium hakkı zaten vardı, sadece geri yükledik
        customSnackBar.success("Aboneliğiniz geri yüklendi.");
      } else {
        // Kullanıcının geçerli bir aboneliği yok
        customSnackBar.warning("Aktif abonelik bulunamadı.");
      }
    } on PlatformException catch (_) {
      customSnackBar.error("Restore işlemi başarısız oldu.");
    }
  }

  /// Abonelik ürünlerini yükler
  ///
  /// RevenueCat üzerinden abonelik ürünlerini yükler ve _subsProducts değişkenine atar.
  /// Hata durumunda konsola hata mesajı yazdırır.
  Future<void> loadSubs() async {
    try {
      List<StoreProduct> items = await Purchases.getProducts(
        productCategory: ProductCategory.subscription,
        type: PurchaseType.subs,
        ['monthly_premium', 'yearly_premium'],
      );

      print(items);
    } on PlatformException catch (e) {
      debugPrint("Error loading offerings info: $e");
    }
  }

  /// Müşteri bilgilerini yükler
  ///
  /// RevenueCat üzerinden müşteri bilgilerini yükler ve _customerInfo değişkenine atar.
  /// Hata durumunda konsola hata mesajı yazdırır.
  Future<void> loadCustomerInfo() async {
    try {
      _customerInfo = await Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      debugPrint("Error loading purchaser info: $e");
    }
  }

  /// Abonelik için giriş yapar
  ///
  /// Kullanıcının UID'sini kullanarak RevenueCat üzerinde giriş yapar.
  /// Web platformunda çalışmaz.
  Future<void> loginSubscription() async {
    if (kIsWeb) {
      return;
    }
    try {
      final String uid = authenticationService.getUser()?.uid ?? '';
      if (uid.isNotEmpty) {
        customerInfo = (await Purchases.logIn(uid)).customerInfo;
      }
    } on Exception catch (e) {
      debugPrint("Unable to logIn or logOut user in RevenueCat: $e");
    }
  }

  /// Abonelik ürünü satın alır
  ///
  /// [storeProduct] - Satın alınacak ürün
  /// [context] - BuildContext
  ///
  /// RevenueCat üzerinden abonelik ürünü satın alır.
  /// Başarılı satın alma durumunda kullanıcıyı bilgilendirir ve modalı kapatır.
  /// Hata durumunda uygun hata mesajını gösterir.
  Future<void> purchaseSubsItem(
      StoreProduct storeProduct, BuildContext context) async {
    try {
      var purchaseProduct = await Purchases.purchaseStoreProduct(storeProduct);
      customerInfo = purchaseProduct.customerInfo;
      if (customerInfo!.activeSubscriptions.isNotEmpty) {
        customSnackBar.success("Abonelik alımı başarılı.");
        Navigator.pop(context);
      }
    } catch (e) {
      customSnackBar.warning("Satın alım hatası.");
      debugPrint(e.toString());
    }
  }

  /// Kullanıcının aktif aboneliği olup olmadığını kontrol eder
  ///
  /// Kullanıcının aktif abonelikleri varsa true, yoksa false döndürür.
  bool checkUserHaveProduct() {
    if (customerInfo != null) {
      if (customerInfo!.activeSubscriptions.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  /// Abonelikten çıkış yapar
  ///
  /// RevenueCat üzerinde çıkış yapar ve müşteri bilgilerini günceller.
  Future<void> logoutSubs() async {
    try {
      if (customerInfo != null &&
          customerInfo!.activeSubscriptions.isNotEmpty) {
        customerInfo = await Purchases.logOut();
      }
    } catch (e) {
      customSnackBar.warning(e.toString());
    }
  }
}
