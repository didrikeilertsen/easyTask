import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/projectTest.dart';
import 'package:project/screens/project/edit_project_screen.dart';
import 'package:project/services/providers.dart';
import 'package:project/static_data/example_data.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/project_card_test.dart';
import 'package:project/widgets/search_bar.dart';
import '../../models/project.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends ConsumerWidget {
  //TODO: remove this?
  static const routeName = "/project-overview";

  const ProjectOverviewScreen({super.key});

  //todo consider making a list of project instead of project cards. description might be unnecessary

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Project> projects = ExampleData.projects;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("projects", textAlign: TextAlign.center),
        actions: [
          // TODO: Add action to button.
          AppBarButton(
            handler: () {
              Navigator.of(context).pushNamed('/editProject');
            },
            tooltip: "Add new project",
            icon: PhosphorIcons.plus,
          )
        ],
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(0),
      //   child: Column(
      //     children: [
      //       SearchBar(
      //         placeholderText: "search for project",
      //         searchFunction: () {},
      //         textEditingController: TextEditingController(),
      //         filterModal: const SizedBox(),
      //       ),
      //       const Padding(
      //         padding: EdgeInsets.only(top: 10),
      //       ),
      //       Expanded(
      //         child: SingleChildScrollView(
      //           child: Wrap(
      //             alignment: WrapAlignment.spaceBetween,
      //             children: _buildProjectList(projects),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

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
        _buildContent(context, ref),
      ]),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    return StreamBuilder<List<ProjectTest>>(
        stream: database.projectsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final projects = snapshot.data;
            final children = projects!
                .map((project) => ProjectCardTest(
                      project: project,

                      //TODO denne skal egentlig vise project screen
                      onTap: () => EditProjectScreen.show(context, project),
                    ))
                .toList();

            return Expanded(
              child: SingleChildScrollView(
                //TODO når man scroller helt opp eller ned så starter en update. sjekk om dette gjør noe eller fjern det
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

  List<Widget> _buildProjectList(List<Project> projects) {
    List<Widget> projectCards = [];
    for (Project project in projects) {
      projectCards.add(ProjectCard(project: project));
    }
    return projectCards;
  }
}
