import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// This updates the edited task.
class UpdatePasscodeBottomSheet extends HookWidget {
  const UpdatePasscodeBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passcodeController = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: passcodeController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(
                  r'[0-9]',
                ),
              ),
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            decoration: const InputDecoration(
              labelText: 'New Passcode',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text(
              'Save',
            ),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final newPasscodeDigitsInput = passcodeController.text;

              //Split the input into a List
              final List<String> newPasscodeDigitsList =
                  newPasscodeDigitsInput.split("");

              // Map and convert the list of Strings into List of int to make it valid for change
              final List<int> newPasscodeDigits = newPasscodeDigitsList
                  .map(
                    (digits) => int.parse(digits),
                  )
                  .toList();

              // Save it in Firestore
              final passcodeDocRef = FirebaseFirestore.instance
                  .collection('passcode')
                  .doc('passcode');
              await passcodeDocRef.set(
                {
                  'passcode': newPasscodeDigits,
                },
              );

              navigatorPop;
            },
          )
        ],
      ),
    );
  }
}
