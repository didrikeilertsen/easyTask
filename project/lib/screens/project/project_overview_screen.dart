import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';
import 'package:project/services/providers.dart';
import 'package:project/widgets/add_button.dart';
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
      //
      //
      body: _buildContent(context, ref),
    );
  }

  Widget _buildLogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    ]);
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "easy",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
                color: Colors.black,
              ),
            ),
            Text(
              "Task",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildContent(BuildContext context, WidgetRef ref){
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/signInBackground.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              _buildCustomAppBar(context),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        "add a new project:   "),
                    AddButton(onPressed: () {
                      Navigator.pushNamed(context, '/editProject');
                    }),
                  ],
                ),
              ),
              _buildProjects(context, ref),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildProjects(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    return StreamBuilder<List<Project>>(
        stream: database.projectsStream(auth.currentUser!.uid),
        builder: (context, snapshot) {

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

