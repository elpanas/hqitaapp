import 'package:hqitaapp/constants.dart' show kPlayerMargin, kPlayerTextStyle;
import 'package:flutter/material.dart'
    show Alignment, BuildContext, Container, StatelessWidget, Text, Widget;
import 'package:easy_localization/easy_localization.dart';

// ignore: use_key_in_widget_constructors
class PlayerSubTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: kPlayerMargin,
      child: Text(
        'player_subtitle',
        style: kPlayerTextStyle.copyWith(fontSize: 20),
      ).tr(),
    );
  }
}
