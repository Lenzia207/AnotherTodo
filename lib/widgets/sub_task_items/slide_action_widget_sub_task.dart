import 'package:another_todo/model/sub_task.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/sub_task_items/sub_todo_item_widget.dart';
import 'package:another_todo/widgets/sub_task_items/update_sub_task_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// The [SlideActionWidgetSubTask] is part of the [SubTodoItemWidget] and features Sliding inside the Todo-Item
class SlideActionWidgetSubTask extends HookWidget {
  const SlideActionWidgetSubTask({
    Key? valueKey,
    required this.task,
    required this.subTask,
  }) : super(key: valueKey);

  final Task task;
  final SubTask subTask;

// Deletes the tasks and shows a SnackBar
  Future<void> deleteSubTask(BuildContext context, String mySubTaskId) async {
    final myTasksDB = FirebaseFirestore.instance.collection(
      'myTasks',
    );
    final message = ScaffoldMessenger.of(context);
    final CollectionReference mySubTasksDB = myTasksDB
        .doc(
          task.id,
        )
        .collection(
          'mySubTasks',
        );

    // Store the sub task locally before deleting it from Firestore
    final DocumentSnapshot<Object?> subTaskSnapshot =
        await mySubTasksDB.doc(mySubTaskId).get();
    final Object? subTaskData = subTaskSnapshot.data();

    // Final delete
    await mySubTasksDB.doc(mySubTaskId).delete();

    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      content: const Text(
        'Deleting Sub Task...',
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          if (subTaskData != null) {
            await mySubTasksDB
                .doc(
                  mySubTaskId,
                )
                .set(
                  subTaskData,
                );
          }

          // Show a new snackbar to inform the user that the task has been restored
          message.showSnackBar(
            const SnackBar(
              duration: Duration(
                seconds: 2,
              ),
              content: Text(
                'Sub Task Restored',
              ),
            ),
          );
        },
      ),
    );
    message.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
// Edit the tasks
    Future<void> editSubTask(BuildContext context, SubTask subTask) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return UpdateSubTaskBottomSheet(
            task: task,
            subTask: subTask,
          );
        },
      );
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
              onPressed: ((context) => editSubTask(
                    context,
                    subTask,
                  )),
              icon: Icons.edit,
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              label: 'Edit',
            ),
            //DELETE Todo Item
            SlidableAction(
              onPressed: ((context) => deleteSubTask(
                    context,
                    subTask.id,
                  )),
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
