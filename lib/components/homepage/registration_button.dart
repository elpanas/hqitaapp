import 'package:hqitaapp/constants.dart' show kLogInOutButtonStyle;
import 'package:hqitaapp/views/registration.dart';
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
class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pushNamed(context, RegistrationPage.id),
        style: kLogInOutButtonStyle,
        child: const Icon(Icons.how_to_reg_outlined),
      ),
    );
  }
}
