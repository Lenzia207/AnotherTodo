import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The [TodoItemWidget] represents an Item of Tasks  that contains a title, description and checkbox
// TODO Add Checkbox

class TodoItemWidget extends HookConsumerWidget {
  const TodoItemWidget({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Container() //DetailTodoPage(todo: todo),
              ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Card(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TITLE
                  if (documentSnapshot['title'] != null)
                    Text(
                      documentSnapshot['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 22),
                    ),

                  //If there is a DESCRIPTION
                  if (documentSnapshot['description'] != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        documentSnapshot['description'],
                        style: const TextStyle(fontSize: 20, height: 1.5),
                      ),
                    ),
                ],
              ),
              /*  Checkbox(
                activeColor: Theme.of(context).primaryColor,
                checkColor: Colors.white,
                value: documentSnapshot['isDone'],
                onChanged: (value) => null,
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
