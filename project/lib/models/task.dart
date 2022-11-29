
/// Represents a task in a project.
class Task {
  // The name of the task.
  String title;

  // The description of the task.
  String description;

  // Whether or not the task has been completed.
  bool done;

  //TODO: stretch-goal  -- if not: remove deadline from ui
  // The (optional) deadline of the task.
  //String? deadline;


  String id;

  Task({
    this.title = "task title",
    this.description = "task description",
    this.done = false,
    // this.deadline
    this.id = "id",
  });

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [
      title, description, done,
      // deadline
    ];
  }

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    final String title = data["title"];
    final String description = data["description"];
    //final String deadline = (data["deadline"]);
    final bool done = (data["done"]);
    return Task(
      id: documentId,
      title: title,
      description: description,
      // deadline: deadline,
      done: done,
    );
  }

  /// Returns the data content of the task as a map.
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "done": done,
      // "deadline": deadline,
    };
  }
}
