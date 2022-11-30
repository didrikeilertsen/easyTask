import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../models/task.dart';
import '../../services/providers.dart';

/// Screen for creating or editing a  task.
class EditTaskScreen extends ConsumerStatefulWidget {
  const EditTaskScreen({Key? key, required this.project, this.task})
      : super(key: key);

  final Task? task;
  final Project project;

  static Future<void> show(
      BuildContext context, Project project, Task task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(project: project, task: task),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

//TODO  bug når man oppdaterer task: en ny task lages hvis navn oppdateres. må implementere samme logikk som jeg gjorde i project

class EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  String? _deadline = "";
  DateTime? date = DateTime.now();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      if (widget.task!.deadline != null) {
        _deadline = widget.task!.deadline;
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _submit() async {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    if (_validateAndSaveForm()) {
      try {
        final task =
            Task(title: _title, description: _description, deadline: _deadline);
        database.addTask(auth.currentUser!.uid, widget.project, task);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        const AlertDialog(
          title: Text('Operation failed'),
        );
      }
    }
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
          _buildDeleteButton()
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'task name'),
        initialValue: _title,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value!,
      ),
      const SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(labelText: 'description (optional)'),
        initialValue: _description,
        onSaved: (value) => _description = value!,
      ),
      const SizedBox(height: 10),
      TextField(
          controller: dateController,
          onChanged: (value) => _deadline = value,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
            labelText: "deadline",
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime(2101));

            if (pickedDate != null) {
              String dateString = DateFormat('dd/MM/yyyy').format(pickedDate);

              setState(() {
                dateController.text = dateString;
                _deadline = dateString;
              });
            } else {
              if (kDebugMode) {
                print("Date is not selected");
              }
            }
          }),
    ];
  }

  Widget _buildDeleteButton() {
    if (widget.task == null) {
      return const SizedBox(height: 0, width: 0);
    }
    return TextButton(
        onPressed: _delete,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Text(style: TextStyle(color: Colors.red), "delete task"),
          ],
        ));
  }

  Future<void> _delete() async {
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(authenticationProvider);
    if (widget.task != null) {
      database.removeTask(auth.currentUser!.uid, widget.project, widget.task!);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.task == null ? 'new task' : 'edit task'),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: _submit,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }
}
