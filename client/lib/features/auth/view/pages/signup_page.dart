import 'package:client/core/utils/dialogues.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../widgets/auth_gradient_button.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    bool? isLoading = ref.watch(authViewModelProvider)?.isLoading;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Dialogues.showSuccessDialog(
            context,
            'Signup successful! Redirecting to Signin page.',
            'Success',
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SigninPage()),
              );
            },
          );
        },
        error: (error, st) {
          Dialogues.showErrorDialog(
            context,
            error.toString(),
            'Signup Error',
            () {
              Navigator.pop(context);
            },
          );
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body:
          isLoading == true
              ? Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up.",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomField(
                          hintText: 'Name',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 15),
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
                        AuthGradientButton(
                          buttonText: 'Sign Up',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await ref
                                  .read(authViewModelProvider.notifier)
                                  .signupUser(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                              print(result);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SigninPage();
                                },
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: "Sign In",
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
    );
  }
}
