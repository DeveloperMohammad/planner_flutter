import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskListTile extends StatefulWidget {
  final int index;

  const TaskListTile({Key? key, required this.index}) : super(key: key);

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  @override
  Widget build(BuildContext context) {
    final MaterialColor color;

    Task task = Task(name: '', description: '', priority: 'Medium', isDone: false);
    task = Hive.box('tasks').getAt(widget.index);

    if (task.priority == 'High') {
      color = Colors.red;
    } else if (task.priority == 'Medium') {
      color = Colors.lightBlue;
    } else {
      color = Colors.grey;
    }

    return ListTile(
      key: Key('${widget.index}'),
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          task.priority.substring(0, 1),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        task.name,
        style: TextStyle(
          fontSize: 18,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.description.isEmpty
          ? null
          : Text(
        task.description,
        style: TextStyle(
          fontSize: 14,
          color: Colors.blueGrey,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: task.isDone,
        onChanged: (value) {
          setState(
                () {
              task.isDone = value!;
              Hive.box('tasks').putAt(
                widget.index,
                Task(
                  priority: task.priority,
                  name: task.name,
                  isDone: value,
                  description: task.description,
                  deadline: task.deadline,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
