import 'package:another_todo/model/task.dart';
import 'package:another_todo/widgets/task_items/slide_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This represents the data coming from Firestore in a list that is able to reorder the position of the items
class StreamTaskList extends HookWidget {
  const StreamTaskList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final task = useState<List<Task>>(tasks);
    return ReorderableListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: task.value.length,
      onReorder: ((oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        task.value.insert(
          newIndex,
          task.value.removeAt(oldIndex),
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
  }
}
