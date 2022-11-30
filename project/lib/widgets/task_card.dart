import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/styles/themes.dart';
import '../models/task.dart';

/// Represents a project as a card used on project screen.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: _buildDeadline(),
          onTap: onTap,
          trailing: const Icon(
            PhosphorIcons.pencilSimpleLight,
            color: Themes.primaryColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  _buildDeadline() {
    List<String> fields = [];
    if (task.description != "") {
      fields.add(task.description);
    }
    if (task.deadline != "") {
      fields.add("deadline: ${task.deadline!}");
    }

    final children = fields
        .map((field) => Text(
              field,
              style: TextStyle(color: Colors.grey[500]),
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.title,
        style: const TextStyle(
            fontWeight: FontWeight.bold
        ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),

        // children
      ],
    );

    if (task.deadline != "") {
      return Container(
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title),
            Text("deadline: ${task.deadline}"),
            Text(task.description),
          ],
        ),
      );
    }
  }
}
