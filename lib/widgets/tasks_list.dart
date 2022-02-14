import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';

import '../widgets/task_list_tile.dart';
import '../screens/add_task_screen.dart';
import 'delete_dialog.dart';

class TasksList extends StatefulWidget {

  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box('tasks'),
      builder: (context, nothing) {
        final tasksBox = Hive.box('tasks');
        return ReorderableListView.builder(
          itemCount: tasksBox.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey('$index'),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return DeleteDialog(index);
                  },
                );
              },
              child: GestureDetector(
                key: Key('$index'),
                onDoubleTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddTaskScreen(index: index),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.manual,
                    ),
                  );
                },
                child: TaskListTile(index: index),
              ),
            );
          },
          onReorder: (int oldIndex, int newIndex) async {
            if (newIndex > tasksBox.length) newIndex = tasksBox.length;
            if (oldIndex < newIndex) newIndex -= 1;

            final oldItem = await tasksBox.getAt(oldIndex);
            final newItem = await tasksBox.getAt(newIndex);

            await tasksBox.putAt(newIndex, oldItem!);
            await tasksBox.putAt(oldIndex, newItem!);
          },
        );
      },
    );
  }
}
