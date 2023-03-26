import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/create_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/task_items/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is the general representation of the [OpenTasksScreen]
class OpenTasksScreen extends HookWidget {
  OpenTasksScreen({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksStream = useMemoized(() => FirebaseFirestore.instance
        .collection('myTasks')
        .where("isDone", isEqualTo: false)
        .where('isPrivate', isEqualTo: false)
        .snapshots());

    Future<void> createTask(BuildContext context, [Task? task]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateTaskBottomSheet();
        },
      );
    }

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
                .map((doc) => Task.fromSnapshot(doc))
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
                  SingleChildScrollView(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Container(
                        height: 5,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return SlideActionWidget(task: task);
                      },
                    ),
                  ),
                  ButtonAddWidget(
                    infoText: 'New Task',
                    function: (() => createTask(context)),
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
