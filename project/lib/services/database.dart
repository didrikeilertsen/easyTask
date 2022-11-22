import 'package:project/models/project.dart';
import 'package:project/models/task.dart';
import 'package:project/services/api_path.dart';

import '../models/projectOriginal.dart';
import 'firestore_service.dart';

class Database {
  Database({required this.uid});

//TODO: dette kan hentes fra en provider
  final String uid;
  final _service = FirestoreService.instance;

  Future<void> createProject(Project project) => _service.setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, project.title),

        //data to write to firebase
        data: project.toMap(),
      );

  // ///Pushes a given Task-object to the database
  // Future<void> createTaskTest(TaskTest task) => _service.setData(
  //       //path we will write to in the firebase
  //       path: APIPath.task(uid, 'project_id', 'task_id'),
  //
  //       //data to write to firebase
  //       data: task.toMap(),
  //     );

  ///Creates a stream that listens to projects
  Stream<List<Project>> projectsStream() => _service.collectionStream(
        path: APIPath.projects(uid),
        builder: (data) => Project.fromMap(data),
      );


}
