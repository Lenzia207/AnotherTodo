import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

// TODO fix isPrivate issue

class UpdateSubTaskBottomSheet extends HookWidget {
  UpdateSubTaskBottomSheet({
    Key? key,
    this.subTask,
  }) : super(key: key);

  final SubTask? subTask;
  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('mySubTasks');
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

              await myTasksDB.doc(subTask!.id).update({
                "title": title,
                "description": description,
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
