import 'package:project/services/api_path.dart';
import '../models/project.dart';
import '../models/task.dart';
import 'firestore_service.dart';

class Database {
  Database({required this.uid});

  String uid;
  final _service = FirestoreService.instance;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  ///Adds or updates a given project
  Future<void> setProject(uid, Project project) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, project.id),
        //data to write to firebase
        data: project.toMap(),
      );

  ///Removes a given Project from the database
  Future<void> removeProject(uid, Project project) => _service.removeData(
        //path we will remove in the firebase
        path: APIPath.project(uid, project.id),
      );

  ///Adds or updates a given Task-object to the database
  Future<void> addTask(uid, Project project, Task task) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.task(uid, project.id, task.title),
        //data to write to firebase
        data: task.toMap(),
      );

  ///Removes a given Task-object to the database
  Future<void> removeTask(uid, Project project, Task task) => _service.removeData(
        //path we will remove in the firebase
        path: APIPath.task(uid, project.id, task.title),
      );

  ///Creates a stream that listens to projects
  Stream<List<Project>> projectsStream(uid) => _service.collectionStream(
        path: APIPath.projects(uid),
        builder: (data, documentId) => Project.fromMap(data, documentId),
      );

  ///Creates a stream that listens to tasks
  Stream<List<Task>> tasksStream(uid, Project project) => _service.collectionStream(
        path: APIPath.tasks(uid, project.id),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );
}
