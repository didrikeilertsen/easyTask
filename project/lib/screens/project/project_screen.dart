import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../widgets/search_bar.dart';
import 'edit_project_screen.dart';

/// Screen/Scaffold for creating a new projext.
class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen(this.project, {Key? key}) : super(key: key);

  final Project project;

  static Future<void> show(BuildContext context, Project project) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectScreen(project),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  ProjectScreenState createState() => ProjectScreenState();
}

class ProjectScreenState extends ConsumerState<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(widget.project.title),
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        actions: [
          AppBarButton(
            handler: () {EditProjectScreen.show(context, widget.project);},
            tooltip: "Edit the current project",
            icon: PhosphorIcons.pencilSimpleLight,
          ),
        ],
      ),
      body: Column(children: [
        SearchBar(
          placeholderText: "search for project",
          searchFunction: () {},
          textEditingController: TextEditingController(),
          filterModal: const SizedBox(),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        _buildContent(context),
      ]),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/editTask');
                  },
                  child: const Text("add task")),
              Text(widget.project.description),
            ],
          ),
        ),
      ),
    );
  }
}
