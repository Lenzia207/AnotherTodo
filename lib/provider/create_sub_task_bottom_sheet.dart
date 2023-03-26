import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateSubTaskBottomSheet extends HookWidget {
  CreateSubTaskBottomSheet({
    Key? key,
    required this.task,
    this.subTask,
  }) : super(key: key);

  final Task task;
  final SubTask? subTask;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDone = useState(false);

    return Padding(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title...'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description...',
            ),
          ),
          ElevatedButton(
            child: const Text('Create sub task'),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final String title = titleController.text;
              final String description = descriptionController.text;
              final isDoneBool = isDone.value;

              final mySubTasksDB = FirebaseFirestore.instance
                  .collection('myTasks')
                  .doc(task.id)
                  .collection('mySubTasks');

              await mySubTasksDB.add({
                "title": title,
                "description": description,
                "isDone": isDoneBool,
              });
              titleController.text = '';
              descriptionController.text = '';
              navigatorPop;
            },
          )
        ],
      ),
    );
  }
}
