import 'package:hive/hive.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

import '/models/notification_api.dart';
import 'tasks_screen.dart';
import '/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final int index;

  const AddTaskScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

final List<String> priorities = ['High', 'Medium', 'Low'];

String? priority = 'Medium';
String? titleText = '';
String? descriptionText = '';
bool isFormValid = false;

class _AddTaskScreenState extends State<AddTaskScreen> {

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    widget.index >= 0 ? _taskTime = Hive
        .box('tasks')
        .getAt(widget.index)
        .deadline : print('Error');
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen((String? payload) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TasksScreen(payload: payload),
        ),
      );
    });
  }

  TimeOfDay _taskTime = TimeOfDay.now();

  void handleTimePicker() async {
    final taskTime = await showTimePicker(
      initialTime: _taskTime, // ?? TimeOfDay.now(),
      context: context,
    );
    if (taskTime != null && taskTime != _taskTime) {
      setState(() {
        _taskTime = taskTime;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isAdding = widget.index == -1;

    final _task = isAdding
        ? Task(name: '', description: '', isDone: false, priority: 'Medium')
        : Hive.box('tasks').getAt(widget.index);

    titleText = _task.name;
    descriptionText = _task.description;
    priority = _task.priority;

    return Container(
      color: const Color(0xFF757575),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                // fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: titleText,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    onChanged: (title) {
                      titleText = title;
                    },
                    onSaved: (title) => titleText = title,
                    validator: (input) =>
                    input!.trim().isEmpty ? 'Please Enter the title' : null,
                  ),
                  TextFormField(
                    initialValue: descriptionText,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    onChanged: (description) {
                      descriptionText = description;
                    },
                    onSaved: (description) => descriptionText = description,
                  ),
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: priorities.map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        priority = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Priority',
                    ),
                    alignment: Alignment.centerLeft,
                    onSaved: (input) => priority = input.toString(),
                    validator: (input) =>
                    priority == null
                        ? 'Please select a task priority'
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Show a notification at: ',
                        style: TextStyle(
                          fontSize: 18,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text(
                                 _taskTime.format(context)),
                              // _taskTime == null
                              //     ? 'Please Select Task Time'
                              //     :
                          onPressed: handleTimePicker,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final task = Task(
                      priority: priority!,
                      name: titleText!,
                      description: descriptionText!,
                      isDone: _task.isDone,
                      deadline: _taskTime,
                    );
                    NotificationApi.showScheduledNotification(
                      id: 0,
                      title: task.name,
                      body: task.description.isEmpty
                          ? 'You\'ve tasks to perform today'
                          : task.description,
                      scheduledDate: DateTime(
                        2021,
                        DateTime.now().month,
                        DateTime.now().day,
                        _taskTime.hour,
                        _taskTime.minute,
                        0,
                        0,
                        0,
                      ),
                    );
                    if (widget.index == -1) {
                      Hive.box('tasks').add(task);
                    } else {
                      Hive.box('tasks').putAt(widget.index, task);
                    }
                    Navigator.of(context).pop();
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}