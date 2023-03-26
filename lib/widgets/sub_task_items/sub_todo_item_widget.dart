import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// The [SubTodoItemWidget] represents an Item of Tasks that contains a title, description and checkbox
class SubTodoItemWidget extends HookWidget {
  const SubTodoItemWidget({
    Key? key,
    required this.task,
    required this.subTask,
  }) : super(key: key);

  final Task task;
  final SubTask subTask;
  @override
  Widget build(BuildContext context) {
    // updates the value isDone
    void updateIsDone(String id, bool isDone) async {
      final mySubTasksDB = FirebaseFirestore.instance
          .collection('myTasks')
          .doc(task.id)
          .collection('mySubTasks');
      final subTaskRef = mySubTasksDB.doc(subTask.id);
      final subTaskSnapshot = await subTaskRef.get();
      if (subTaskSnapshot.exists) {
        await subTaskRef.update({
          'isDone': isDone,
        });
      } else {
        if (kDebugMode) {
          print('Sub Task does not exist');
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    subTask.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 22,
                    ),
                  ),

                  // If there is a DESCRIPTION
                  if (subTask.description != null)
                    Text(
                      subTask.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
            Checkbox(
              activeColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
              value: subTask.isDone,
              onChanged: (value) {
                final bool newValue = !subTask.isDone;
                updateIsDone(subTask.id, newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
