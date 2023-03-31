import 'package:another_todo/screens/private_tasks_screen.dart';
import 'package:another_todo/widgets/update_passcode_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';

/// The [PassCodePrivatePage] page represents the authentication layer before entering the [PrivateTasksScreen].
/// It's also possible to change the 4 digit passcode
class PassCodePrivatePage extends StatelessWidget {
  const PassCodePrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Change the passcode
    Future<void> changePasscode(BuildContext context) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return const UpdatePasscodeBottomSheet();
          });
    }

    final passcodeStream = FirebaseFirestore.instance
        .collection('passcode')
        .doc('passcode')
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: passcodeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final passcodeData = snapshot.data!.data() as Map<String, dynamic>;
          final storedPasscode = passcodeData['passcode'] as List;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => changePasscode(context),
                          icon: const Icon(
                            Icons.edit,
                          ),
                          label: const Text(
                            "Change Code",
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
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
                ),
              ],
            ),
          );
        } else {
          return Container(); // default widget to show when there is no data
        }
      },
    );
  }
}
