import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/models/user_model.dart';
import 'package:play_monti/service/database_service.dart';
import 'package:provider/provider.dart';
import '../contexts/user_context.dart';

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
  String _language = 'Turkish';
  String _ageGroup = '';

  final List<String> _languages = [
    'Turkish',
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian'
  ];

  final List<Map<String, String>> _ageGroups = [
    {
      'id': '0-1',
      'label': '0–1 years',
      'icon': '👶',
      'description': 'Infant activities',
      'age-group': '18-24',
    },
    {
      'id': '1-3',
      'label': '1–3 years',
      'icon': '🚼',
      'description': 'Toddler development',
      'age-group': '24-36',
    },
    {
      'id': '3-8',
      'label': '3–8 years',
      'icon': '🧒',
      'description': 'Preschool & early school',
      'age-group': '36-48',
    }
  ];

  void _handleNext() {
    if (_step < 3) {
      setState(() {
        _step++;
      });
    } else {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserData(UserData(
        name: _name,
        language: _language,
        ageGroup: _ageGroup,
      ));

      databaseService.updateUserTimeData(
          ageActivity: _ageGroup, userName: _name, language: _language);
    }
  }

  bool _canProceed() {
    switch (_step) {
      case 1:
        return _name.trim().isNotEmpty;
      case 2:
        return _language.isNotEmpty;
      case 3:
        return _ageGroup.isNotEmpty;
      default:
        return false;
    }
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
          const Text(
            'Daily Montessori activities for your child',
            style: TextStyle(
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
        const Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'What should we call you?',
              style: TextStyle(
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
            hintText: 'Enter your name',
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
        const Column(
          children: [
            Icon(
              Icons.language_outlined,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            SizedBox(height: 16),
            Text(
              'Choose Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Select your preferred language',
              style: TextStyle(
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
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              final isSelected = _language == language;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _language = language;
                      });

                      Locale locale;
                      if (language == "Turkish") {
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
                        language,
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
        const Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: AppColors.kButtonGreenColor,
            ),
            SizedBox(height: 16),
            Text(
              'Child\'s Age Group',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.kTitleBlackTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This helps us show age-appropriate activities',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.kSubtitleTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Column(
          children: _ageGroups.map((group) {
            final isSelected = _ageGroup == group['age-group'];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _ageGroup = group['age-group']!),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.kButtonGreenColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          group['icon']!,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group['label']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.kTitleBlackTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                group['description']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : AppColors.kSubtitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
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
            backgroundColor:
                _canProceed() ? AppColors.kButtonGreenColor : const Color(0xFFC2B9A1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _step == 3 ? 'Get Started' : 'Continue',
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
