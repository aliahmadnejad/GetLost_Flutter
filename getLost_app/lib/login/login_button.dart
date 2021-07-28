import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // return RaisedButton(
    //   // shape: RoundedRectangleBorder(
    //   //   borderRadius: BorderRadius.circular(30.0),
    //   // ),
    //   onPressed: _onPressed,
    //   padding: EdgeInsets.all(10.0),
    //   child: Image(
    //     image: AssetImage("assets/images/LogoExMarkBlue.png"),
    //     height: MediaQuery.of(context).size.height / 20,
    //   ),
    //   // child: ImageIcon(
    //   //   AssetImage("assets/images/LogoExMarkBlue.png"),
    //   //   color: Colors.blue,
    //   // ),
    //   color: Colors.transparent,
    //   elevation: 0,
    //   // child: Text(
    //   //   'Login',
    //   //   style: TextStyle(
    //   //     color: Colors.white,
    //   //     fontFamily: "SF-Pro-Regular",
    //   //   ),
    //   // ),
    //   disabledColor: Colors.transparent,

    //   // color: Colors.green,
    // );
    // Notes 1
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      // padding: EdgeInsets.only(
      //     left: MediaQuery.of(context).size.width / 10,
      //     right: MediaQuery.of(context).size.width / 10),
      child: IconButton(
        iconSize: 50,
        disabledColor: Colors.grey,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        color: Color(0xff0093B1),
        icon: ImageIcon(
          AssetImage("assets/images/LogoExMarkBlue.png"),
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
