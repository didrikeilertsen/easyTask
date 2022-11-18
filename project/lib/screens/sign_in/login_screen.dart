import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../services/auth.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key, required this.auth}) : super(key: key);

  final Auth auth;

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _submittedWithValidData = false;
  bool _submitButtonPressed = false;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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

  void _submitForm() async{
    setState(() {
      _submitButtonPressed = true;
      _submittedWithValidData = _isFormValid();
    });
    if (_isFormValid()) {
      try {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      }
      catch (e) {
        print(e.toString());
      }
      finally {
        Navigator.of(context).pop();
      }
    }
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
      child: const Text("Log in"),
    );
  }

  bool _isFormValid() {
    return _isEmailValid() && _isPasswordValid();
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
