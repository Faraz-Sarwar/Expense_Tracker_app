import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/components/my_button.dart';
import 'package:expense_tracker/utilis/components/text_form_field.dart';
import 'package:expense_tracker/utilis/utilis.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lets help you manage your expense',
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
                              borderRadius: BorderRadius.circular(6),
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomeFormField(
                                  hintText: 'Enter Username',
                                  controller: _usernameController,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter username';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                const Divider(color: Colors.black12),
                                CustomeFormField(
                                  hintText: 'Enter your Email',
                                  controller: _emailController,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email cannot be empty';
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
                                      return "Password field cannot be empty";
                                    } else if (value.length < 6) {
                                      return 'Password length must be more than 6';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Consumer<ViewModel>(
                            builder: (context, value, child) => MyButton(
                              child: value.isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  final result = await auth.signUp(
                                    _emailController.text,
                                    _passController.text,
                                    _usernameController.text,
                                  );
                                  if (result) {
                                    Utilis.showCompleteMessage(
                                      'Sign Up Successful',
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
                                      'An error occured while Singing Up',
                                      Colors.red,
                                      Icons.error,
                                      context,
                                    );
                                  }
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'already have an account? ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),

                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.login,
                                ),
                                child: Text(
                                  'Login ',
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
