import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/slide_action_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This is the general representation of the [OpenTasksScreen]
// TODO Clean up the file

class OpenTasksScreen extends HookWidget {
  OpenTasksScreen({super.key});

  final CollectionReference myTasksDB =
      FirebaseFirestore.instance.collection('myTasks');
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
/*   final isDone = useState(false); */

  Future<void> createTask(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title...'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description...',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create new task'),
                  onPressed: () async {
                    final navigatorPop = Navigator.of(context).pop();
                    final String title = titleController.text;
                    final String description = descriptionController.text;
                    final bool = await myTasksDB.add({
                      "title": title,
                      "description": description,
                      // "isDone": isDone,
                    });
                    titleController.text = '';
                    descriptionController.text = '';
                    navigatorPop;
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: myTasksDB.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
            child: Stack(alignment: AlignmentDirectional.topStart, children: [
              SingleChildScrollView(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Container(height: 5),
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
            ]),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
