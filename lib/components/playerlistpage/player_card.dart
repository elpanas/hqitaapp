import 'package:hqitaapp/constants.dart'
    show kPlayerCardLeadingIcon, kPlayerCardMargin;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Card,
        Icon,
        Icons,
        ListTile,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        UniqueKey,
        VoidCallback,
        Widget;

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    required UniqueKey key,
    required this.title,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap, onLongPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: kPlayerCardMargin,
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 21.0),
        ),
        subtitle: Row(
          children: const [
            kPlayerCardLeadingIcon,
            SizedBox(width: 3),
            Text(
              'qui vanno i metri', // TODO inserire i metri
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
