import 'package:flutter/material.dart';

/// This [ButtonAddWidget] is a button widgets that is placed at the bottom right.
/// An info text to the button and function can be added
class ButtonAddWidget extends StatelessWidget {
  const ButtonAddWidget(
      {Key? key, required this.infoText, required this.function})
      : super(key: key);

  final String infoText;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: function,
              backgroundColor: Colors.green,
              label: Text(infoText),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
