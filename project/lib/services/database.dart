import 'package:project/services/api_path.dart';
import '../models/project.dart';
import 'firestore_service.dart';

class Database {
  Database({required this.uid});

//TODO: dette kan hentes fra en provider
  final String uid;
  final _service = FirestoreService.instance;

  ///Pushes a given Project to the database
  Future<void> createProject(Project project) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, project.title),
        //data to write to firebase
        data: project.toMap(),
      );

  ///Removes a given Project from the database
  Future<void> removeProject(Project project) => _service.removeData(
        //path we will remove in the firebase
        path: APIPath.project(uid, project.title),
      );

  //TODO: delete this method or figure out the best to update data
  ///Updates a given Project in the database
  Future<void> updateProject(Project project, Map<String, dynamic> data) =>
      _service.updateData(
        //path in firebase
        path: APIPath.project(uid, project.title),
        //data to write to firebase
        data: data,
      );

  // ///Pushes a given Task-object to the database
  // Future<void> createTask(TaskTest task) => _service.setData(
  //       //path we will write to in the firebase
  //       path: APIPath.task(uid, 'project_id', 'task_id'),
  //       //data to write to firebase
  //       data: task.toMap(),
  //     );

  ///Pushes a given Task-object to the database
  Future<void> createTask(Project project, String task) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, project.title),
        //data to write to firebase
        data: project.toMap(),
      );

  Future<void> addTask(Project project, String task) async {
    //add the task to list of tasks in the project object

    //project.addTask(task);

    //add the new project object to the database

    _service.setData(
      //path we will write to in the firebase
      path: APIPath.project(uid, project.title),
      //data to write to firebase
      data: project.toMap(),
    );
  }

  // Future<void> addTask(ProjectTest project, String task) async {
  //   project.addTask(task);
  //   return updateList(project);
  // }

  // @override
  // Future<void> updateList(ProjectTest project) =>
  //     _updateDocument(APIPath.project(uid, project.title), project.toMap());
  //
  //
  //
  //
  //
  // Future<void> _updateDocument(String path, Map<String, dynamic> data) async {
  //   print("Updating $path ");
  //   final documentReference = FirebaseFirestore.instance.doc(path);
  //   await documentReference.set(data);
  // }

  ///Creates a stream that listens to projects
  Stream<List<Project>> projectsStream() => _service.collectionStream(
        path: APIPath.projects(uid),
        builder: (data) => Project.fromMap(data),
      );
}
