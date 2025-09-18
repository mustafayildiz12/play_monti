import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/service/in_app_purchase_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

enum PremiumType { monthly, yearly }

class PremiumBottomSheetPlayMonti extends StatefulWidget {
  const PremiumBottomSheetPlayMonti({super.key});

  @override
  State<PremiumBottomSheetPlayMonti> createState() =>
      _PremiumBottomSheetPlayMontiState();
}

class _PremiumBottomSheetPlayMontiState
    extends State<PremiumBottomSheetPlayMonti> {
  PremiumType selectedType = PremiumType.monthly;

  final List<_Feature> features = [
    _Feature(icon: CupertinoIcons.cube_box_fill, title: "paywall.feature.1".tr),
    _Feature(icon: CupertinoIcons.headphones, title: "paywall.feature.2".tr),
    _Feature(
        icon: CupertinoIcons.checkmark_shield_fill,
        title: "paywall.feature.3".tr),
    _Feature(icon: CupertinoIcons.person_2_fill, title: "paywall.feature.4".tr),
  ];

  int pageIndex = 0;

  // Dinamik ürün state’i
  final InAppPurchaseService _iap = InAppPurchaseService();
  bool _loading = true;
  String? _error;

  StoreProduct? _monthlyProduct;
  StoreProduct? _yearlyProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Senin verdiğin loadSubs() yöntemi getProducts çağırıyor.
      // Alternatif direkt çağrı: Purchases.getProducts([...])
      final items =
          await _iap.loadSubs(); // <-- service’ine bu yöntemi eklersen harika
      // Eğer bu method yoksa: final items = await Purchases.getProducts(
      //   productCategory: ProductCategory.subscription,
      //   type: PurchaseType.subs,
      //   ['premium_monthly','premium_yearly','monthly_premium','yearly_premium'],
      // );

      // Aylık/Yıllık eşleştir
      StoreProduct? monthly;
      StoreProduct? yearly;
      for (final p in items) {
        if (_isMonthly(p)) monthly = p;
        if (_isYearly(p)) yearly = p;
      }

      setState(() {
        _monthlyProduct = monthly;
        _yearlyProduct = yearly;
        // Mevcut olana göre default seçim
        if (_monthlyProduct == null && _yearlyProduct != null) {
          selectedType = PremiumType.yearly;
        } else {
          selectedType = PremiumType.monthly;
        }
      });
    } on PlatformException catch (e) {
      setState(() {
        _error = e.message ?? e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // “P1M” ya da id’de “month” geçenleri aylık kabul et
  bool _isMonthly(StoreProduct p) {
    final per = _periodIso(p);
    return per == 'P1M' ||
        p.identifier.toLowerCase().contains('month') ||
        p.title.toLowerCase().contains('month');
  }

  // “P1Y” ya da id’de “year” geçenleri yıllık kabul et
  bool _isYearly(StoreProduct p) {
    final per = _periodIso(p);
    return per == 'P1Y' ||
        p.identifier.toLowerCase().contains('year') ||
        p.title.toLowerCase().contains('year');
  }

  String _periodIso(StoreProduct p) {
    // purchases_flutter son sürümlerde subscriptionPeriod ISO8601 string’i dönebiliyor.
    // Senin log’unda en sonda “, P1M” gördüm; yoksa “P1M/P1Y” yi subscriptionOptions üzerinden çıkaralım.
    try {
      final sub = p.subscriptionPeriod; // bazı sürümlerde mevcut
      if (sub != null && sub.isNotEmpty) return sub;
    } catch (_) {}
    // Fallback: aktif option’ın billingPeriod’ı
    try {
      final opt = p.defaultOption ?? (p.subscriptionOptions?.firstOrNull);
      final iso = opt?.billingPeriod?.iso8601 ?? '';
      if (iso.isNotEmpty) return iso;
    } catch (_) {}
    return '';
  }

  // Ücretsiz deneme “gün” bilgisi (0 ise pill gösterme)
  String? _trialDays(StoreProduct p) {
    try {
      final opt = p.defaultOption ?? (p.subscriptionOptions?.firstOrNull);
      if (opt == null) return null;
      // PricingPhase’lerde fiyatı 0 olan ilk phase trial kabul edelim
      final trialPhase = opt.pricingPhases.firstWhere(
        (ph) => (ph.price.amountMicros ?? 1) == 0,
        orElse: () => null as PricingPhase,
      );

      final per = trialPhase.billingPeriod;
      if (per == null) return null;
      // Sadece gün/ay/yıl sayısını yorumla
      final unit = per.unit.name.toLowerCase(); // day, week, month, year
      final count = per.value;
      // App’te “7”/“14” gibi kısa yazıyorsun, onu dönelim:
      if (unit.startsWith('day')) return '$count';
      if (unit.startsWith('week')) return '${count * 7}';
      if (unit.startsWith('month')) return '${count * 30}';
      if (unit.startsWith('year')) return '${count * 365}';
      return null;
    } catch (_) {
      return null;
    }
  }

  StoreProduct? get _selectedProduct =>
      selectedType == PremiumType.monthly ? _monthlyProduct : _yearlyProduct;

  Future<void> _purchaseSelected() async {
    final product = _selectedProduct;
    if (product == null) {
      customSnackBar.error("paywall.snackbar.no_product".tr);
      return;
    }
    try {
      final result = await Purchases.purchaseStoreProduct(product);
      // result.customerInfo / entitlements ile premium’u doğrula
      customSnackBar.success("paywall.snackbar.selected".tr);
      if (mounted) Navigator.of(context).maybePop();
    } on PlatformException catch (e) {
      // Kullanıcı iptal etmiş olabilir vs.
      debugPrint("Purchase error: $e");
      customSnackBar.error("paywall.snackbar.purchase_failed".tr);
    }
  }

  Future<void> _restore() async {
    try {
      await _iap.restorePurchases();
      customSnackBar.success("paywall.snackbar.restore".tr);
    } catch (e) {
      customSnackBar.error("paywall.snackbar.restore_failed".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      minChildSize: 0.5,
      initialChildSize: 0.9,
      maxChildSize: 0.92,
      builder: (c, s) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.appBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _restore,
                      child: Text(
                        'paywall.refresh'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.clear,
                            color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),

                if (_loading) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ] else if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: _loadProducts,
                    child: Text("paywall.retry".tr),
                  ),
                ] else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            "paywall.title".tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "paywall.subtitle".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Features – PageView
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2)),
                              ],
                            ),
                            child: PageView.builder(
                              itemCount: features.length,
                              onPageChanged: (i) =>
                                  setState(() => pageIndex = i),
                              itemBuilder: (_, i) {
                                final f = features[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF7FF),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(f.icon,
                                            size: 44,
                                            color: const Color(0xFF3B82F6)),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          f.title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (pageIndex + 1) / features.length,
                              backgroundColor: const Color(0xFFE0F2FE),
                              color: const Color(0xFF3B82F6),
                              minHeight: 6,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // MONTHLY
                          if (_monthlyProduct != null) ...[
                            _PlanCard(
                              title: "paywall.plan.monthly".tr,
                              subtitle: "paywall.plan.monthly.subtitle".tr,
                              priceText: _monthlyProduct!.priceString,
                              selected: selectedType == PremiumType.monthly,
                              trialDays: _trialDays(
                                  _monthlyProduct!), // null veya "0" ise pill gizlenir
                              periodLabel: "",

                              onTap: () => setState(
                                  () => selectedType = PremiumType.monthly),
                            ),
                          ],
                          const SizedBox(height: 16),
// YEARLY
                          if (_yearlyProduct != null) ...[
                            _PlanCard(
                              title: "paywall.plan.yearly".tr,
                              subtitle: "paywall.plan.yearly.subtitle".tr,
                              priceText: _yearlyProduct!.priceString,
                              selected: selectedType == PremiumType.yearly,
                              trialDays: _trialDays(_yearlyProduct!),
                              periodLabel: "",
                              onTap: () => setState(
                                  () => selectedType = PremiumType.yearly),
                            ),
                          ],
                          const SizedBox(height: 16),
                          // CTA
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _purchaseSelected,
                              child: Text("paywall.cta".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Restore + Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: _restore,
                                child: Text(
                                  "paywall.restore".tr,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Icon(Icons.circle, size: 5),
                              TextButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (_) => const _InfoDialog()),
                                child: Text(
                                  "paywall.info.title".tr,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Footer links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(
                            "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/");
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        "paywall.terms".tr,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ),
                    const Icon(Icons.circle, size: 6),
                    TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(
                            "https://kuyumcu-fd31a.firebaseapp.com/#/playMontiPolicy");
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        "paywall.privacy".tr,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String priceText; // Örn: ₺144,00
  final String subtitle; // Çeviri ile gelen metin
  final bool selected;
  final String? chipText; // Örn: "Popular" (opsiyonel)
  final VoidCallback onTap;
  final String?
      trialDays; // Örn: "7" / "14" / null -> null veya "0" ise gizlenir
  final String? periodLabel; // Örn: "/ ay", "/ yıl" (opsiyonel)

  const _PlanCard({
    required this.title,
    required this.priceText,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.trialDays,
    this.chipText,
    this.periodLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = selected
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFEFF7FF), Color(0xFFE6F7EE)],
          )
        : null;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 128,
        width: double.infinity,
        decoration: BoxDecoration(
          color: selected ? null : Colors.white,
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
          border: selected
              ? Border.all(color: const Color(0xFF93C5FD), width: 1)
              : null,
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title + Radio
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Radio<bool>(
                  value: true,
                  groupValue: selected,
                  onChanged: (_) => onTap(),
                  fillColor: WidgetStatePropertyAll(Colors.green.shade500),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),

            // Price row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fiyat
                Text(
                  priceText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                // Dönem etiketi (opsiyonel) — örn: "/ ay"
                if ((periodLabel ?? '').isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    periodLabel!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
                const SizedBox(width: 8),

                // Trial pill (trialDays varsa ve "0" değilse göster)
                if (trialDays != null && trialDays != "0")
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF16A34A)),
                    ),
                    child: Text(
                      "paywall.trial.pill".trParams({"days": trialDays!}),
                      // örn: "7-day free trial" çevirinizde {days} paramı kullanın
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),

                const Spacer(),

                // Badge (opsiyonel)
                if (chipText != null && chipText!.isNotEmpty)
                  Chip(
                    backgroundColor: Colors.black87,
                    label: Text(
                      chipText!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),

            // Subtitle
            Row(
              children: [
                const Icon(CupertinoIcons.info,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeTrialPill extends StatelessWidget {
  const _FreeTrialPill({
    required this.day,
    super.key,
  });
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF16A34A)),
      ),
      child: Text(
        "paywall.trial.pill".tr,
        style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF166534)),
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("paywall.info.title".tr),
      content: SingleChildScrollView(
        child: Text(
          "paywall.info.body".tr,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("close".tr)),
      ],
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  const _Feature({required this.icon, required this.title});
}
