import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateTaskBottomSheet extends HookWidget {
  CreateTaskBottomSheet({
    Key? key,
    this.task,
  }) : super(key: key);

  final Task? task;
  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('myTasks');
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDone = useState(false);
    final isPrivate = useState(task?.isPrivate ?? false);

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
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title...',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description...',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CheckboxListTile(
            activeColor: Theme.of(context).primaryColor,
            title: const Text(
              'Private Task',
            ),
            checkColor: Colors.white,
            value: isPrivate.value,
            onChanged: (value) {
              isPrivate.value = !isPrivate.value;
            },
          ),
          ElevatedButton(
            child: const Text(
              'Create new task',
            ),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final String title = titleController.text;
              final String description = descriptionController.text;
              final isDoneBool = isDone.value;
              final isPrivateBool = isPrivate.value;

              await myTasksDB.add({
                "title": title,
                "description": description,
                "isDone": isDoneBool,
                "isPrivate": isPrivateBool,
                "start": FieldValue.serverTimestamp(),
                "end": FieldValue.serverTimestamp(),
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
