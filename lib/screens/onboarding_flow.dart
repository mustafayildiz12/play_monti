// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/models/age_group_model.dart';
import 'package:play_monti/models/language_model.dart';
import 'package:play_monti/service/database_service.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 1;
  String _name = '';
  LanguageModel? selectedLanguage;
  AgeGroupModel? selectedAgeGroup;

  Future<void> _handleNext() async {
    if (_step < 3) {
      setState(() {
        _step++;
      });
    } else {
      currentMontiUser!.ageActivity = selectedAgeGroup!.ageGroupCode;
      currentMontiUser!.languageCode = selectedLanguage!.languageCode;

      await databaseService.updateUserTimeData(
          ageActivity: selectedAgeGroup!.ageGroupCode,
          userName: _name,
          language: selectedLanguage!.languageName,
          languageCode: selectedLanguage!.languageCode);
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.navigationBarPage, (_) => false);
    }
  }

  bool _canProceed() {
    switch (_step) {
      case 1:
        return _name.trim().isNotEmpty;
      case 2:
        return selectedLanguage != null;
      case 3:
        return selectedAgeGroup != null;
      default:
        return false;
    }
  }

  @override
  void initState() {
    if (Get.locale!.languageCode == "en") {
      selectedLanguage =
          enLanguageList.singleWhere((e) => e.languageCode == "en");
    } else {
      selectedLanguage =
          trLanguageList.singleWhere((e) => e.languageCode == "tr");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Progress Bar
            _buildProgressBar(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildStepContent(),
              ),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.kButtonGreenColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Text(
                '🌱',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MontiTime',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.kTitleBlackTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'daily_montessori'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.kSubtitleTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < _step
                    ? AppColors.kButtonGreenColor
                    : const Color(0xFFC2B9A1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Column(
          children: [
            const Icon(
              Icons.person_outline,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            const SizedBox(height: 16),
            Text(
              'welcome'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'what_call_you'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.kSubtitleTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 32),
        TextField(
          onChanged: (value) => setState(() => _name = value),
          decoration: InputDecoration(
            hintText: 'enter_name_hint'.tr,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(
              fontSize: 16, color: AppColors.kTitleBlackTextColor),
          autofocus: true,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        Column(
          children: [
            const Icon(
              Icons.language_outlined,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            const SizedBox(height: 16),
            Text(
              'choose_language'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'select_language'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.kSubtitleTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 320,
          child: ListView.builder(
            itemCount: enLanguageList.length,
            itemBuilder: (context, index) {
              final language = Get.locale?.languageCode == "en"
                  ? enLanguageList[index]
                  : trLanguageList[index];
              final isSelected = selectedLanguage == language;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        selectedLanguage = language;
                      });

                      if (selectedLanguage?.languageCode == "en") {
                        selectedLanguage = enLanguageList
                            .singleWhere((e) => e.languageCode == "en");
                      } else {
                        selectedLanguage = trLanguageList
                            .singleWhere((e) => e.languageCode == "tr");
                      }

                      Locale locale;
                      if (language.languageCode == "tr") {
                        locale = const Locale("tr");
                      } else {
                        locale = const Locale("en");
                      }
                      await Get.updateLocale(locale);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.kButtonGreenColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        language.languageName,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : AppColors.kTitleBlackTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Column(
          children: [
            const Icon(
              Icons.people_outline,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            const SizedBox(height: 16),
            Text(
              "child_age_group".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'child_age_help'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.kSubtitleTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 370,
          child: ListView.builder(
            itemCount: enAgeGroupList.length,
            itemBuilder: (context, index) {
              final ageGroup = Get.locale?.languageCode == "en"
                  ? enAgeGroupList[index]
                  : trAgeGroupList[index];

              bool isSelected = selectedAgeGroup == ageGroup;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedAgeGroup = ageGroup;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.kButtonGreenColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ageGroup.ageGroupName,
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _canProceed() ? _handleNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canProceed()
                ? AppColors.kButtonGreenColor
                : const Color(0xFFC2B9A1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _step == 3 ? 'get_started_button'.tr : 'continue_or_start'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
