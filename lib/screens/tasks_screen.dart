import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '/widgets/tasks_list.dart';
import '/screens/add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key, this.payload}) : super(key: key);
  final String? payload;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box('tasks'),
      builder: (context, tasksBox) {
        var box = Hive.box('tasks');
        int doneTasks = 0;
        for (var task in box.values) {
          if (task.isDone == true) {
            doneTasks++;
          }
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.lightBlueAccent,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const AddTaskScreen(index: -1),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.manual,
                      ),
                    );
                  },
                ),
          backgroundColor: Colors.lightBlueAccent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 45, right: 25, left: 25, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        child: Icon(
                          Icons.list,
                          size: 25,
                          color: Colors.lightBlueAccent,
                        ),
                        backgroundColor: Colors.white,
                        radius: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'To Be Dones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$doneTasks / ${tasksBox.length} Tasks',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      )),
                  child: const TasksList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BlankScreen extends StatelessWidget {
  const BlankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddTaskScreen(index: -1),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            ),
          );
        },
      ),
    );
  }
}
