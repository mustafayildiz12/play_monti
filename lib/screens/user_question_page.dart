import 'package:flutter/material.dart';
import 'package:play_monti/screens/onboarding_flow.dart';

class UserQuestionPage extends StatefulWidget {
  const UserQuestionPage({super.key});

  @override
  State<UserQuestionPage> createState() => _UserQuestionPageState();
}

class _UserQuestionPageState extends State<UserQuestionPage> {
  @override
  Widget build(BuildContext context) {
    return const OnboardingFlow();
  }
}
