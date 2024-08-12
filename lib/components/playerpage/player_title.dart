import 'package:hqitaapp/constants.dart'
    show
        kPlayerMargin,
        kPlayerTextStyle,
        kPlayerTitleDecoration,
        kPlayerTitlePadding;
import 'package:flutter/material.dart'
    show Alignment, BuildContext, Container, StatelessWidget, Text, Widget;

class PlayerTitle extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const PlayerTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kPlayerMargin,
      padding: kPlayerTitlePadding,
      decoration: kPlayerTitleDecoration,
      alignment: Alignment.center,
      child: Text(
        title,
        style: kPlayerTextStyle.copyWith(fontSize: 30),
      ),
    );
  }
}
