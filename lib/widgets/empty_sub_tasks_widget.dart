import 'package:flutter/material.dart';

/// This [EmptySubTasksWidget] is a widgets that gives the information about an empty page
class EmptySubTasksWidget extends StatelessWidget {
  const EmptySubTasksWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          indent: 40,
          endIndent: 40,
          thickness: 1.5,
          color: Colors.black12,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            'Sub - Tasks'.toUpperCase(),
            style: const TextStyle(
                color: Colors.black12,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text(
            'There are no sub-tasks yet',
            style: TextStyle(
              color: Colors.black12,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
