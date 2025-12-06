import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/components/my_button.dart';
import 'package:expense_tracker/utilis/components/text_form_field.dart';
import 'package:expense_tracker/utilis/utilis.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final auth = Provider.of<ViewModel>(context, listen: false);

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
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
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
                              mainAxisSize: MainAxisSize.min,
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
                          const SizedBox(height: 20),
                          Consumer<ViewModel>(
                            builder: (context, value, child) => MyButton(
                              child: value.isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  final result = await auth.login(
                                    _emailController.text,
                                    _passController.text,
                                  );
                                  if (result) {
                                    Utilis.showCompleteMessage(
                                      'Login Successful',
                                      Theme.of(context).primaryColor,
                                      Icons.check,
                                      context,
                                    ).then(
                                      (_) => Navigator.pushReplacementNamed(
                                        context,
                                        RouteNames.home,
                                      ),
                                    );
                                  } else {
                                    Utilis.showCompleteMessage(
                                      'Login Failed! Invalid email or password.',
                                      Colors.redAccent,
                                      Icons.error,
                                      context,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteNames.forgotPassword,
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
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
