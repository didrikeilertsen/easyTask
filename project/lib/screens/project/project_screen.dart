import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../../services/providers.dart';
import '../../widgets/search_bar.dart';

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
        title: Text(widget.project == null ? '' : widget.project!.title),
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        actions: [
          AppBarButton(
            handler: () {
              Navigator.of(context).pushNamed('/editTask');
            },
            tooltip: "Add new task",
            icon: PhosphorIcons.plus,
          )
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
    final database = ref.watch(databaseProvider);
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.project == null ? '' : widget.project!.description),
              Text(widget.project == null ? '' : widget.project!.description),
            ],
          ),
        ),
      ),
    );
  }
}
