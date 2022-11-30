import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../styles/themes.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return
      OutlinedButton(
        onPressed:onPressed,
        style: OutlinedButton.styleFrom(
          side:  const BorderSide(
              color: Themes.primaryColor
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
        child: const Icon(
          PhosphorIcons.plus,
          color: Colors.black87,
          size: 30,
        ),
      );


  }
}