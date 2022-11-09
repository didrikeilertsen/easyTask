import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/services/api_path.dart';

import '../models/job.dart';
import '../models/project.dart';

class Database extends ConsumerWidget {
  const Database({super.key, required this.uid}) : assert(uid != null);

//TODO: dette kan hentes fra en provider
  final String uid;

  // // this method takes a map of key-value-pairs that represents the fields we want to write in our document
  // @override
  // Future<void> createJob(Job job) async {
  //
  //   //path we will write to in the firebase
  //   final path = APIPath.job(uid, 'job_abc');
  //   final documentReference = FirebaseFirestore.instance.doc(path);
  //
  //   await documentReference.set(job.toMap());
  // }

  Future<void> createJob(Job job) => _setData(
        //path we will write to in the firebase
        path: APIPath.job(uid, 'job_abc'),

        //data to write to firebase
        data: job.toMap(),
      );

  Future<void> createProject(Project project) => _setData(
        //path we will write to in the firebase
        path: APIPath.project(uid, 'project_id'),

        //data to write to firebase
        data: project.toMap(),
      );

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

//I would really recommend people to use ChangeNotifiers as that is a lot easier
// to start out with and scales increadibly well together with Riverpod!
