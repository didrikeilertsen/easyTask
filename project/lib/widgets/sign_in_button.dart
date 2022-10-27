import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'custom_elevated_button.dart';

///Represents a widget for a login-button with an icon and text.
class SignInButton extends CustomElevatedButton {
  SignInButton({
    super.key,
    PhosphorIconData? icon,
    required String text,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black,
                size: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: "Comfortaa",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: Icon(
                  icon,
                  size: 32,
                ),
              ),
            ],
          ),
          color: Colors.white,
          onPressed: onPressed,
          height: 45.0,
          padding: 20.0,
        );
}
