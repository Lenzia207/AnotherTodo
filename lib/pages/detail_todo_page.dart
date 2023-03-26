import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/create_sub_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/task_items/detail_header_todo_card.dart';
import 'package:another_todo/widgets/sub_task_items/slide_action_widget_sub_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
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

    final dataRange = useState(
      DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(
          const Duration(days: 7),
        ),
      ),
    );

    Future pickDateRanger(context) async {
      DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dataRange.value,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
      );

      dataRange.value = newDateRange ?? dataRange.value;
    }

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

    final start = formatDate(dataRange.value.start, [dd, '.', mm, ' ', yyyy]);
    final end = formatDate(dataRange.value.end, [dd, '.', mm, ' ', yyyy]);
    final duration = dataRange.value.duration;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: StreamBuilder<List<SubTask>>(
        stream: subTaskStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final subTasks = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 20, left: 10, right: 10),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 20,
                                left: 30,
                                right: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start: $start",
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.blue),
                                  ),
                                  Text(
                                    "Deadline is: $end",
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.blue),
                                  ),
                                  Text("Duration: ${duration.inDays} Day(s)"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            pickDateRanger(context),
                                        icon: const Icon(Icons.date_range),
                                        label: const Text("Set Date"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Sub - Tasks'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                    ),
                  ),
                  ButtonAddWidget(
                    infoText: 'New Sub Task',
                    function: (() => createSubTask(context)),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
