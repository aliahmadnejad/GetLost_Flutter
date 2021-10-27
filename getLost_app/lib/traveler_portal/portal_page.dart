// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:getLost_app/guest_home/guest_home_page.dart';
import 'package:getLost_app/login/login_screen.dart';
import 'package:getLost_app/register/register_screen.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:getLost_app/traveler_portal/signin_button.dart';

class TravelerPortal extends StatelessWidget {
  final UserRepository _userRepository;

  TravelerPortal({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0093B1),
        body: Stack(
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(90.0),
            //   ),
            //   child:
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.16,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                child: Image(
                  image: AssetImage("assets/images/LogoBlue.png"),
                  color: Colors.white,
                ),
              ),
            ),
            // ),
            Container(
                // padding: EdgeInsets.only(
                //     top: MediaQuery.of(context).size.height * 0.1),
                child: Center(
                    child: Padding(
              padding: EdgeInsets.all(60.0),
              // child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //FIX: center the row!!!
                          children: <Widget>[
                            Text(
                              "I'm ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 16,
                                fontFamily: "SF-Pro-SB",
                              ),
                            ),
                            Text(
                              "New",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 16,
                                fontFamily: "SF-Pro-Black",
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RegisterScreen(
                                userRepository: _userRepository);
                          }));
                        }),
                  ),
                  Container(
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //FIX: center the row!!!
                          children: <Widget>[
                            Text(
                              "I'm a ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 16,
                                fontFamily: "SF-Pro-SB",
                              ),
                            ),
                            Text(
                              "Guest",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 16,
                                fontFamily: "SF-Pro-Black",
                              ),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GuestHomePage(
                                userRepository: _userRepository);
                          }));
                        }),
                  ),
                  // const SizedBox(height: 200.0),
                ],
              ),
              // ),
            ))),
            Container(
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(60.0),
                        // child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(30),
                              padding: EdgeInsets.all(20),
                              child:
                                  SigninButton(userRepository: _userRepository),
                            ),
                          ],
                        ))))
          ],
        ));
  }
}
