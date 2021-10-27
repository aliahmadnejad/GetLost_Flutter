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
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 35),
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
