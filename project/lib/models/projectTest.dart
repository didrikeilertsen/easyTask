import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';

/// The data content of a project in the application.
class ProjectTest {
  // The name of the project.
  String title;
  // The description of the project.
  String? description;

  ProjectTest({this.title = "project title", this.description = ""});

  factory ProjectTest.fromMap(Map<String, dynamic> data) {
    final String title = data["title"];
    //final String description = data["description"];
    return ProjectTest(
      title: title,
      //description: description,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
    };
  }
}
