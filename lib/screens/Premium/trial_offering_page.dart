import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/screens/Premium/premium_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/service/in_app_purchase_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

class TrialOfferingPage extends StatefulWidget {
  const TrialOfferingPage({super.key});

  @override
  State<TrialOfferingPage> createState() => _TrialOfferingPageState();
}

class _TrialOfferingPageState extends State<TrialOfferingPage> {
  final InAppPurchaseService _iap = InAppPurchaseService();

  bool _loading = true;
  String? _error;

  // Trial ve normal products
  StoreProduct? _trialProduct;
  List<StoreProduct> _allProducts = [];

  final List<_Feature> features = [
    _Feature(icon: CupertinoIcons.cube_box_fill, title: "paywall.feature.1".tr),
    _Feature(icon: CupertinoIcons.headphones, title: "paywall.feature.2".tr),
    _Feature(
        icon: CupertinoIcons.checkmark_shield_fill,
        title: "paywall.feature.3".tr),
    _Feature(icon: CupertinoIcons.person_2_fill, title: "paywall.feature.4".tr),
  ];

  bool isTrial = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void checkIsTrial() async {
    bool trial = await _iap.isTrial();
    setState(() {
      isTrial = trial;
    });
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final items = await _iap.loadSubs();

      // Trial olan ürünü bul
      StoreProduct? trialProduct;
      for (final product in items) {
        final trialDays = _getTrialDays(product);
        if (trialDays != null && trialDays != "0") {
          trialProduct = product;
          break; // İlk trial ürünü alıyoruz
        }
      }

      setState(() {
        _allProducts = items;
        _trialProduct = trialProduct;
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

  String? _getTrialDays(StoreProduct product) {
    try {
      final opt =
          product.defaultOption ?? (product.subscriptionOptions?.firstOrNull);
      if (opt == null) return null;

      final trialPhase = opt.pricingPhases.firstWhere(
        (ph) => (ph.price.amountMicros ?? 1) == 0,
        orElse: () => null as PricingPhase,
      );

      final per = trialPhase.billingPeriod;
      if (per == null) return null;

      final unit = per.unit.name.toLowerCase();
      final count = per.value;

      if (unit.startsWith('day')) return '$count';
      if (unit.startsWith('week')) return '${count * 7}';
      if (unit.startsWith('month')) return '${count * 30}';
      if (unit.startsWith('year')) return '${count * 365}';
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _startTrial() async {
    try {
      await infoStorage.write("trialCount", 1);
      await Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.navigationBarPage, (_) => false);
    } catch (e) {
      customSnackBar.error("trial.start_failed".tr);
    }
  }

  void _showSubscriptionOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumBottomSheetPlayMonti(
        showTrialFirst: true, // Trial'ı öne çıkar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorView()
                : _buildMainContent(theme, screenHeight),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              "error.loading_products".tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProducts,
              child: Text("retry".tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.08),

            // Header
            Text(
              "trial.welcome_title".tr,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "trial.welcome_subtitle".tr,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),

            SizedBox(height: screenHeight * 0.06),

            // Features
            _buildFeaturesSection(),

            SizedBox(height: screenHeight * 0.08),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature.icon,
                      size: 24,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      feature.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ],
              ),
              if (index < features.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (isTrial) ...[
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: _startTrial,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.play_circle),
                  const SizedBox(width: 8),
                  Text(
                    "trial.start_button".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Subscribe Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _showSubscriptionOptions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.star),
                const SizedBox(width: 8),
                Text(
                  "trial.subscribe_button".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  const _Feature({required this.icon, required this.title});
}
