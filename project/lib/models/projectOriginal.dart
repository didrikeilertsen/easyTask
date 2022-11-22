import 'package:project/models/tag.dart';
import 'package:project/models/taskOriginal.dart';

/// The data content of a project in the application.
class ProjectOriginal {
  // The name of the project.
  String title;



  // The list of tasks in the project.
  List<Task> tasks;
  // The list of tags in the project.
  List<Tag> tags;

  ProjectOriginal({this.title = "project title", this.tasks = const [], this.tags = const []});


  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'tasks': tasks,
      'tags' : tags,
    };

  }

}
