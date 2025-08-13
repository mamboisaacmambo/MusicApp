import 'package:client/core/utils/dialogues.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_view_model.dart';
import 'package:client/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/auth_gradient_button.dart';
import '../../../../core/widgets/custom_field.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SigninPage()),
            (route) => false,
          );
        },
        error: (error, st) {
          Dialogues.showErrorDialog(
            context,
            error.toString(),
            'Login Error',
            () {
              Navigator.pop(context);
            },
          );
        },
        loading: () {},
      );
    });
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(),
        body:
            isLoading
                ? const Loader()
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign In.",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomField(
                            hintText: 'Email',
                            controller: _emailController,
                          ),
                          const SizedBox(height: 15),
                          CustomField(
                            hintText: 'Password',
                            controller: _passwordController,
                            isObsecureText: true,
                          ),
                          const SizedBox(height: 20),
                          Builder(
                            builder: (context) {
                              return AuthGradientButton(
                                buttonText: 'Login',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final result = await ref
                                          .read(authViewModelProvider.notifier)
                                          .loginUser(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );

                                      Dialogues.showSuccessDialog(
                                        context,
                                        'Login successful! Redirecting to Home page.',
                                        'Success',
                                        () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => const HomePage(),
                                            ),
                                          );
                                        },
                                      );
                                      print(
                                        '${result} KOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOMAAAAAAAAAAAAAAA',
                                      );
                                    } catch (e) {
                                      print("Err00or: $e");
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: Pallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
