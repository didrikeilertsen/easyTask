import 'package:project/services/api_path.dart';
import '../models/project.dart';
import '../models/task.dart';
import 'firestore_service.dart';

class Database {
  Database({required this.uid});

//TODO: dette kan hentes fra en provider
  final String uid;
  final _service = FirestoreService.instance;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  ///Adds or updates a given project
  Future<void> setProject(Project project) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, project.id),
        //data to write to firebase
        data: project.toMap(),
      );

  ///Removes a given Project from the database
  Future<void> removeProject(Project project) => _service.removeData(
    //path we will remove in the firebase
    path: APIPath.project(uid, project.title),
  );

  ///Adds or updates a given Task-object to the database
  Future<void> addTask(Project project, Task task) => _service.setData(
        //path we will write to in the firebase

        //TODO: task id here?
        path: APIPath.task(uid, project.id, task.title),
        //data to write to firebase
        data: task.toMap(),
      );

  ///Creates a stream that listens to projects
  Stream<List<Project>> projectsStream() => _service.collectionStream(
        path: APIPath.projects(uid),
        builder: (data, documentId) => Project.fromMap(data, documentId),
      );

  ///Creates a stream that listens to tasks
  Stream<List<Task>> tasksStream(Project project) => _service.collectionStream(
        path: APIPath.tasks(uid, project.id),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );

// ///Updates a given Project in the database
//   Stream<List<Task>> taskStream(Project project, Map<String, dynamic> data) =>
//     _service.updateData(
//       //path in firebase
//       path: APIPath.project(uid, project.title),
//       //data to write to firebase
//       data: data,
//     );

//TODO: delete this method or figure out the best to update data
// ///Updates a given Project in the database
// Future<void> updateProject(Project project, Map<String, dynamic> data) =>
//     _service.updateData(
//       //path in firebase
//       path: APIPath.project(uid, project.title),
//       //data to write to firebase
//       data: data,
//     );
}
