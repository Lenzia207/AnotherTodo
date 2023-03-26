import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UpdateSubTaskBottomSheet extends HookWidget {
  UpdateSubTaskBottomSheet({
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
    if (subTask != null) {
      titleController.text = subTask!.title;
      descriptionController.text = subTask!.description;
    }
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
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final String title = titleController.text;
              final String description = descriptionController.text;

              final mySubTasksDB = FirebaseFirestore.instance
                  .collection('myTasks')
                  .doc(task.id)
                  .collection('mySubTasks');
              final subTaskRef = mySubTasksDB.doc(subTask!.id);
              final subTaskSnapshot = await subTaskRef.get();

              if (subTaskSnapshot.exists) {
                await mySubTasksDB.doc(subTask!.id).update({
                  "title": title,
                  "description": description,
                });
                titleController.text = '';
                descriptionController.text = '';
                navigatorPop;
              } else {
                if (kDebugMode) {
                  print("Sub Task doesn't exist and can't be updated");
                }
              }
            },
          )
        ],
      ),
    );
  }
}
