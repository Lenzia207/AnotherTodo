import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/stream_task_list.dart';

import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/task_items/button_create_task_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is the general representation of the [OpenTasksScreen]
class CompletedTasksScreen extends HookWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksStream = FirebaseFirestore.instance
        .collection('myTasks')
        .where("isDone", isEqualTo: true)
        .where('isPrivate', isEqualTo: false)
        .snapshots();

    return StreamBuilder(
      stream: tasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            // Show message if there is no data in the stream
            return const EmptyDataWidget(
              infoText: 'Empty',
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
                  // List of all completed tasks
                  StreamTaskList(
                    tasks: tasks,
                  ),

                  // Button widget to create a new task
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
