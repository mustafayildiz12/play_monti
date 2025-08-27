import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/utils.dart';

class MontessoriFifthOnboarding extends StatefulWidget {
  const MontessoriFifthOnboarding({super.key});

  @override
  State<MontessoriFifthOnboarding> createState() =>
      _MontessoriFifthOnboardingState();
}

class _MontessoriFifthOnboardingState extends State<MontessoriFifthOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _iconController1;
  late AnimationController _iconController2;
  late AnimationController _iconController3;
  late AnimationController _iconController4;

  @override
  void initState() {
    super.initState();
    _iconController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _iconController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat(reverse: true);
    _iconController3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _iconController4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController1.dispose();
    _iconController2.dispose();
    _iconController3.dispose();
    _iconController4.dispose();
    super.dispose();
  }

  Widget animatedIcon(
      {required String emoji,
      required AnimationController controller,
      double delay = 0}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offsetY =
            sin(controller.value * 2 * pi + delay) * 7; // 7px yukarı-aşağı
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        );
      },
      child: Image.asset(emoji, width: 48, height: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundDotsPainter(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Animasyonlu emojiler
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    animatedIcon(
                        emoji: "assets/seed.png", controller: _iconController1),
                    const SizedBox(width: 8),
                    animatedIcon(
                        emoji: "assets/palette.png",
                        controller: _iconController2,
                        delay: pi / 4),
                    const SizedBox(width: 8),
                    animatedIcon(
                        emoji: "assets/abc.png",
                        controller: _iconController3,
                        delay: pi / 2),
                    const SizedBox(width: 8),
                    animatedIcon(
                        emoji: "assets/puzzle.png",
                        controller: _iconController4,
                        delay: pi / 1.2),
                  ],
                ),
                const Spacer(flex: 2),
                Text(
                  "get_started_title".tr,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "get_started_subtitle".tr,
                  style: const TextStyle(fontSize: 18, color: Color(0xFF2C3E50)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "get_started_anytime".tr,
                  style: const TextStyle(
                      fontSize: 20, color: Color(0xFF2C3E50), height: 1.6),
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
}

class BackgroundDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF5F7FA);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    const blue = Color(0xFF4A90A4);
    const orange = Color(0xFFF4A460);

    const dotRadius = 2.75;
    const spacing = 42.0; // 50px aralık, HTML'deki background-size gibi

    // Y ekseninde satır, X ekseninde sütun olarak grid ile noktaları oluştur
    for (double y = spacing / 1.2; y < size.height; y += spacing) {
      for (double x = spacing / 1.2; x < size.width; x += spacing) {
        // Noktanın rengi ve yeri aritmetik olarak belirlenebilir:
        // (Çeşit olsun diye bir satır mavi, bir satır turuncu veya random)
        final color = ((x + y) ~/ spacing) % 2 == 0 ? blue : orange;
        final dotPaint = Paint()..color = color;
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
