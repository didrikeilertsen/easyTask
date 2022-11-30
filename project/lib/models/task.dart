
/// Represents a task in a project.
class Task {
  // The name of the task.
  String title;

  // The description of the task.
  String description;

  // The (optional) deadline of the task.
  String? deadline;


  String id;

  Task({
    this.title = "task title",
    this.description = "task description",
    this.deadline,
    this.id = "id",
  });

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [
      title, description, deadline
    ];
  }

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    final String title = data["title"];
    final String description = data["description"];
    final String deadline = (data["deadline"]);
    return Task(
      id: documentId,
      title: title,
      description: description,
      deadline: deadline,
    );
  }

  /// Returns the data content of the task as a map.
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "deadline": deadline,
    };
  }
}
