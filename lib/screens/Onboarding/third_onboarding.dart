import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/utils.dart';

class MontessoriThirdOnboarding extends StatefulWidget {
  const MontessoriThirdOnboarding({super.key});

  @override
  State<MontessoriThirdOnboarding> createState() =>
      _MontessoriThirdOnboardingState();
}

class _MontessoriThirdOnboardingState extends State<MontessoriThirdOnboarding> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF0FAF5),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Center(child: handsActivity()),
              const Spacer(flex: 2),
              Text(
                "builds_brain_title".tr,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "builds_brain_play".tr,
                style: const TextStyle(
                    fontSize: 16, color: Color(0xFF5A6C7D), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "builds_brain_exploration".tr,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF6B7B8C), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "builds_brain_grow".tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF5A6C7D),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget handsActivity() {
    return Container(
      width: 180,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF4A90A4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text("👐", style: TextStyle(fontSize: 48)),
      ),
    );
  }
}
