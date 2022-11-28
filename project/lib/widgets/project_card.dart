import 'package:flutter/material.dart';
import '../models/project.dart';

/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(project.title),
        subtitle: Text(project.description),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}