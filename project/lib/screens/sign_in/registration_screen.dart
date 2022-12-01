import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/services/auth.dart';
import 'package:string_validator/string_validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.auth}) : super(key: key);

  final Auth auth;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _submittedWithValidData = false;
  bool _submitButtonPressed = false;

  String get _username => _usernameController.text;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUsernameInput(),
                  _buildEmailInput(),
                  _buildPasswordInput(),
                  const SizedBox(height: 25),
                  _submittedWithValidData
                      ? _buildLoadingCircle()
                      : _buildSubmitButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _submitButtonPressed = true;
      _submittedWithValidData = _isFormValid();
    });

    if (_isFormValid()) {
      try {
        User? user =
            await widget.auth.createUserWithEmailAndPassword(_email, _password);
        if (_username.isNotEmpty) {
          if (user != null) {
            await user.updateDisplayName(_username);
          }
        }
      } catch (e) {
        // Girts comment: nothing happens when you enter an invalid email or password - you are thrown back to login screen. There should be an error message instead
        print(e.toString());
      } finally {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  TextField _buildUsernameInput() {
    return TextField(
        key: const Key("username_input"),
        controller: _usernameController,
        enabled: !_submittedWithValidData,
        decoration: InputDecoration(
            labelText: "Username",
            errorText: !_isUsernameValid() && _submitButtonPressed
                ? "invalid username"
                : null),
        onChanged: (username) => _forceRebuild());
  }

  TextField _buildEmailInput() {
    return TextField(
        key: const Key("email_input"),
        controller: _emailController,
        enabled: !_submittedWithValidData,
        decoration: InputDecoration(
            labelText: "Email",
            errorText: !_isEmailValid() && _submitButtonPressed
                ? "invalid email format"
                : null),
        keyboardType: TextInputType.emailAddress,
        onChanged: (email) => _forceRebuild());
  }

  TextField _buildPasswordInput() {
    return TextField(
        key: const Key("password_input"),
        controller: _passwordController,
        enabled: !_submittedWithValidData,
        decoration: InputDecoration(
            labelText: "Password",
            errorText: !_isPasswordValid() && _submitButtonPressed
                ? "6-20 chars, uppercase, lowercase, digits"
                : null),
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        onChanged: (password) => _forceRebuild());
  }

  Center _buildLoadingCircle() {
    return const Center(
        child: SizedBox(
            height: 40, width: 40, child: CircularProgressIndicator()));
  }

  ElevatedButton _buildSubmitButton() {
    final bool buttonEnabled = !_submitButtonPressed || _isFormValid();
    return ElevatedButton(
      key: const Key("submit_button"),
      onPressed: buttonEnabled ? _submitForm : null,
      child: const Text("Register"),
    );
  }

  bool _isFormValid() {
    return _isUsernameValid() && _isEmailValid() && _isPasswordValid();
  }

  bool _isUsernameValid() {
    if (_username.length >= 3 &&
        _username.length <= 12 &&
        _username.contains(RegExp(r'^[a-zA-Z]+$'))) {
      return true;
    }
    return false;
  }

  bool _isEmailValid() {
    return isEmail(_email);
  }

  bool _isPasswordValid() {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,20}$');
    return regex.hasMatch(_password);
  }

  void _forceRebuild() {
    setState(() {});
  }
}
