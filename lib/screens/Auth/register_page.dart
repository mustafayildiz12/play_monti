import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/constants/app_routes.dart';
import 'package:play_monti/service/authentication_service.dart';
import 'package:play_monti/service/global_service.dart';
import 'package:play_monti/utlis/widgets/custom_loader.dart';
import 'package:play_monti/utlis/widgets/custom_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                        "register".tr,
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
                          await register();
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
                            await register();
                          }, // Sen bağlayacaksın
                          child: Text(
                            "register".tr,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.loginPage),
                        child: Text("alreadyHaveAccount".tr),
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

  Future<void> register() async {
    if (globalFunctions.validateAndSave(formKey)) {
      setState(() {
        isLoading = true;
      });
      await authenticationService.registerAndSaveUser(
          email: emailController.text,
          password: passwordController.text,
          context: context);
      setState(() {
        isLoading = false;
      });
    } else {
      customSnackBar.warning("fill_required_fields".tr);
    }
  }
}
