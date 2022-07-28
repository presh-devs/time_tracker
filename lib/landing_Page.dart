import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/home/home_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

import 'package:time_tracker/sign_in/sign_inPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              return Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  child: const HomePage());
            } else {
              return SignInPage.create(context);
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
