import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

class CreateSubTaskBottomSheet extends HookWidget {
  CreateSubTaskBottomSheet({super.key});

  final CollectionReference myTasksDB = FirebaseFirestore.instance
      .collection('myTasks')
      .doc()
      .collection('mySubTasks');
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDone = useState(false);
    //final isPrivate = useToggle(false);

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
          /*  StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CheckboxListTile(
                activeColor: Theme.of(context).primaryColor,
                title: const Text("Private Task"),
                checkColor: Colors.white,
                value: isPrivate.value,
                onChanged: (value) {
                  setState(
                    () => isPrivate.toggle(),
                  );
                },
              );
            },
          ), */
          ElevatedButton(
            child: const Text('Create sub task'),
            onPressed: () async {
              final navigatorPop = Navigator.of(context).pop();
              final String title = titleController.text;
              final String description = descriptionController.text;
              final isDoneBool = isDone.value;
              //final isPrivateBool = isPrivate.value;

              await myTasksDB.add({
                "title": title,
                "description": description,
                "isDone": isDoneBool,
                //"isPrivate": isPrivateBool,
              });
              titleController.text = '';
              descriptionController.text = '';
              navigatorPop;
            },
          )
        ],
      ),
    );
  }
}
