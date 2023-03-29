import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/task_items/slide_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StreamTaskList extends HookWidget {
  const StreamTaskList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        // When tap & hold item, items can be reordered in the list
        return ReorderableListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: tasks.length,
          onReorder: ((oldIndex, newIndex) {
            setState(
              () {
                if (newIndex > oldIndex) newIndex--;

                final task = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, task);
              },
            );
          }),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return SlideActionWidget(
              key: ValueKey(task.id),
              task: task,
            );
          },
        );
      },
    );
  }
}
