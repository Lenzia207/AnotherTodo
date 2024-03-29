import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This represents information of the main task as a card.
class DetailHeaderTodoCard extends HookWidget {
  const DetailHeaderTodoCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;
  @override
  Widget build(BuildContext context) {
    // updates the value isPrivate
    void updateIsPrivate(String id, bool isPrivate) async {
      final nav = Navigator.pop(context);
      final myTasksDB = FirebaseFirestore.instance.collection(
        'myTasks',
      );
      await myTasksDB.doc(id).update({
        'isPrivate': isPrivate,
      });

      nav;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (task.description != null)
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Private:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Colors.white,
                    value: task.isPrivate,
                    onChanged: (value) {
                      final bool newValue = !task.isPrivate;
                      updateIsPrivate(task.id, newValue);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
