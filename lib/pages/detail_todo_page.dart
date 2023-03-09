import 'package:another_todo/widgets/button_add_widget.dart';
import 'package:another_todo/widgets/detail_header_todo_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailTodoPage extends HookConsumerWidget {
  DetailTodoPage({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailHeaderTodoCard(
                    documentSnapshot: documentSnapshot,
                  ),
                  Text(
                    "Start: $start",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text(
                    "Deadline is: $end",
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  Text("Time left: ${duration.inDays} Day's"),
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
                  const Divider(
                    height: 50,
                    thickness: 1.5,
                  ),
                  /*  ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => Container(height: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: subTodos.length,
                    itemBuilder: ((context, index) {
                      final subTodo = subTodos[index];
                      return SubTodoItemWidget(subTodo: subTodo);
                    }),
                  ), */
                ],
              ),
            ),
            ButtonAddWidget(
              infoText: ' Add Sub Task',
              function: () {},
            ),
          ],
        ),
      ),
    );
  }
}
