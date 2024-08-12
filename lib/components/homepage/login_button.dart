import 'package:hqitaapp/constants.dart' show kLogInOutButtonStyle;
import 'package:hqitaapp/views/login.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Expanded,
        Icon,
        Icons,
        Navigator,
        OutlinedButton,
        StatelessWidget,
        Widget;

// ignore: use_key_in_widget_constructors
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pushNamed(context, LoginPage.id),
        style: kLogInOutButtonStyle,
        child: const Icon(Icons.login_outlined),
      ),
    );
  }
}
