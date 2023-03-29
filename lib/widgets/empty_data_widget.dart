import 'package:another_todo/widgets/task_items/button_create_task_widget.dart';
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
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 20,
        left: 10,
        right: 10,
      ),
      child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Center(
          child: Text(infoText),
        ),
        const ButtonCreateTaskWidget(
          infoText: 'New Task',
        ),
      ]),
    );
  }
}
