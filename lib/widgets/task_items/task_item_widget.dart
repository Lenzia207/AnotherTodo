import 'package:another_todo/pages/detail_todo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:another_todo/model/sub_task.dart';
import 'package:another_todo/model/task.dart';

/// The [TaskItemWidget] represents an Item of Tasks that contains a title, description and checkbox
class TaskItemWidget extends HookWidget {
  const TaskItemWidget({
    Key? key,
    required this.task,
    this.subTask,
  }) : super(key: key);

  final Task task;
  final SubTask? subTask;

  @override
  Widget build(BuildContext context) {
    // updates the value isDone
    void updateIsDone(String id, bool isDone) async {
      final myTasksDB = FirebaseFirestore.instance.collection('myTasks');
      await myTasksDB.doc(id).update({
        'isDone': isDone,
      });
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTodoPage(
              task: task,
              subTask: subTask,
            ),
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey,
                  width: 5,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Card(
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TITLE
                          Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                            ),
                          ),

                          //If there is a DESCRIPTION
                          if (task.description != null)
                            Text(
                              task.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      value: task.isDone,
                      onChanged: (value) {
                        final bool newValue = !task.isDone;
                        updateIsDone(task.id, newValue);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
