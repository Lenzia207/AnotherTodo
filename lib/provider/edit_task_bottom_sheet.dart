import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

// TODO fix isPrivate issue

class UpdateTaskBottomSheet extends HookWidget {
  UpdateTaskBottomSheet({
    Key? key,
    // this.documentSnapshot,
    this.task,
  }) : super(key: key);
  //final DocumentSnapshot? documentSnapshot;
  final Task? task;
  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('myTasks');
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPrivate = useToggle(false);

    if (task != null) {
      titleController.text = task!.title;
      descriptionController.text = task!.description;
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
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CheckboxListTile(
                activeColor: Theme.of(context).primaryColor,
                title: const Text("Private Task"),
                checkColor: Colors.white,
                value: isPrivate.value,
                onChanged: (value) {
                  setState(
                    () => isPrivate.toggle(),
                  );
                },
              );
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final String title = titleController.text;
              final String description = descriptionController.text;
              final isPrivateBool = isPrivate.value;

              await myTasksDB.doc(task!.id).update({
                "title": title,
                "description": description,
                "isPrivate": isPrivateBool,
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
