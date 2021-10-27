import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15, bottom: 15, left: 80, right: 80),
      child:
          // OutlinedButton(
          //   onPressed: _onPressed,
          //   style: OutlinedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //       side: BorderSide(
          //         width: 2,
          //         color: Color(0xff0093B1),
          //       )),
          //   child: Text(
          //     'NeXT',
          //     style: TextStyle(
          //       color: Color(0xff9F9F9F),
          //       fontFamily: "SF-Pro-Regular",
          //     ),
          //   ),
          // )
          ButtonTheme(
        height: 30, //MediaQuery.of(context).size.height / 27,
        child: OutlineButton(
          padding: EdgeInsets.zero,
          borderSide: BorderSide(
            width: 1.2,
            color: Color(0xff0093B1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
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
      ),
    );
  }
}
