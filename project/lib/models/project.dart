/// The data content of a project in the application.
class Project {
  // The name of the project.
  String title;
  // The description of the project.
  String description;

  String id;

  Project({
    this.title = "project title",
    this.description = "project description",
    this.id = "id"
  });

  factory Project.fromMap(Map<String, dynamic> data, String documentId) {
    final String title = data["title"];
    final String description = data["description"];
    return Project(
      id : documentId,
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
