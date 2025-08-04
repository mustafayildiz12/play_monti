import 'package:flutter/material.dart';

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
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget animatedShieldIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Image.asset('assets/shield.png', width: 90, height: 90),
    );
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
                const Text(
                  "Our Safer Approach",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "That's why this app works completely offline.",
                  style: TextStyle(fontSize: 16, color: Color(0xFF5A6C7D)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("✅ No ads",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                      Text("✅ No tracking",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                      Text("✅ No distractions",
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFF2C3E50))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Only Montessori-based, screen-light learning.",
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF6B7B8C), height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 3),
                Container(
                  width: 180,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90A4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90A4),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                  child: const Text('Next →'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
