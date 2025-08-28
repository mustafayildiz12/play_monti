import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/global_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

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

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: formKey,
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
                      TextFormField(
                        controller: emailController,
                        validator: (value) =>
                            globalFunctions.emailValidator(value),
                        decoration: InputDecoration(
                          labelText: "email".tr,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscure,
                        validator: (value) =>
                            globalFunctions.nonEmptyRule(value),
                        onFieldSubmitted: (value) async {
                          await login();
                        },
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
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.kButtonColor2),
                              foregroundColor: WidgetStatePropertyAll(
                                  AppColors.kCalendarLightGreenColor)),
                          onPressed: () async {
                            await login();
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
                      Row(
                        children: [
                          TextButton(
                            style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.all(4))),
                            onPressed: () => Navigator.pushNamed(
                                context, AppRoutes.forgotPasswordPage),
                            child: Text("forgot_password".tr),
                          ),
                          const Spacer(),
                          TextButton(
                            style: const ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.all(4))),
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.registerPage),
                            child: Text("donthaveAccount".tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (globalFunctions.validateAndSave(formKey)) {
      setState(() {
        isLoading = true;
      });
      await authenticationService.login(context,
          email: emailController.text, password: passwordController.text);
      setState(() {
        isLoading = false;
      });
    } else {
      customSnackBar.warning("fill_required_fields".tr);
    }
  }
}
