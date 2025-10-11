import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';

class MontessoriFourthOnboarding extends StatefulWidget {
  const MontessoriFourthOnboarding({super.key});

  @override
  State<MontessoriFourthOnboarding> createState() =>
      _MontessoriFourthOnboardingState();
}

class _MontessoriFourthOnboardingState extends State<MontessoriFourthOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE8F3FF),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F3FF),
              Color(0xFFFFF0E8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Center(child: animatedShieldIcon()),
                const Spacer(flex: 2),
                Text(
                  "safer_approach_title".tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "safer_approach_subtitle".tr,
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xFF5A6C7D)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("safer_approach_no_ads".tr,
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                      Text("safer_approach_no_tracking".tr,
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                      Text("safer_approach_no_distractions".tr,
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "safer_approach_montessori".tr,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF6B7B8C), height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget animatedShieldIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Image.asset('assets/shield.png', width: 90, height: 90),
    );
  }
}
