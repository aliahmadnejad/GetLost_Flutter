import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0093B1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            child: Image(
              image: AssetImage("assets/images/LogoBlue.png"),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
