import 'package:another_todo/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// This sets a date range by default and can be edited.
/// The color of the duration changes when the number / days gets lower
class SetDateTask extends HookWidget {
  const SetDateTask({
    Key? key,
    required this.task,
  }) : super(
          key: key,
        );

  final Task task;

  @override
  Widget build(BuildContext context) {
    // get Timestamp from task and convert to type DateTime
    final dataRange = useState(
      DateTimeRange(
        start: task.start!.toDate(),
        end: task.end!.toDate().add(
              const Duration(
                days: 7,
              ),
            ),
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
        // Get the taskId and update the new DateTimeRange in Firestore
        final myTaskId = FirebaseFirestore.instance
            .collection(
              'myTasks',
            )
            .doc(
              task.id,
            );

        await myTaskId.update({
          'start': newDateRange.start,
          'end': newDateRange.end,
        });

        dataRange.value = newDateRange;
      }
    }

    final start = formatDate(dataRange.value.start, [dd, '.', mm, ' ', yyyy]);
    final end = formatDate(dataRange.value.end, [dd, '.', mm, ' ', yyyy]);
    final duration = dataRange.value.duration;

    // the color changes depending how much days are left
    Color getColor(duration) {
      if (duration <= 1) return Colors.red;
      if (duration <= 3) return Colors.orange;
      return Colors.green;
    }

    String getText(date) {
      if (date == 1) return 'Time left: ${duration.inDays} Day';
      return 'Time left: ${duration.inDays} Days';
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 20,
        left: 30,
        right: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start: $start",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Deadline: $end",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            getText(duration.inDays),
            style: TextStyle(
              fontSize: 24,
              color: getColor(duration.inDays),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => pickDateRanger(context),
                icon: const Icon(
                  Icons.date_range,
                ),
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
