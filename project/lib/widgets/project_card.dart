import 'package:flutter/material.dart';

import '../models/projectOriginal.dart';

/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectOriginal project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        //TODO: fix shadow/border on cards
        // TODO: title and description shouldn't be able to overflow
        //TODO: add project screen has description. Show description in project card. if no description => show tasks
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          height: 75,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft, child: Text(project.title)),
              const SizedBox(height: 2),
              Text(
                _buildDescription(project),
                //project.tasks[0].description,
                style: const TextStyle(fontSize: 8.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildDescription(ProjectOriginal project) {
    String description = "";

    int i = 0;
    //project.tasks[0].description
    while (i < project.tasks.length) {
      String s = project.tasks[i].description;

      description = description + "• " + s + "\n";

      i++;
    }
    return description;
  }
}
