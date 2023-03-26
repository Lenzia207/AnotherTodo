import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/create_sub_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/empty_sub_tasks_widget.dart';
import 'package:another_todo/widgets/set_date_task.dart';
import 'package:another_todo/widgets/task_items/detail_header_todo_card.dart';
import 'package:another_todo/widgets/sub_task_items/slide_action_widget_sub_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailTodoPage extends HookWidget {
  DetailTodoPage({
    Key? key,
    required this.task,
    this.subTask,
  }) : super(key: key);

  final Task task;
  final SubTask? subTask;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Stream<List<SubTask>> useSubTaskStream(Task myTask) {
      return useMemoized(() {
        return FirebaseFirestore.instance
            .collection('myTasks')
            .doc(myTask.id)
            .collection('mySubTasks')
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs
                .map((doc) => SubTask.fromSnapshot(doc))
                .toList());
      }, [myTask.id]);
    }

    final subTaskStream = useSubTaskStream(task);

    Future<void> createSubTask(BuildContext context, [SubTask? subTask]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateSubTaskBottomSheet(
            task: task,
            subTask: subTask,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailHeaderTodoCard(
                        task: task,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Set a date and deadline for main task
                      const SetDateTask(),
                    ],
                  ),
                  // If sub-collection is created --> show the sub task area
                  StreamBuilder<List<SubTask>>(
                    stream: subTaskStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const EmptySubTasksWidget();
                        } else {
                          final subTasks = snapshot.data!;

                          return Column(
                            children: [
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'Sub - Tasks'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    Container(height: 5),
                                itemCount: subTasks.length,
                                itemBuilder: (context, index) {
                                  final subTask = subTasks[index];
                                  return SlideActionWidgetSubTask(
                                      task: task, subTask: subTask);
                                },
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
            ButtonAddWidget(
              infoText: 'New Sub Task',
              function: (() => createSubTask(context)),
            ),
          ],
        ),
      ),
    );
  }
}
