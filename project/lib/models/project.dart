/// The data content of a project in the application.
class Project {
  // The name of the project.
  String title;
  // The description of the project.
  String description;

  Project({
    this.title = "project title",
    this.description = "project description",
  });

  factory Project.fromMap(Map<String, dynamic> data) {
    final String title = data["title"];
    final String description = data["description"];
    return Project(
      title: title,
      description: description,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
    };
  }
}
