import 'package:another_todo/model/sub_task.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/sub_task_items/create_sub_task_bottom_sheet.dart';
import 'package:flutter/material.dart';

/// This [ButtonCreateSubTaskWidget] is a button widgets that is placed at the bottom right and will create new [SubTask].
/// An info text to the button and function can be added.
class ButtonCreateSubTaskWidget extends StatelessWidget {
  const ButtonCreateSubTaskWidget({
    Key? key,
    required this.infoText,
    required this.task,
  }) : super(key: key);

  final String infoText;
  final Task task;

  @override
  Widget build(BuildContext context) {
    Future<void> createSubTask(BuildContext context, [SubTask? subTask]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateSubTaskBottomSheet(
            task: task,
            subTask: subTask,
          );
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
              onPressed: (() => createSubTask(context)),
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
