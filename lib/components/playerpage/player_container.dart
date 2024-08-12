import 'package:hqitaapp/constants.dart'
    show
        kPlayerMargin,
        kPlayerOpacTextStyle,
        kPlayerTextStyle,
        kPlayerTitleDecoration,
        kV30Padding;
import 'package:flutter/material.dart'
    show
        Alignment,
        BuildContext,
        Color,
        Column,
        Container,
        Expanded,
        Icon,
        IconData,
        SizedBox,
        StatelessWidget,
        Text,
        TextButton,
        VoidCallback,
        Widget;

class PlayerContainer extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const PlayerContainer({
    required this.title,
    required this.colour,
    required this.info,
    required this.icon,
    this.onPressed,
  });

  final Color colour;
  final String title, info;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          margin: kPlayerMargin,
          padding: kV30Padding,
          decoration: kPlayerTitleDecoration,
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                icon,
                color: colour,
                size: 30.0,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: kPlayerOpacTextStyle,
              ),
              const SizedBox(height: 20),
              Text(
                info,
                style: kPlayerTextStyle.copyWith(fontSize: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
