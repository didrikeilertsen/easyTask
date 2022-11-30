import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/task/edit_task_screen.dart';
import 'package:project/widgets/add_button.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/task_card.dart';
import '../../models/task.dart';
import '../../services/providers.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildContent(),
            _buildTasks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              "add a new task:       "),
          AddButton(onPressed: () {
            Navigator.of(context)
                .pushNamed('/editTask', arguments: widget.project);
          }),
        ],
      ),
    );
  }

  Widget _buildTasks(BuildContext context) {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    return StreamBuilder<List<Task>>(
        stream: database.tasksStream(auth.currentUser!.uid, widget.project),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Column(
                children: [
                  const SizedBox(height: 230),
                  Center(
                      child: Column(
                    children: const [
                      Text("No tasks added yet"),
                      Text('Press the "+" button to add your first task '),
                    ],
                  )),
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
                      )),
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
