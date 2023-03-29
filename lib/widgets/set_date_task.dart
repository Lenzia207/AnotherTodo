import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SetDateTask extends HookWidget {
  SetDateTask({
    Key? key,
    required this.task,
  }) : super(
          key: key,
        );

  Task task;

  @override
  Widget build(BuildContext context) {
    final dataRange = useState(
      DateTimeRange(
        start: task.start.toDate(),
        end: task.end.toDate(),
      ),
    );

    Future pickDateRanger(context) async {
      DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dataRange.value,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
      );
      if (newDateRange != null) {
        // Store the new DateTimeRange in Firestore
        final myTaskId = FirebaseFirestore.instance.collection('myTasks').doc(
              task.id,
            );

        await myTaskId.update({
          'start': newDateRange.start,
          'end': newDateRange.end,
        });

        dataRange.value = newDateRange;
      }
    }

    final start = formatDate(dataRange.value.start, [
      dd,
      '.',
      mm,
      ' ',
      yyyy,
    ]);
    final end = formatDate(dataRange.value.end, [
      dd,
      '.',
      mm,
      ' ',
      yyyy,
    ]);
    final duration = dataRange.value.duration;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 20,
        left: 30,
        right: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start: $start",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
            ),
          ),
          Text(
            "Deadline is: $end",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
            ),
          ),
          Text("Duration: ${duration.inDays} Day(s)"),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => pickDateRanger(context),
                icon: const Icon(Icons.date_range),
                label: const Text(
                  "Set Date",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
