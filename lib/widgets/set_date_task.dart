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
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    // get Timestamp from task and convert to type DateTime
    final dataRange = useState(
      DateTimeRange(
        start: task.start!.toDate(),
        end: task.end!.toDate(),
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

    final start = formatDate(
      dataRange.value.start,
      [dd, '.', mm, ' ', yyyy],
    );
    final end = formatDate(
      dataRange.value.end,
      [dd, '.', mm, ' ', yyyy],
    );

    // calculate the remaining time between the current day and the end date
    // add Duration -1 to have the last day of a deadline displayed as 1 and not 0
    final remainingTime = dataRange.value.end.difference(DateTime.now());
    final remainingDays = remainingTime.inDays;

    // Get the right Text distinguishing between day and days
    final remainingText = remainingDays == 1
        ? 'Time left: 1 Day'
        : 'Time left: $remainingDays Days';

    // the color changes depending how much days are left
    final remainingDaysColor = remainingDays <= 1
        ? Colors.red
        : remainingDays <= 3
            ? Colors.orange
            : Colors.green;

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
            remainingText,
            style: TextStyle(
              fontSize: 24,
              color: remainingDaysColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => pickDateRanger(context),
                  icon: const Icon(
                    Icons.date_range,
                  ),
                  label: const Text(
                    "Set Date",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
