import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DeleteDialog extends StatelessWidget {
  final int taskIndex;

  const DeleteDialog(this.taskIndex ,{Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(right: 10, left: 10),
      contentPadding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      title: const Text(
        'Delete message',
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'This task will be deleted. Are you sure to delete the task?',
        style: TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Hive.box('tasks').deleteAt(taskIndex);
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
