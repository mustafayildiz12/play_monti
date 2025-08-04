import 'package:flutter/material.dart';

class MontessoriThirdOnboarding extends StatelessWidget {
  const MontessoriThirdOnboarding({super.key});

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
              const Text(
                "What Builds a Brain?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Real play builds real brains. 🖐️👀👂",
                style: TextStyle(fontSize: 16, color: Color(0xFF5A6C7D), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                "Active exploration wires the brain faster than passive screen viewing.",
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7B8C), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's grow, not just watch.",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF5A6C7D),
                ),
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
                  widthFactor: 0.6,
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
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                child: const Text('Next →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
