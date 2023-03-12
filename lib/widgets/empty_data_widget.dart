import 'package:another_todo/provider/create_task_bottom_sheet.dart';
import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// This [EmptyDataWidget] is a widgets that gives the information about an empty page

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    Key? key,
    required this.infoText,
  }) : super(key: key);

  final String infoText;

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

    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
      child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Center(
          child: Text(infoText),
        ),
        ButtonAddWidget(
          infoText: 'New Task',
          function: (() => createTask(context)),
        ),
      ]),
    );
  }
}
