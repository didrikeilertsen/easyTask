import 'package:project/models/tag.dart';

import 'comment.dart';

/// Represents a task in a project.
class TaskTest {
  // The name of the task.
  String title;

  // The description of the task.
  String description;

  // Whether or not the task has been completed.
  bool done;

  // The (optional) deadline of the task.
  String? deadline;

  // List of comments of this task.
  List<Comment> comments;

  TaskTest(
      {this.title = "task title",
        this.description = "task description",
        this.done = false,
        this.deadline,
        this.comments = const []});

  /// Returns the data content of the task as a dynamic list.
  List<dynamic> values() {
    return [title, description, done, deadline];
  }

  /// Returns the data content of the task as a map.
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "done": done,
      "deadline": deadline,
      "comments": comments
    };
  }
}
