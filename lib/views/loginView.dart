import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
      body: FutureBuilder(
        future:  Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Email Here'
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Password Here'
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try{
                            final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: email,
                                password: password
                            );
                            print('Nigga just logged in.');
                          } on FirebaseAuthException catch(e) {
                            if(e.code == 'user-not-found') {
                              print('No user with that email address.');
                            }else if(e.code == 'wrong-password') {
                              print('Incorrect password.');
                            }
                          }

                        },
                        child: const Text("Log In")
                    ),
                  ],
                ),
              );
            default:
              return const Text(
                'Loading...',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                ),
              );
          }
        },
      ),
    );
  }
}
