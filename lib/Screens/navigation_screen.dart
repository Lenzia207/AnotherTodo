import 'package:firebase_core/firebase_core.dart';
import 'package:another_todo/Screens/completed_tasks_screen.dart';
import 'package:another_todo/pages/pass_code_private_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:another_todo/Screens/open_tasks_screen.dart';

class MainNavigationScreen extends HookWidget {
  MainNavigationScreen({super.key});

  final pages = [
    OpenTasksScreen(),
    CompletedTasksScreen(),
    const PassCodePrivatePage(),
/*    
    const PassCodePrivatePage(), */
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Todo'),
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
