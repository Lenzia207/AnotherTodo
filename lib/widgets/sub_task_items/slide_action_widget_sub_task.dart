import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/update_sub_task_bottom_sheet.dart';
import 'package:another_todo/widgets/sub_task_items/sub_todo_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_use/flutter_use.dart';

/// The [SlideActionWidgetSubTask] is part of the [SubTodoItemWidget] and features Sliding inside the Todo-Item
// TODO Add Snackbar and Undo function

class SlideActionWidgetSubTask extends HookWidget {
  SlideActionWidgetSubTask({
    Key? key,
    required this.task,
    required this.subTask,
  }) : super(key: key);

  /*  final CollectionReference mySubTasksDB =
      FirebaseFirestore.instance.collection('mySubTasks'); */

  final Task task;
  final SubTask subTask;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

// Deletes the tasks and shows a SnackBar
  Future<void> deleteSubTask(BuildContext context, String mySubTaskId) async {
    final mySubTasksDB = FirebaseFirestore.instance
        .collection('myTasks')
        .doc(task.id)
        .collection('mySubTasks');
    final subTaskRef = mySubTasksDB.doc(subTask.id);
    final subTaskSnapshot = await subTaskRef.get();

    if (subTaskSnapshot.exists) {
      await mySubTasksDB.doc(mySubTaskId).delete();
    } else {
      if (kDebugMode) {
        print("Sub Task does not exist and can't be deleted");
      }
    }

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
// Edit the tasks
    Future<void> editSubTask(BuildContext context, SubTask subTask) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return UpdateSubTaskBottomSheet(task: task, subTask: subTask);
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
              onPressed: ((context) => editSubTask(context, subTask)),
              icon: Icons.edit,
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              label: 'Edit',
            ),
            //DELETE Todo Item
            SlidableAction(
              onPressed: ((context) => deleteSubTask(context, subTask.id)),
              icon: Icons.delete,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              label: 'Delete',
            ),
          ],
        ),
        child: SubTodoItemWidget(
          subTask: subTask,
          task: task,
        ),
      ),
    );
  }
}
