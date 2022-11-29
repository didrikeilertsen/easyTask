import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:project/models/project.dart';
import 'package:project/styles/themes.dart';
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
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
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
      if (kDebugMode) {
        print('error occured');
      }
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('edit profile'),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 32,
        ),
        Column(
          children: [
            _buildImagePicker(),
            _buildForm(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Themes.primaryColor,
          child: _photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    _photo!,
                    width: 190,
                    height: 190,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(100)),
                  width: 190,
                  height: 190,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                            style: TextStyle(color: Colors.black87),
                            "click to"),
                        Text(
                            style: TextStyle(color: Colors.black87),
                            "add image"),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
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

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authenticationProvider);

    if (auth.currentUser != null) {
      _name = auth.currentUser!.displayName!;
      _email = auth.currentUser!.email!;
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
          uploadFile();
        }
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
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

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildFormChildren(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'new username'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      const SizedBox(height: 10),
      TextFormField(
        decoration: const InputDecoration(labelText: 'new email'),
        initialValue: _email,
        onSaved: (value) => _email = value!,
      ),
    ];
  }
}
