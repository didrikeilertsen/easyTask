import 'package:flutter/material.dart';
import 'package:project/styles/themes.dart';
import '../models/project.dart';


/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Themes.primaryColor,
        ),
            borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: _buildContent(),
        onTap: onTap,
        trailing: const Icon(
          Icons.chevron_right,
          color: Themes.primaryColor,
        ),
      ),
    );
  }


  _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),

          project.description != "" ?
          Text(project.description,
            style: TextStyle(
                color: Colors.grey[500]
            ),)
              :
          const SizedBox(height: 0, width: 0,),

        ],
      ),
    );
  }


}
