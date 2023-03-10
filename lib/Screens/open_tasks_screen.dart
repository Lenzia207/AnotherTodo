import 'package:another_todo/provider/create_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/empty_data_widget.dart';
import 'package:another_todo/widgets/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

/// This is the general representation of the [OpenTasksScreen]
class OpenTasksScreen extends HookWidget {
  OpenTasksScreen({super.key});

  final myTasksDB = FirebaseFirestore.instance
      .collection('myTasks')
      .where("isDone", isEqualTo: false)
      .where('isPrivate', isEqualTo: false);
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> createTask(BuildContext context,
        [DocumentSnapshot? documentSnapshot]) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return CreateTaskBottomSheet();
        },
      );
    }

    return StreamBuilder(
      stream: myTasksDB.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          if (streamSnapshot.data!.docs.isEmpty) {
            // Show a message if there is no data in the stream
            return const EmptyDataWidget(
              infoText: 'You have no tasks open',
            );
          } else {
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
