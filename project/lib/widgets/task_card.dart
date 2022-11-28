import 'package:flutter/material.dart';
import '../models/task.dart';

/// Represents a project as a card used on project screen.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}