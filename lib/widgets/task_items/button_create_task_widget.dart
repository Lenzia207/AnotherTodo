import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/task_items/create_task_bottom_sheet.dart';
import 'package:flutter/material.dart';

/// This [ButtonCreateTaskWidget] is a button widgets that is placed at the bottom right and will create new [Task].
/// An info text to the button and function can be added
class ButtonCreateTaskWidget extends StatelessWidget {
  const ButtonCreateTaskWidget({
    Key? key,
    required this.infoText,
  }) : super(key: key);

  final String infoText;

  @override
  Widget build(BuildContext context) {
    Future<void> createTask(BuildContext context, [Task? task]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateTaskBottomSheet();
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: (() => createTask(context)),
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
