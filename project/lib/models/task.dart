
/// Represents a task in a project.
class Task {
  // The name of the task.
  String title;

  // The description of the task.
  String description;

  // Whether or not the task has been completed.
  bool done;

  //TODO: stretch-goal
  // The (optional) deadline of the task.
  //String? deadline;

  Task({
    this.title = "task title",
    this.description = "task description",
    this.done = false,
    // this.deadline
  });

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [
      title, description, done,
      // deadline
    ];
  }

  factory Task.fromMap(Map<String, dynamic> data) {
    final String title = data["title"];
    final String description = data["description"];
    //final String deadline = (data["deadline"]);
    final bool done = (data["done"]);
    return Task(
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
