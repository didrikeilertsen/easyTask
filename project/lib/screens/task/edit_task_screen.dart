import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../models/task.dart';
import '../../services/providers.dart';

/// Screen/Scaffold for creating a new projext.
class EditTaskScreen extends ConsumerStatefulWidget {
  const EditTaskScreen({Key? key, required this.project, this.task})
      : super(key: key);

  final Task? task;
  final Project project;

  static Future<void> show(BuildContext context, Project project) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(project: project),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

class EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  // String _deadline= "";

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      //_deadline = widget.task!.deadline;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _submit() async {
    final database = ref.watch(databaseProvider);
    if (_validateAndSaveForm()) {
      try {

        final task = Task(title: _title, description: _description);

        database.addTask(widget.project, task);





        // List<String> tasks = widget.project.tasks;
        //
        // tasks.add(task.title);
        //
        // Project project = Project(
        //   title: widget.project.title,
        //   description: widget.project.description,
        //   tasks: tasks,
        // );
        //
        // database.removeProject(widget.project);
        // database.createProject(project);
        // ProjectScreen.show(context, project);

        // TODO: stretch-goal: add deadline to tasks
        // if(task.deadline != null) {
        //   final task = Task(title: _title, description: _description, deadline: _deadline);
        // }

        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        const AlertDialog(
          title: Text('Operation failed'),
        );
      }
    }
  }

  // Future<void> _submit() async {
  //   final database = ref.watch(databaseProvider);
  //   if (_validateAndSaveForm()) {
  //     try {
  //
  //       final task = Task(title: _title, description: _description);
  //
  //       List<String> tasks = widget.project.tasks;
  //
  //       tasks.add(task.title);
  //
  //       Project project = Project(
  //         title: widget.project.title,
  //         description: widget.project.description,
  //         tasks: tasks,
  //       );
  //
  //       database.removeProject(widget.project);
  //       database.createProject(project);
  //       ProjectScreen.show(context, project);
  //
  //       // TODO: stretch-goal: add deadline to tasks
  //       // if(task.deadline != null) {
  //       //   final task = Task(title: _title, description: _description, deadline: _deadline);
  //       // }
  //
  //       Navigator.of(context).pop();
  //     } on FirebaseException catch (e) {
  //       const AlertDialog(
  //         title: Text('Operation failed'),
  //       );
  //     }
  //   }
  // }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'task name'),
        initialValue: _title,

        //TODO: implement this is edit_task_screen and edit_project_screen
        //validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',

        onSaved: (value) => _title = value!,
      ),
      const SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(labelText: 'description (optional)'),
        initialValue: _description,
        onSaved: (value) => _description = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'deadline'),
        initialValue: _description,
        //onSaved: (value) => _deadline = value!,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.task == null ? 'new task' : 'edit task'),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        actions: <Widget>[
          ElevatedButton(
            onPressed: _submit,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }
}
