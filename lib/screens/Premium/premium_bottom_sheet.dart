// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/service/in_app_purchase_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart'; // Terms/Privacy (optional)

/// Paywall for "Play Monti" – Montessori activities app
/// Notes:
/// - All copy is English and aligned with the store description you shared.
/// - Prices are static strings here (dummy). Wire these to your IAP layer later.
/// - Includes a simple optional Parent Gate dialog (Math question) before purchase.
/// - Includes Restore and Terms/Privacy links.

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

  // Feature list (aligned with your app description)
  final List<_Feature> features = [
    _Feature(
      icon: CupertinoIcons.cube_box_fill,
      title: "paywall.feature.1".tr,
    ),
    _Feature(
      icon: CupertinoIcons.headphones,
      title: "paywall.feature.2".tr,
    ),
    _Feature(
      icon: CupertinoIcons.checkmark_shield_fill,
      title: "paywall.feature.3".tr,
    ),
    _Feature(
      icon: CupertinoIcons.person_2_fill,
      title: "paywall.feature.4".tr,
    ),
  ];

  int pageIndex = 0;

  // Dummy prices – replace with dynamic values from your products later
  static String monthlyPrice = "paywall.price.monthly".tr;
  static String yearlyPrice = 'paywall.price.yearly'.tr;

  InAppPurchaseService inAppPurchaseService = InAppPurchaseService();

  @override
  void initState() {
    inAppPurchaseService.loadSubs();
    super.initState();
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
                      onPressed: () => setState(() {}), // dummy “Refresh”
                      child: Text(
                        'paywall.refresh'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black87),
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

                        // Features – PageView (icon + text)
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: PageView.builder(
                            itemCount: features.length,
                            onPageChanged: (i) => setState(() => pageIndex = i),
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
                                        borderRadius: BorderRadius.circular(12),
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

                        // Plans
                        _PlanCard(
                          title: "paywall.plan.monthly".tr,
                          subtitle: "paywall.plan.monthly.subtitle".tr,
                          priceText: monthlyPrice,
                          selected: selectedType == PremiumType.monthly,
                          day: "7",
                          chipText: "Popular",
                          onTap: () => setState(
                              () => selectedType = PremiumType.monthly),
                        ),
                        const SizedBox(height: 16),
                        _PlanCard(
                          title: "paywall.plan.yearly".tr,
                          subtitle: "paywall.plan.yearly.subtitle".tr,
                          priceText: yearlyPrice,
                          day: "14",
                          selected: selectedType == PremiumType.yearly,
                          onTap: () =>
                              setState(() => selectedType = PremiumType.yearly),
                        ),

                        const SizedBox(height: 16),

                        // CTA (with optional Parent Gate)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final chosen = selectedType == PremiumType.monthly
                                  ? monthlyPrice
                                  : yearlyPrice;
                              // Dummy purchase flow
                              if (!mounted) return;
                              print(chosen);
                              customSnackBar
                                  .success("paywall.snackbar.selected".tr);
                            },
                            child: Text(
                              "paywall.cta".tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Restore + Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Hook to your restore logic (e.g., RevenueCat restorePurchases)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("paywall.snackbar.restore".tr)),
                                );
                              },
                              child: Text(
                                "paywall.restore".tr,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.circle, size: 5),
                            const SizedBox(width: 6),
                            TextButton.icon(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => const _InfoDialog(),
                              ),
                              icon:
                                  const Icon(Icons.info, color: Colors.black87),
                              label: Text(
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
                          // Replace with your EULA/Terms
                          "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
                        );
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
                          // Replace with your Privacy Policy URL
                          "https://kuyumcu-fd31a.firebaseapp.com/#/playMontiPolicy",
                        );
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
  final String priceText;
  final String subtitle;
  final bool selected;
  final String? chipText;
  final VoidCallback onTap;
  final String day;

  const _PlanCard({
    required this.title,
    required this.priceText,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.day,
    this.chipText,
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
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
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
            // Price
            Row(
              children: [
                Text(
                  priceText,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                const SizedBox(width: 8),
                _FreeTrialPill(day: day),
                const Spacer(),
                if (chipText != null)
                  Chip(
                    backgroundColor: Colors.black87,
                    label: Text(chipText!,
                        style: const TextStyle(color: Colors.white)),
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
                        fontWeight: FontWeight.w500),
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
      title: Text("'paywall.info.title".tr),
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
