import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/age_group_model.dart';
import 'package:play_monti/models/language_model.dart';
import 'package:play_monti/screens/Home/ActivityDetail/activity_feedbak_bottom_sheet.dart';
import 'package:play_monti/screens/Premium/premium_paywall.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:play_monti/service/in_app_purchase_service.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Palette (önceki ekranlarla uyumlu)
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const textHint = Color(0xFF999999);
  static const greenLight = Color(0xFF91A88E);
  static const greenDark = Color(0xFF6BAA75);

  bool _notificationsOn = false;

  LanguageModel? selectedLanguage;
  AgeGroupModel? selectedAgeGroup;

  bool isUserPremium = false;

  @override
  void initState() {
    if (Get.locale!.languageCode == "en") {
      selectedAgeGroup = enAgeGroupList
          .singleWhere((e) => e.ageGroupCode == currentMontiUser?.ageActivity);
    } else {
      selectedAgeGroup = trAgeGroupList
          .singleWhere((e) => e.ageGroupCode == currentMontiUser?.ageActivity);
    }

    checkUserPremium();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (Get.locale != null) {
      if (Get.locale!.languageCode == "en") {
        selectedLanguage =
            enLanguageList.singleWhere((e) => e.languageCode == "en");
      } else {
        selectedLanguage =
            trLanguageList.singleWhere((e) => e.languageCode == "tr");
      }
    }
    super.didChangeDependencies();
  }

  Future<void> checkUserPremium() async {
    InAppPurchaseService iap = InAppPurchaseService();
    bool isP = await iap.isPremium();
    setState(() {
      isUserPremium = isP;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'settings'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.kTitleBlackTextColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'customizeExperience'.tr,
                      style: const TextStyle(
                          color: AppColors.kSubtitleTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            // Profile card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: greenLight,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentMontiUser?.userName ?? "",
                                style: const TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                )),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedLanguage?.languageName} • ${selectedAgeGroup?.ageGroupCode}',
                              style: const TextStyle(
                                  color: textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (!isUserPremium) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3B82F6),
                        side: const BorderSide(
                            color: Color(0xFF3B82F6), width: 2),
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
                            "paywall.cta".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],

            // Language
            _SliverSettingTile(
              leadingBg: const Color(0xFFF0F8F0),
              leadingIcon: Ionicons.globe_outline,
              onTap: _pickLanguage,
              title: 'language'.tr,
              subtitle: selectedLanguage?.languageName ?? "",
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Age group
            _SliverSettingTile(
              leadingBg: const Color(0xFFF0F8F0),
              leadingIcon: Ionicons.people,
              onTap: _pickAgeGroup,
              title: "child_age_group".tr,
              subtitle: selectedAgeGroup?.ageGroupName ?? "",
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Notifications (switch)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: [
                      const _LeadingIcon(
                        bg: Color(0xFFF0F8F0),
                        icon: Ionicons.notifications_outline,
                        iconColor: greenDark,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('notifications'.tr,
                                style: const TextStyle(
                                  color: textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 2),
                            Text('dailyReminders'.tr,
                                style: const TextStyle(
                                    color: textMuted, fontSize: 13)),
                          ],
                        ),
                      ),
                      // Custom switch görünümü
                      GestureDetector(
                        onTap: () => _toggleNotifications(!_notificationsOn),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 54,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _notificationsOn
                                ? greenLight
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: _notificationsOn
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Feedback
            _SliverSettingTile(
              leadingBg: const Color(0xFFF0F8F0),
              leadingIcon: Ionicons.chatbox_outline,
              onTap: () async {
                await showFeedbackBottomSheet();
              },
              title: 'sendFeedback'.tr,
              subtitle: 'helpImprove'.tr,
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Footer
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    const Text(
                      'MontiTime 1.0.0',
                      style: TextStyle(color: textHint, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "made_with".tr,
                      style: const TextStyle(color: textHint, fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await authenticationService
                                .logoutFromFirebase(context);
                          },
                          child: Text("log_out".tr),
                        ),
                        TextButton(
                          onPressed: () async {
                            await showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Hesabınızı silmek istediğinize emin misiniz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Hayır"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("Evet"),
                                    ),
                                  ],
                                );
                              },
                            ).then((v) async {
                              if (v != null) {
                                await databaseService.deleteAccount(context);
                              }
                            });
                          },
                          child: Text("delete_account".tr),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (currentMontiUser?.isAdmin == true)
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.uploadActivityPage);
                        },
                        child: const Text("Yükle")),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.activityTable);
                        },
                        child: const Text("Aktiviteler")),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> showFeedbackBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackBottomSheet(),
    );
  }

  // ——— Actions ———

  Future<void> _showSubscriptionOptions() async {
    await Navigator.pushNamed(context, AppRoutes.premiumPaywall).then((
      v,
    ) async {
      if (v != null && v == true) {
        await checkUserPremium();
      }
    });
  }

  Future<void> _pickLanguage() async {
    final selected = await showModalBottomSheet<LanguageModel>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _LanguagePickerSheet(
        title: 'Choose language',
        options:
            Get.locale?.languageCode == "en" ? enLanguageList : trLanguageList,
        initial: selectedLanguage,
      ),
    );
    if (selected != null && selected != selectedLanguage) {
      setState(() {
        selectedLanguage = selected;
      });

      if (selectedLanguage?.languageCode == "en") {
        selectedLanguage =
            enLanguageList.singleWhere((e) => e.languageCode == "en");
        selectedAgeGroup = enAgeGroupList.singleWhere(
            (e) => e.ageGroupCode == currentMontiUser?.ageActivity);
      } else {
        selectedLanguage =
            trLanguageList.singleWhere((e) => e.languageCode == "tr");
        selectedAgeGroup = trAgeGroupList.singleWhere(
            (e) => e.ageGroupCode == currentMontiUser?.ageActivity);
      }
      await databaseService.updateUserLanguage(language: selectedLanguage!);
      await infoStorage.write("languageCode", selectedLanguage!.languageCode);
      await Get.updateLocale(Locale(selectedLanguage!.languageCode));
    }
  }

  Future<void> _pickAgeGroup() async {
    final selected = await showModalBottomSheet<AgeGroupModel>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AgePickerSheet(
        title: "Choose child's age group",
        options:
            Get.locale?.languageCode == "en" ? enAgeGroupList : trAgeGroupList,
      ),
    );
    if (selected != null && selected != selectedAgeGroup) {
      setState(() {
        selectedAgeGroup = selected;
      });

      await databaseService.updateUserActivity(ageGroup: selectedAgeGroup!);
      customSnackBar.success("activity_updated".tr);
    }
  }

  void _toggleNotifications(bool v) {
    setState(() => _notificationsOn = v);
  }
}

