import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'todo_item_widget.dart';

/// The [SlideActionWidget] is part of the [TodoItemWidget] and features Sliding inside the Todo-Item
// TODO Add Snackbar and Undo function

class SlideActionWidget extends HookWidget {
  SlideActionWidget({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('myTasks');

  final DocumentSnapshot documentSnapshot;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

// Edit the tasks
  Future<void> editTask(
      BuildContext context, DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      titleController.text = documentSnapshot['title'];
      descriptionController.text = documentSnapshot['description'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
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

                    await myTasksDB
                        .doc(documentSnapshot!.id)
                        .update({"title": title, "description": description});
                    titleController.text = '';
                    descriptionController.text = '';
                    navigatorPop;
                  },
                )
              ],
            ),
          );
        });
  }

// Deletes the tasks and shows a SnackBar
  Future<void> deleteTask(BuildContext context, String myTaskId) async {
    await myTasksDB.doc(myTaskId).delete();
    /*  final message = ScaffoldMessenger.of(context);

    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: const Text("Deleting Task..."),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );
    message.showSnackBar(snackBar); */
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Slidable(
        endActionPane: ActionPane(
          dragDismissible: false,
          motion: const DrawerMotion(),
          children: [
            //EDIT Todo Item
            SlidableAction(
              onPressed: ((context) => editTask(context, documentSnapshot)),
              icon: Icons.edit,
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              label: 'Edit',
            ),
            //DELETE Todo Item
            SlidableAction(
              onPressed: ((context) =>
                  deleteTask(context, documentSnapshot.id)),
              icon: Icons.delete,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Delete',
            ),
          ],
        ),
        child: TodoItemWidget(
          documentSnapshot: documentSnapshot,
        ),
      ),
    );
  }
}
