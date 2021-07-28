import 'package:flutter/material.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:getLost_app/login/login_screen.dart';

class SigninButton extends StatelessWidget {
  final UserRepository _userRepository;

  SigninButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width / 26,
            fontFamily: "SF-Pro-Bold",
            decoration: TextDecoration.underline,
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new LoginScreen(userRepository: _userRepository);
          }));
        });
  }
}
