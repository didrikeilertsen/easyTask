import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/services/providers.dart';
import 'package:project/widgets/project_card.dart';
import 'project_screen.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends ConsumerWidget {
  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: _buildLogo(),
      //   actions: [
      //     AppBarButton(
      //       handler: () {
      //         Navigator.of(context).pushNamed('/editProject');
      //       },
      //       tooltip: "Add new project",
      //       icon: PhosphorIcons.plus,
      //     )
      //   ],
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blurryBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            _buildCustomAppBar(context),
            const Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                bottom: 10.0,
              ),
              child: Text(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  "active projects:"),
            ),
            _buildContent(context, ref),
          ]),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Opacity(
          opacity: 0,
          child: TextButton(onPressed: () {}, child: const Icon(PhosphorIcons.plus))),
      Row(
        children: const [
          Text(
            "easy",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w100,
              color: Colors.black,
            ),
          ),
          Text(
            "Task",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
      OutlinedButton(
        onPressed: () {Navigator.of(context).pushNamed('/editProject');},
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
        child: const Icon(
            PhosphorIcons.plus,
            color: Colors.black87,
            size: 30,
          ),
      ),
    ]);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    return StreamBuilder<List<Project>>(
        stream: database.projectsStream(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator()));
          }

          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
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
          }

          if (!snapshot.hasData || snapshot.data?.length == 0) {
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
