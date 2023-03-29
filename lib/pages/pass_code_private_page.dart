import 'package:another_todo/screens/private_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';

/// The [PassCodePrivatePage] page represents the authentication layer before entering the [PrivateTasksScreen]
class PassCodePrivatePage extends StatelessWidget {
  const PassCodePrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    const List storedPasscode = [1, 1, 1, 1];
    return SizedBox(
      child: LockScreen(
        title: 'Enter Code',
        bgImage: 'lib/images/pass_code_bg.jpg',
        passLength: storedPasscode.length,
        borderColor: Colors.white,
        showWrongPassDialog: true,
        wrongPassContent: "Wrong pass please try again.",
        wrongPassTitle: "Opps!",
        wrongPassCancelButtonText: "Cancel",
        passCodeVerify: (List<int> passcode) async {
          for (int i = 0; i < storedPasscode.length; i++) {
            if (passcode[i] != storedPasscode[i]) {
              return false;
            }
          }
          return true;
        },
        onSuccess: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return PrivateTasksScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
