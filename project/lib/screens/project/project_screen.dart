import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/task/edit_task_screen.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/task_card.dart';
import '../../models/task.dart';
import '../../services/providers.dart';
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
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/editTask', arguments: widget.project);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(
            placeholderText: "search for task",
            searchFunction: () {},
            textEditingController: TextEditingController(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = ref.watch(databaseProvider);
    return StreamBuilder<List<Task>>(
        stream: database.tasksStream(widget.project),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Column(
                children: const [
                  SizedBox(height: 230),
                  Center(child: Text("No tasks added yet")),
                ],
              );
            }
            final tasks = snapshot.data;
            final children = tasks!
                .map((task) => TaskCard(
                      task: task,
                      onTap: () =>
                          EditTaskScreen.show(context, widget.project, task),
                    ))
                .toList();

            return Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    )
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Column(
              children: const [
                SizedBox(height: 230),
                Center(child: Text("No tasks added yet")),
              ],
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Some error occurred"));
          }

          return const Center(
              child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ));
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(widget.project.title),
      leading: AppBarButton(
        //handler: () => Navigator.of(context).pop(),
        handler: () => Navigator.of(context).pushNamed('/landingScreen'),
        tooltip: "Go back",
        icon: PhosphorIcons.caretLeftLight,
        color: Colors.black,
      ),
      actions: [
        AppBarButton(
          handler: () {
            EditProjectScreen.show(context, widget.project);
          },
          tooltip: "Edit the current project",
          icon: PhosphorIcons.pencilSimpleLight,
        ),
      ],
    );
  }
}
