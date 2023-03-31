import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/stream_task_list.dart';
import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/task_items/button_create_task_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is the general representation of the [OpenTasksScreen]
class OpenTasksScreen extends HookWidget {
  const OpenTasksScreen({
    super.key,
    this.task,
  });

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final tasksStream = FirebaseFirestore.instance
        .collection('myTasks')
        .where("isDone", isEqualTo: false)
        .where('isPrivate', isEqualTo: false)
        .snapshots();

    return StreamBuilder(
      stream: tasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            // Show a message if there is no data in the stream
            return const EmptyDataWidget(
              infoText: 'You have no tasks open',
            );
          } else {
            final tasks = snapshot.data!.docs
                .map(
                  (doc) => Task.fromSnapshot(doc),
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  StreamTaskList(
                    tasks: tasks,
                  ),
                  const ButtonCreateTaskWidget(
                    infoText: 'New Task',
                  ),
                ],
              ),
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
