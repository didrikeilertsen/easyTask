import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/services/providers.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';
import 'project_screen.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends ConsumerWidget {
  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("projects", textAlign: TextAlign.center),
        actions: [
          AppBarButton(
            handler: () {
              Navigator.of(context).pushNamed('/editProject');
            },
            tooltip: "Add new project",
            icon: PhosphorIcons.plus,
          )
        ],
      ),
      body: Column(children: [
        SearchBar(
          placeholderText: "search for project",
          searchFunction: () {},
          textEditingController: TextEditingController(),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        _buildContent(context, ref),
      ]),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    return StreamBuilder<List<Project>>(
        stream: database.projectsStream(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final projects = snapshot.data;
            final children = projects!
                .map((project) => ProjectCard(
                      project: project,
                      onTap: () => ProjectScreen.show(context, project),
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
                    ),
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Column(
              children: const [
                SizedBox(height: 230),
                Center(child: Text("No projects added yet")),
                Center(
                    child:
                        Text("Press the + symbol to add your first project")),
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
}