// ——— Reusable tiles & UI helpers ———

class _SliverSettingTile extends StatelessWidget {
  const _SliverSettingTile({
    required this.leadingBg,
    required this.leadingIcon,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  final Color leadingBg;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  _LeadingIcon(bg: leadingBg, icon: leadingIcon),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                              color: _SettingsColors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: const TextStyle(
                              color: _SettingsColors.textMuted,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: _SettingsColors.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({
    required this.bg,
    required this.icon,
    this.iconColor = _SettingsColors.greenDark,
  });

  final Color bg;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({
    required this.title,
    required this.options,
    this.initial,
  });

  final String title;
  final List<LanguageModel> options;
  final LanguageModel? initial;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _SettingsColors.textDark,
                  fontSize: 16,
                )),
            const SizedBox(height: 12),
            ...options.map((o) => PickerOption(
                  text: o.languageName,
                  selected: o == initial,
                  onTap: () => Navigator.pop(context, o),
                )),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class AgePickerSheet extends StatelessWidget {
  const AgePickerSheet({
    super.key,
    required this.title,
    required this.options,
    this.initial,
  });

  final String title;
  final List<AgeGroupModel> options;
  final AgeGroupModel? initial;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _SettingsColors.textDark,
                  fontSize: 16,
                )),
            const SizedBox(height: 12),
            ...options.map((o) => PickerOption(
                  text: o.ageGroupName,
                  selected: o == initial,
                  onTap: () => Navigator.pop(context, o),
                )),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class PickerOption extends StatelessWidget {
  const PickerOption({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: _SettingsColors.textDark,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: _SettingsColors.greenDark)
          : null,
      onTap: onTap,
    );
  }
}

class _SettingsColors {
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF666666);
  static const greenDark = Color(0xFF6BAA75);
}
