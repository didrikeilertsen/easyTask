import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/static_data/example_data.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';
import '../../models/project.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends StatelessWidget {
  //TODO: remove this?
  static const routeName = "/project-overview";

  const ProjectOverviewScreen({super.key});

  //todo consider making a list of project instead of project cards. description might be unnecessary

  @override
  Widget build(BuildContext context) {
    //final List<Project> projects = ModalRoute.of(context)!.settings.arguments as List<Project>;
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
              Navigator.of(context).pushNamed('/createProject');
            },
            tooltip: "Add new project",
            icon: PhosphorIcons.plus,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            SearchBar(
              placeholderText: "search for project",
              searchFunction: () {},
              textEditingController: TextEditingController(),
              filterModal: const SizedBox(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              //TODO når man scroller helt opp eller ned så starter en update
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: _buildProjectList(projects),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProjectList(List<Project> projects) {
    List<Widget> projectCards = [];
    for (Project project in projects) {
      projectCards.add(ProjectCard(project: project));
    }
    return projectCards;
  }
}
