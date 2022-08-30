import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/showErrorDialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

// Setting the state of the textfield.
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

// disposing it after use.
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
        title: const Text("Register"),
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
                // get the values in the email and password textfield.
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthServices.firbase().createUser(
                    email: email,
                    password: password,
                  );

                  final user = AuthServices.firbase().currentUser;
                  await AuthServices.firbase().sendEmailVerification();

                  // This pushNamed makes it possible to go back from a particular page
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Weak password, Enter a more secure one.',
                  );
                } on EmailInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Email already exists.',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'Invalid email entered',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication Error.',
                  );
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                // pushedNamedAndRemoveUntil makes it so that u cannot use the back button to go back to prev route.

                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already have an account?, login."),
            ),
          ],
        ),
      ),
    );
  }
}
