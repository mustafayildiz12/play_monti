// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:play_monti/constants/app_constants.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/screens/Onboarding/fifth_onboarding.dart';
import 'package:play_monti/screens/Onboarding/first_onboarding.dart';
import 'package:play_monti/screens/Onboarding/fourth_onboarding.dart';
import 'package:play_monti/screens/Onboarding/second_onboarding.dart';
import 'package:play_monti/screens/Onboarding/third_onboarding.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MontessoriFirstOnboarding(),
    MontessoriSecondOnboarding(),
    MontessoriThirdOnboarding(),
    MontessoriFourthOnboarding(),
    MontessoriFifthOnboarding(),
  ];

  void _goToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _next() => _goToPage(_currentIndex + 1);
  void _back() => _goToPage(_currentIndex - 1);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              physics:
                  const NeverScrollableScrollPhysics(), // Butonla geçiş için
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) => _pages[index],
            ),
            // Alt kısımda ileri-geri butonları ve (isteğe bağlı) göstergeler:
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Column(
                children: [
                  // İsteğe bağlı dot göstergesi

                  Container(
                    width: 180,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.2 * (_currentIndex + 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90A4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Geri butonu

                        Visibility(
                          visible: _currentIndex > 0,
                          maintainState: true,
                          maintainSize: true,
                          maintainAnimation: true,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90A4),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: _back,
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_back_ios),
                                Text('back'.tr),
                              ],
                            ),
                          ),
                        ),

                        // İleri veya Get Started
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90A4),
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: _currentIndex < _pages.length - 1
                              ? _next
                              : () async {
                                  await infoStorage.write("onboarding", true);
                                  await Navigator.of(context)
                                      .pushReplacementNamed(
                                          AppRoutes.loginPage);
                                },
                          child: _currentIndex < _pages.length - 1
                              ? Row(
                                  children: [
                                    Text('next'.tr),
                                    const Icon(Icons.arrow_forward_ios)
                                  ],
                                )
                              : Text("get_started_button".tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
