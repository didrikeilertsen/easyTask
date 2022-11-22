import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../services/providers.dart';

/// Screen/Scaffold for creating a new projext.
class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({Key? key}): super(key: key);

  @override
  CreateProjectScreenState createState() => CreateProjectScreenState();

}

class CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get _title => _titleController.text;

  String get _description => _descriptionController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add project"),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: <Widget>[
          AppBarButton(
            handler: () {},
            //handler: _createProject,
            tooltip: "Create new project",
            icon: PhosphorIcons.check,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextField(
                key: const Key("title_input"),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title"
                ),
                //enabled: !_submittedWithValidData,
              ),
              TextField(
                key: const Key("title_input"),
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: "Description (optional)"
                ),
              ),
              ElevatedButton(onPressed: _createProject, child: Text("Submit"))// const InputField(
              //   label: "title",
              //   placeholderText: "a concise description for the project...",
              //   keyboardType: TextInputAction.next,
              // ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              // InputField(
              //   key: const Key("description_input"),
              //   label: "description",
              //   placeholderText: "describe your project here",
              //   keyboardType: TextInputAction.done,
              //   onSubmit: () {},
              //),
            ],
          ),)
        ,
      )
      ,
    );
  }


  void _createProject() async {
      final database = ref.watch(databaseProvider);

      print("-------------------------------- $_title -------------------");

      await database.createProject(Project(title: _title, description: _description));
  }

  // void _createTask() async {
  //   final database = ref.watch(databaseProvider);
  //
  //   print("-------------------------------- $_title -------------------");
  //
  //   await database.createTaskTest(TaskTest(title: _title));
  //
  //
  //   Navigator.of(context).pop();
  // }

}

