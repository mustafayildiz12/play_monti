import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/utils.dart';

class MontessoriFirstOnboarding extends StatefulWidget {
  const MontessoriFirstOnboarding({super.key});

  @override
  State<MontessoriFirstOnboarding> createState() =>
      _MontessoriFirstOnboardingState();
}

class _MontessoriFirstOnboardingState extends State<MontessoriFirstOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Soft-shape widget
  Widget softShape(double width) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Animasyon: Yavaşça yukarı aşağı 0-10px arası
        final offsetY = sin(_animation.value * pi) * -10;
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        );
      },
      child: SizedBox(
        width: 250,
        height: 182.5,
        child: Stack(
          children: [
            // Ana renkli yumuşak şekil (HTML border-radius: 50% 20% 50% 20%)
            ClipPath(
              clipper: SoftShapeClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90A4), Color(0xFFF4A460)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            // Üstte hafif oval beyaz overlay (HTML ::before)
            Positioned(
              top: 24,
              left: 36,
              child: Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive için genişliği ayarlayalım
    final double maxWidth = MediaQuery.of(context).size.width * 0.6;
    final double shapeWidth = maxWidth.clamp(180, 280);
    print(Get.locale?.languageCode);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Soft shape animasyonlu container
              Center(child: softShape(shapeWidth)),
              const Spacer(flex: 2),
              Text(
                "why_offline".tr,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 16),
              Text(
                "why_offline_description".tr,
                style: const TextStyle(
                    fontSize: 18, color: Color(0xFF5A6C7D), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/globe.png', width: 36, height: 36),
                  const SizedBox(width: 12),
                  Image.asset('assets/block.png', width: 36, height: 36)
                ],
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class SoftShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Yüzde oranları: 50% 20% 50% 20% sırasıyla (sol üst, sağ üst, sağ alt, sol alt)
    final double largeRadius = size.height * 0.5;
    final double smallRadius = size.height * 0.2;

    final path = Path();
    // Sol üstten başla
    path.moveTo(0, largeRadius);

    // Sol üst -> Sağ üst
    path.quadraticBezierTo(0, 0, largeRadius, 0); // Sol üst radius
    path.lineTo(size.width - smallRadius, 0);

    // Sağ üst
    path.quadraticBezierTo(
        size.width, 0, size.width, smallRadius); // Sağ üst radius
    path.lineTo(size.width, size.height - largeRadius);

    // Sağ alt
    path.quadraticBezierTo(size.width, size.height, size.width - largeRadius,
        size.height); // Sağ alt radius
    path.lineTo(smallRadius, size.height);

    // Sol alt
    path.quadraticBezierTo(
        0, size.height, 0, size.height - smallRadius); // Sol alt radius
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
