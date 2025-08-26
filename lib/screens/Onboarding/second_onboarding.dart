import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class MontessoriSecondOnboarding extends StatelessWidget {
  const MontessoriSecondOnboarding({super.key});

  Widget parentChildFigure() {
    return SizedBox(
      width: 150,
      height: 120,
      child: Stack(
        children: [
          // Parent
          Positioned(
            left: 0,
            child: Container(
              width: 80,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF4A90A4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(40, 50),
                  topRight: Radius.elliptical(36, 48),
                  bottomLeft: Radius.elliptical(48, 50),
                  bottomRight: Radius.elliptical(36, 48),
                ),
              ),
            ),
          ),
          // Child
          Positioned(
            right: 20,
            top: 30,
            child: Container(
              width: 50,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFF4A460),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(20, 35),
                  topRight: Radius.elliptical(24, 35),
                  bottomLeft: Radius.elliptical(25, 35),
                  bottomRight: Radius.elliptical(24, 35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Center(child: parentChildFigure()),
              const Spacer(flex: 2),
              Text(
                "early_screens_title".tr,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "early_screens_subtitle".tr,
                style: const TextStyle(fontSize: 16, color: Color(0xFF5A6C7D)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text("📱🧠", style: TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                "early_screens_risks".tr,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF6B7B8C), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
