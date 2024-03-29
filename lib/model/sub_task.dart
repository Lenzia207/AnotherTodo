import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for the subTask connected to the main Task id
class SubTask {
  String id;
  String title;
  String description;
  bool isDone;

  //Constructor
  SubTask({
    required this.id,
    required this.title,
    this.description = "",
    this.isDone = false,
  });

  SubTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        description = snapshot['description'],
        isDone = snapshot['isDone'] as bool;
}
