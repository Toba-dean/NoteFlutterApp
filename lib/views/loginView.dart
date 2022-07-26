// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/showErrorDialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Email Here'),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Password Here'),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                // try {
                //   final userCredential = await FirebaseAuth.instance
                //       .signInWithEmailAndPassword(
                //           email: email, password: password);

                //   final user = FirebaseAuth.instance.currentUser;
                //   if (user?.emailVerified ?? false) {
                //     Navigator.of(context).pushNamedAndRemoveUntil(
                //         notesRoute, (route) => false);
                //   } else {
                //     Navigator.of(context).pushNamedAndRemoveUntil(
                //         verifyEmailRoute, (route) => false);
                //   }
                // } on FirebaseAuthException catch (e) {
                //   if (e.code == 'user-not-found') {
                //     return showErrorDialog(context, 'User not found.');
                //   } else if (e.code == 'wrong-password') {
                //     return showErrorDialog(context, 'Incorrect password.');
                //   } else {
                //     return showErrorDialog(context, 'Error: {$e.code}');
                //   }
                // } catch (e) {
                //   showErrorDialog(context, e.toString());
                // }

                try {
                  await AuthServices.firbase().login(
                    email: email,
                    password: password,
                  );

                  final user = AuthServices.firbase().currentUser;

                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found.',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Incorrect password.',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication Error.',
                  );
                }
              },
              child: const Text("Log In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (_) => false,
                );
              },
              child: const Text("Don't have an account? Register Now."),
            ),
          ],
        ),
      ),
    );
  }
}
