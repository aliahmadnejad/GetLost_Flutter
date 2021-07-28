import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 80, right: 80),
      child: OutlineButton(
        borderSide: BorderSide(
          width: 2,
          color: Color(0xff0093B1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: _onPressed,
        child: Text(
          'NeXT',
          style: TextStyle(
            color: Color(0xff9F9F9F),
            fontFamily: "SF-Pro-Regular",
          ),
        ),
        // color: Color(0xff0093B1),
        disabledBorderColor: Color(0xff9F9F9F),
        // highlightedBorderColor: Colors.red,
      ),
    );
  }
}
