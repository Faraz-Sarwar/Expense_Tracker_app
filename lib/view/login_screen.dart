import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/components/my_button.dart';
import 'package:expense_tracker/utilis/components/text_form_field.dart';
import 'package:expense_tracker/utilis/utilis.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 70,
                  horizontal: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 244, 244),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 72,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    0.25,
                                  ), // very soft grey-black
                                  spreadRadius: 0,
                                  blurRadius: 12,
                                  offset: const Offset(
                                    0,
                                    -2,
                                  ), // small upward lift
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CustomeFormField(
                                  hintText: 'Enter your Email',
                                  controller: _emailController,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter email to login';
                                    } else if (!value.contains('@') ||
                                        !value.contains('.com')) {
                                      return "Enter a valid email";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const Divider(color: Colors.black12),
                                CustomeFormField(
                                  hintText: 'Enter your password',
                                  controller: _passController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter the password';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          MyButton(
                            title: 'Login',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                AuthViewModel auth = AuthViewModel();
                                await auth
                                    .login(
                                      _emailController.text,
                                      _passController.text,
                                    )
                                    .then((value) {
                                      Utilis.showCompleteMessage(
                                        'Login Successfull',
                                        Theme.of(context).primaryColor,
                                        Icons.check,
                                        context,
                                      );
                                      return Future.delayed(
                                        const Duration(seconds: 2),
                                        () => Navigator.pushNamed(
                                          context,
                                          RouteNames.home,
                                        ),
                                      );
                                    });
                              }
                            },
                          ),

                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dont have an account? ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.signUp,
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
