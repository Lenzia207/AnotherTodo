import 'package:another_todo/screens/navigation_screen.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/task_items/button_create_task_widget.dart';
import 'package:another_todo/widgets/task_items/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is the general representation of the [PrivateTasksScreen]
class PrivateTasksScreen extends HookWidget {
  PrivateTasksScreen({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksStream = FirebaseFirestore.instance
        .collection('myTasks')
        .where("isPrivate", isEqualTo: true)
        .snapshots();

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
        title: const Text(
          'Private Tasks',
        ),
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
              // Sort private tasks based on isDone
              // if isDone: true --> go down
              tasks.sort((a, b) => a.isDone == b.isDone
                  ? 0
                  : a.isDone
                      ? 1
                      : -1);
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
                      child: Column(
                        children: [
                          ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Container(
                              height: 5,
                            ),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final Task task = tasks[index];

                              return SlideActionWidget(
                                task: task,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
