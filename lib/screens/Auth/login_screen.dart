import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png"),
                    const SizedBox(height: 24),
                    Text(
                      "welcome".tr,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "email".tr,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: "password".tr,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.kButtonColor2),
                            foregroundColor: WidgetStatePropertyAll(
                                AppColors.kCalendarLightGreenColor)),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await authenticationService.login(context,
                              email: emailController.text,
                              password: passwordController.text);
                          setState(() {
                            isLoading = false;
                          });
                        }, // Sen bağlayacaksın
                        child: Text(
                          "login".tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("or".tr),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        icon: Image.asset(
                          "assets/google.png",
                          height: 24,
                        ),
                        label: Text("loginGoogle".tr),
                        onPressed: () async {
                          await authenticationService.signInWithGoogle(
                              context: context);
                        }, // Google sign-in
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (Platform.isIOS)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.apple, size: 24),
                          label: Text("loginApple".tr),
                          onPressed: () {}, // Apple sign-in
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.registerPage),
                      child: Text("donthaveAccount".tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
