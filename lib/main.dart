import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:mynotes/firebase_options.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/loginView.dart';
import 'package:mynotes/views/notes/new_note_view.dart';
import 'package:mynotes/views/notes/notesView.dart';
import 'package:mynotes/views/registerVew.dart';
import 'package:mynotes/views/verifyEmailView.dart';

void main() {
  // This ensures initialization before building widgets.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}

// This does the app initialization, then checks if there is a user so it can render the appropriate view.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this future builder widget makes flutter waits until firebase is initialized before builder the UI
    return FutureBuilder(
      // Initial
      // future: Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform
      // ),

      // After refactor
      future: AuthServices.firbase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // Initial
            // final user = FirebaseAuth.instance.currentUser;

            // After refactor
            final user = AuthServices.firbase().currentUser;
            if (user != null) {
              // Initial
              // if (user.emailVerified) {
              //   return const NotesView();
              // } else {
              //   return const VerifyEmailView();
              // }

              // After refactor
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
