import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SetDateTask extends HookWidget {
  const SetDateTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataRange = useState(
      DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(
          const Duration(days: 7),
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

      dataRange.value = newDateRange ?? dataRange.value;
    }

    final start = formatDate(dataRange.value.start, [dd, '.', mm, ' ', yyyy]);
    final end = formatDate(dataRange.value.end, [dd, '.', mm, ' ', yyyy]);
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
            style: const TextStyle(fontSize: 24, color: Colors.blue),
          ),
          Text(
            "Deadline is: $end",
            style: const TextStyle(fontSize: 24, color: Colors.blue),
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
                label: const Text("Set Date"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
