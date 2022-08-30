import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "We've already sent a verification email, please open email to verify your account."
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Text(
                "If you haven't received a verification, please press the button to resend"
              ),
            ),
                
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Click to verify email'),
            ),

            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Restart'),
            )
          ],
        ),
      ),
    );
  }
}
