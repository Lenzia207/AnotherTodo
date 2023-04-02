import 'package:another_todo/screens/completed_tasks_screen.dart';
import 'package:another_todo/pages/pass_code_private_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:another_todo/screens/open_tasks_screen.dart';

/// This is the general representation of the [MainNavigationScreen] to navigate between the main screens
class MainNavigationScreen extends HookWidget {
  MainNavigationScreen({super.key});

  final pages = [
    const OpenTasksScreen(),
    const CompletedTasksScreen(),
    const PassCodePrivatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        elevation: 14,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(70),
            bottomLeft: Radius.circular(70),
          ),
        ),
        title: const Text(
          'Another Todo',
        ),
        centerTitle: true,
      ),
      body: pages[selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Open Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "Private",
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (int index) => selectedIndex.value = index,
      ),
    );
  }
}
