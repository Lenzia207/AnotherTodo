import 'package:another_todo/provider/create_sub_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/task_item/detail_header_todo_card.dart';
import 'package:another_todo/widgets/task_item/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailTodoPage extends HookConsumerWidget {
  DetailTodoPage({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('mySubTasks');
  final DocumentSnapshot documentSnapshot;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

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

    final start = formatDate(dataRange.value.start, [dd, '.', mm, ' ', yyyy]);
    final end = formatDate(dataRange.value.end, [dd, '.', mm, ' ', yyyy]);
    final duration = dataRange.value.duration;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DetailHeaderTodoCard(
                    documentSnapshot: documentSnapshot,
                  ),
                  Text(
                    "Start: $start",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text(
                    "Deadline is: $end",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text("Duration: ${duration.inDays} Day(s)"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => pickDateRanger(context),
                        icon: const Icon(Icons.date_range),
                        label: const Text("Set Date"),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      SingleChildScrollView(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              Container(height: 5),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            return SlideActionWidget(
                                documentSnapshot: documentSnapshot);
                          },
                        ),
                      ),
                      ButtonAddWidget(
                        infoText: 'New Sub Task',
                        function: (() => createTask(context)),
                      ),
                    ],
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

    /*   Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailHeaderTodoCard(
                    documentSnapshot: documentSnapshot,
                  ),
                  Text(
                    "Start: $start",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text(
                    "Deadline is: $end",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text("Time left: ${duration.inDays} Day's"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => pickDateRanger(context),
                        icon: const Icon(Icons.date_range),
                        label: const Text("Set Date"),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 50,
                    thickness: 1.5,
                  ),
                  
                ],
              ),
            ),
            ButtonAddWidget(
              infoText: ' Add Sub Task',
              function: () {},
            ),
          ],
        ),
      ),
    ); */
  }
}
