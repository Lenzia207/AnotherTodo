import 'dart:developer';

import 'package:another_todo/main.dart';
import 'package:another_todo/model/subTask.dart';
import 'package:another_todo/model/task.dart';
import 'package:another_todo/provider/create_sub_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/task_item/detail_header_todo_card.dart';
import 'package:another_todo/widgets/task_item/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

CollectionReference myTasksDB =
    FirebaseFirestore.instance.collection('myTasks');
void loadSubTask(
    Task myTasks, ValueChanged<List<SubTask>> onSubTasksLoaded) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> subTaskQuery =
        // referring to our Firebase Document "MyTasks"
        // And then refer to the documents collection through id and get all sub-collections
        await myTasksDB.doc(myTasks.id).collection('mySubTasks').get();

    final subTasks = subTaskQuery.docs
        .map((subTask) => SubTask.fromSnapshot(subTask))
        .toList();

    inspect("Sub Tasks here ${subTasks[0]}");
  } catch (e) {}
}

Widget buildSubTasksList(List<SubTask> subTasks) {
  return ListView.builder(
    itemCount: subTasks.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(subTasks[index].title),
        subtitle: Text(subTasks[index].description),
        trailing: Checkbox(
          value: subTasks[index].isDone,
          onChanged: (value) {
            // Handle checkbox state change here
          },
        ),
      );
    },
  );
}

class DetailTodoPage extends HookConsumerWidget {
  DetailTodoPage({
    Key? key,
    /*    required this.documentSnapshot, */ required this.myTasks,
  }) : super(key: key);

  /*  CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('myTasks'); */

/*   final DocumentSnapshot documentSnapshot; */
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final Task myTasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    Future<void> createTask(BuildContext context,
        [DocumentSnapshot? documentSnapshot]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateSubTaskBottomSheet();
        },
      );
    }

    /* void loadSubTask(Task myTasks) async {
      try {
        final QuerySnapshot<Map<String, dynamic>> subTaskQuery =
            // referring to our Firebase Document "MyTasks"
            // And then refer to the documents collection through id and get all sub-collections
            await myTasksDB.doc(myTasks.id).collection('mySubTasks').get();

        final subTasks = subTaskQuery.docs
            .map((subTask) => SubTask.fromSnapshot(subTask))
            .toList();

        inspect("Sub Tasks here ${subTasks[0]}");
      } catch (e) {}
    } */

    final start = formatDate(dataRange.value.start, [dd, '.', mm, ' ', yyyy]);
    final end = formatDate(dataRange.value.end, [dd, '.', mm, ' ', yyyy]);
    final duration = dataRange.value.duration;

    final subTasks = useState<List<SubTask>>([]);

    useEffect(() {
      loadSubTask(myTasks, (loadedSubTasks) {
        subTasks.value = loadedSubTasks;
      });
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: StreamBuilder(
        stream: myTasksDB.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
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
                            /* DetailHeaderTodoCard(
                              documentSnapshot: documentSnapshot,
                            ), */
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Sub - Tasks'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        buildSubTasksList(subTasks.value),

                        /*  ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              Container(height: 5),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return SlideActionWidget(
                                documentSnapshot: documentSnapshot);
                          },
                        ), */
                      ],
                    ),
                  ),
                  ButtonAddWidget(
                    infoText: 'New Sub Task',
                    function: (() => createTask(context)),
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
