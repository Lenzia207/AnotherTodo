import 'package:another_todo/Screens/navigation_screen.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/create_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/task_items/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

/// This is the general representation of the [PrivateTasksScreen]
// TODO When item is completed (isDone = true) move it down at the end of the list
class PrivateTasksScreen extends HookWidget {
  PrivateTasksScreen({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksStream = useMemoized(() => FirebaseFirestore.instance
        .collection('myTasks')
        .where("isPrivate", isEqualTo: true)
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return MainNavigationScreen();
              },
            ),
          ),
        ),
        title: const Text('Private Tasks'),
      ),
      body: StreamBuilder(
        stream: tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              // Show a message if there is no data in the stream
              return const EmptyDataWidget(
                infoText: 'Empty',
              );
            } else {
              final tasks = snapshot.data!.docs
                  .map((doc) => Task.fromSnapshot(doc))
                  .toList();
              return Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 20, left: 10, right: 10),
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    SingleChildScrollView(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            Container(height: 5),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final Task task = tasks[index];

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
      ),
    );
  }
}
