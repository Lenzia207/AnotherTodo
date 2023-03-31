import 'package:another_todo/model/sub_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for the main Task
class Task {
  String id;
  String title;
  String description;
  bool isDone;
  bool isPrivate;
  List<SubTask>? subTasks;
  Timestamp? start;
  Timestamp? end;

  //Constructor
  Task({
    required this.id,
    required this.title,
    this.description = "",
    this.isDone = false,
    this.isPrivate = false,
    this.subTasks,
    this.start,
    this.end,
  });

  Task.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        description = snapshot['description'],
        isDone = snapshot['isDone'] as bool,
        isPrivate = snapshot['isPrivate'] as bool,
        start = snapshot['start'] as Timestamp?,
        end = snapshot['end'] as Timestamp?,
        subTasks = [];
}
