import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/task.dart';

/// Represents a project as a card used on project screen.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        onTap: onTap,
        trailing: const Icon(
            PhosphorIcons.pencilSimpleLight,
            size: 18,
          ),
        ),
    );
  }
}
