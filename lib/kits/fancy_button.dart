import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  Widget suffix;
  IconData iconData;
  final GestureTapCallback onPressed;
  FancyButton({@required this.suffix, @required this.iconData, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.deepOrangeAccent,
      splashColor: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.amber,
            ),
            SizedBox(
              width: 8.0,
            ),
            suffix
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}