import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
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
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: email, 
                        password: password
                      );

                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();

                  // This pushNamed makes it possible to go back from a particular page
                  Navigator.of(context).pushNamed(verifyEmailRoute);

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showErrorDialog(
                      context, 
                      'Weak password, Enter a more secure one.'
                    );
                  } else if (e.code == 'email-already-in-use') {
                    showErrorDialog(
                      context, 
                      'Email already exists.'
                    );
                  } else if (e.code == 'invalid-email') {
                    showErrorDialog(
                      context, 
                      'Invalid email entered'
                    );
                  } else {
                    return await showErrorDialog(
                      context, 
                      'Error: {$e.code}'
                    );
                  }
                } catch (e) {
                  showErrorDialog(context, e.toString());
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                // pushedNamedAndRemoveUntil makes it so that u cannot use the back button to go back to prev route.

                Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already have an account?, login."),
            ),
          ],
        ),
      ),
    );
  }
}
