import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String title;

  MenuButton({Key key, VoidCallback onPressed, this.title})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            style: TextStyle(
              color: Color(0xff9F9F9F),
              fontSize: 16,
              fontFamily: "SF-Pro-Medium",
            ),
          ),
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
