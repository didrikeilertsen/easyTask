import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/appbar_button.dart';
import '../../models/task.dart';
import '../../services/providers.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// Screen for creating or editing a  task.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static Future<void> show(
      BuildContext context, Project project, Task task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;


    final auth = ref.watch(authenticationProvider);
    final uid = auth.currentUser!.uid;


    final fileName = path.basename(_photo!.path);
    final destination = 'files/$uid/$fileName';

    try {
      final reference = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await reference.putFile(_photo!);

      final url = await reference.getDownloadURL();

      await auth.currentUser!.updatePhotoURL(url);
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Column(
            children: [

              _photo != null
                  ? Image.file(
                      _photo!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    )
                  : const Text("no image"),



              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xffFDCF09),
                    child: _photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _photo!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   final auth = ref.read(authenticationProvider);
  //   return Scaffold(
  //     appBar: AppBar(
  //       elevation: 2.0,
  //       title: const Text('edit profile'),
  //       centerTitle: false,
  //       titleSpacing: -4,
  //       leading: AppBarButton(
  //         handler: () => Navigator.of(context).pop(),
  //         tooltip: "Add new task",
  //         icon: PhosphorIcons.caretLeftLight,
  //         color: Colors.black,
  //       ),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: _submit,
  //           child: const Text(
  //             'Save',
  //             style: TextStyle(fontSize: 18, color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: _buildContents(),
  //     backgroundColor: Colors.grey[200],
  //   );
  // }

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authenticationProvider);

    if (auth.currentUser != null) {
      _name = auth.currentUser!.displayName!;
      _email = auth.currentUser!.email!;
      //_deadline = widget.task!.deadline;
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
    final auth = ref.read(authenticationProvider);
    if (_validateAndSaveForm()) {
      try {
        if (auth.currentUser != null) {
          await auth.currentUser!.updateDisplayName(_name);
          await auth.currentUser!.updateEmail(_email);

          // await auth.currentUser!.updatePhotoURL(_email);
        }
      } on FirebaseException catch (e) {
        print(e.toString());
        const AlertDialog(
          title: Text('Operation failed'),
        );
      } finally {
        if (mounted) {
          Navigator.of(context).pop();
        }
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
          // _buildDeleteButton()
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
        decoration: const InputDecoration(labelText: 'username'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      const SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(labelText: 'email'),
        initialValue: _email,
        onSaved: (value) => _email = value!,
      ),
      // TextFormField(
      //   decoration: const InputDecoration(labelText: 'deadline'),
      //   initialValue: _email,
      //   //onSaved: (value) => _deadline = value!,
      // ),
    ];
  }

  //
  // Widget _buildDeleteButton() {
  //   return TextButton(
  //       onPressed: _delete,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           // Icon(
  //           //   Icons.delete,
  //           //   color: Colors.red,
  //           // ),
  //           Text( "update"),
  //         ],
  //       ));
  // }

  Future<void> _delete() async {
    // final database = ref.watch(databaseProvider);
    // if (widget.task != null) {
    //   database.removeTask(widget.project, widget.task!);
    // }
    // Navigator.of(context).pop();
  }
}
