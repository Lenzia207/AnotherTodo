import 'package:another_todo/model/subTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  bool isDone;
  bool isPrivate;
  List<SubTask>? subTasks;
  Timestamp start;
  Timestamp end;

  //Constructor
  Task({
    required this.id,
    required this.title,
    this.description = "",
    this.isDone = false,
    this.isPrivate = false,
    this.subTasks,
    required this.start,
    required this.end,
  });

  Task.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        description = snapshot['description'],
        isDone = snapshot['isDone'] as bool,
        isPrivate = snapshot['isPrivate'] as bool,
        start = snapshot['start'],
        end = snapshot['end'],
        subTasks = [];
}
