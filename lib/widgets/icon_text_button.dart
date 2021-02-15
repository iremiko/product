import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const IconTextButton(
      {Key key,
      this.title,
      this.iconData,
      this.backgroundColor,
      this.textColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: textColor ?? Theme.of(context).backgroundColor,
        size: 20,
      ),
      label: Text(title,
          style:
              TextStyle(color: textColor ?? Theme.of(context).backgroundColor)),
      color: backgroundColor ?? Theme.of(context).primaryColor,
    );

  }
}
