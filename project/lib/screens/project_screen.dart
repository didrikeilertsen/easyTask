import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/projectTest.dart';
import 'package:project/models/taskTest.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/task_card.dart';

import '../../services/providers.dart';
import '../widgets/project_card_test.dart';
import '../widgets/search_bar.dart';

/// Screen/Scaffold for creating a new projext.
class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen(this.project, {Key? key}) : super(key: key);

  final ProjectTest? project;

  static Future<void> show(BuildContext context, ProjectTest project) async {
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
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _title = widget.project!.title;
      _description = widget.project!.description;
    }
  }

  Widget _buildContent(BuildContext context) {
    final database = ref.watch(databaseProvider);
    return SingleChildScrollView(
      //TODO når man scroller helt opp eller ned så starter en update. sjekk om dette gjør noe eller fjern det
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       elevation: 2.0,
  //
  //       centerTitle: false,
  //       titleSpacing: -4,
  //       leading: AppBarButton(
  //         handler: () => Navigator.of(context).pop(),
  //         tooltip: "Add new task",
  //         icon: PhosphorIcons.caretLeftLight,
  //         color: Colors.black,
  //       ),
  //       // backgroundColor: Colors.white,
  //       // foregroundColor: Colors.black,
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: () {},
  //           child: const Text(
  //             'Save',
  //             style: TextStyle(fontSize: 18, color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: _buildContent(context),
  //     backgroundColor: Colors.grey[200],
  //   );
  // }

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
}
