/// The data content of a project in the application.
class Project {
  // The name of the project.
  String title;
  // The description of the project.
  String description;
  //The list of tasks for the project
  List<String> tasks;

  Project({
    this.title = "project title",
    this.description = "",
     this.tasks = const []
  });

  factory Project.fromMap(Map<String, dynamic> data) {
    final String title = data["title"];
    final String description = data["description"];
    return Project(
      title: title,
      description: description,
      tasks: _formatTasks(data['tasks']),
    );
  }

  static List<String> _formatTasks(List<dynamic>? data) {
    if (data == null) return [];
    return data.map((item) => item.toString()).toList();
  }

  /// Add a task to the list
  void addTask(String taskName) {
    if (!tasks.contains(taskName)) {
      tasks.add(taskName);
    }
  }

  /// Remove a task from the list
  /// taskIndex: the index of the task to remove, starts at 0
  void removeTask(int taskIndex) {
    if (taskIndex < 0 || taskIndex >= tasks.length) {
      throw IndexError(taskIndex, tasks);
    }
    tasks.removeAt(taskIndex);
  }



  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
      'tasks' : tasks,
    };
  }
}
