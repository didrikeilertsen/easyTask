import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';

import '../../services/providers.dart';

/// Screen/Scaffold for creating a new projext.
class EditProjectScreen extends ConsumerStatefulWidget {
  const EditProjectScreen(this.project, {Key? key}) : super(key: key);

  final Project? project;

  static Future<void> show(BuildContext context, Project project) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProjectScreen(project),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  EditProjectScreenState createState() => EditProjectScreenState();
}

class EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _title = widget.project!.title;
      _description = widget.project!.description;
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

  //TODO: need to seperate edit project screen and create project screen. This method doesnt update a project, it creates a new one
  Future<void> _submit() async {
    final database = ref.watch(databaseProvider);
    if (_validateAndSaveForm()) {
      try {
        final project = Project(title: _title, description: _description);
        if (widget.project != null) {
          //remove the previous project and add a new one.
          // This is done instead of updating so the document name changes too
          database.removeProject(widget.project!);
          database.createProject(project);

          //TODO: need to get project info to update when popping back
          Navigator.of(context).pop();
        } else {


          // final projects = await database.projectsStream().first;
          // final allTitles = projects.map((project) => project.title).toList();
          // if (allTitles.contains(_title)) {
          //   const AlertDialog(
          //     //TODØ: dette funker ikke
          //     title: Text('Name already used'),
          //     content: Text('Please choose a different project name'),
          //     // defaultActionText: 'OK',
          //   );
          // } else {

          await database.createProject(project);
          Navigator.of(context).pop();
          // }
        }
      } on FirebaseException catch (e) {
        const AlertDialog(
          title: Text('Operation failed'),
        );
      }
    }
  }

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
        decoration: const InputDecoration(labelText: 'project name'),
        initialValue: _title,
        //validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value!,
      ),
      SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(labelText: 'description (optional)'),
        initialValue: _description,
        onSaved: (value) => _description = value!,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.project == null ? 'new project' : 'edit project'),
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
