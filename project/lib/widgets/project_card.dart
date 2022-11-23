import 'package:flutter/material.dart';
import '../models/project.dart';

/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.title),
      subtitle: Text(project.description),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );



    // return Card(

    //   elevation: 5,
    //   child: Padding
    //     padding: const EdgeInsets.all(8.0),
    //     child: SizedBox(
    //       //width: 150,
    //       height: 75,
    //       child: Column(
    //         children: [
    //           Align(
    //               alignment: Alignment.centerLeft, child: Text(project.title)),
    //           const SizedBox(height: 2),
    //           // Text(
    //           //   project.title,
    //           //   //project.tasks[0].description,
    //           //   style: const TextStyle(fontSize: 8.5),
    //           // ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

// String _buildDescription(ProjectTest project){
//   String description = "";
//
//   int i = 0;
//   //project.tasks[0].description
//   while(i < project.tasks.length) {
//     String s = project.tasks[i].description;
//
//     description = description + "• " + s + "\n";
//
//     i++;
//   }
//
//
//   // for (Task task in project) {
//   //
//   //   projectCards.add(ProjectCard(project: project));
//   // }
//   return description;
// }

}