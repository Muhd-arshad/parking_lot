import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinglot/controller/auth_controller.dart';
import 'package:parkinglot/view/home_view.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authProvider.isLogin ? 'Login' : 'Sign up',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Form(
          key: authProvider.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: authProvider.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authProvider.password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded borders
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                authProvider.isLogin
                    ? const SizedBox()
                    : TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          } else if (value != authProvider.password.text) {
                            return 'Enter same password';
                          }
                          return null;
                        },
                      ),
                TextButton(
                  child: Text(authProvider.isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                  onPressed: () {
                    authProvider.changeScreen();
                    authProvider.clearValueinController();
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 03,
                  height: 60,
                  child: ElevatedButton(
                    child: authProvider.loading
                        ? const CupertinoActivityIndicator(color: Colors.black)
                        : Text(authProvider.isLogin ? 'Login' : 'Sign Up'),
                    onPressed: () async {
                      if (authProvider.formKey.currentState!.validate()) {
                        if (authProvider.isLogin) {
                          bool result = await authProvider.login(context);
                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeViewScreen(),
                              ),
                              (route) => false,
                            );
                            authProvider.clearValueinController();
                          }
                        } else {
                          bool result = await authProvider.userSigup(context);
                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeViewScreen(),
                              ),
                              (route) => false,
                            );
                            authProvider.clearValueinController();
                            authProvider.changeScreen();
                          }
                        }
                      }
                    },
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
