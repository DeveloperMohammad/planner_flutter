import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String name;
  @HiveField(1)
  bool isDone;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String priority;
  @HiveField(4)
  final TimeOfDay? deadline;

  Task({
    required this.name,
    required this.description,
    required this.isDone,
    required this.priority,
    this.deadline,
  });
}
