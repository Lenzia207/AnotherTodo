import 'package:another_todo/provider/edit_task_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_use/flutter_use.dart';

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
    //final isPrivate = useToggle(false);

// Edit the tasks
    Future<void> editTask(
        BuildContext context, DocumentSnapshot? documentSnapshot) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return UpdateTaskBottomSheet(documentSnapshot: documentSnapshot);
          });
    }

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
