// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/global_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/logo.png"),
                      const SizedBox(height: 24),
                      Text("forgot_password".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailController,
                        validator: (value) =>
                            globalFunctions.emailValidator(value),
                        onFieldSubmitted: (value) async {
                          await forgotPassword();
                        },
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
                            await forgotPassword();
                          }, // Sen bağlayacaksın
                          child: Text(
                            "reset_password".tr,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
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

  Future<void> forgotPassword() async {
    if (globalFunctions.validateAndSave(formKey)) {
      setState(() {
        isLoading = true;
      });
      bool isSuccess = await authenticationService.forgotPassword(
        email: emailController.text,
      );
      setState(() {
        isLoading = false;
      });
      if (isSuccess) {
        Navigator.pop(context);
      }
    } else {
      customSnackBar.warning("fill_required_fields".tr);
    }
  }
}
