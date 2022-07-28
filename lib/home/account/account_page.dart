import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/avatar.dart';

import '../../common_widgets/show_alert_dialog.dart';
import '../../services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      //print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Log out',
        content: 'Are you sure you want to logout ?',
        defaultActionText: 'logout',
        cancelActionText: 'cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
        ),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }

  _buildUserInfo(User? currentUser) {
    return Column(
      children: [
        Avatar(
          radius: 50,
          photoUrl: currentUser!.photoURL,
        ),
        const SizedBox(
          height: 8,
        ),
        if (currentUser.displayName != null)
          Text(
            currentUser.displayName!,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
