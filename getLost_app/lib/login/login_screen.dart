import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/repository/user_repository.dart';

// import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/login/bloc/login_bloc.dart';
import 'package:getLost_app/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Color(0xff9F9F9F)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // backgroundColor: Color(0xff0093B1),
      backgroundColor: Colors.white,
      body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.16,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                child: Image(
                  image: AssetImage("assets/images/LogoBlue.png"),
                  color: Color(0xff9F9F9F),
                ),
              ),
              Container(
                // decoration: BoxDecoration(
                //   color: Colors.yellow,
                //   border: Border.all(color: Colors.black),
                // ),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: LoginForm(userRepository: _userRepository),
              ),
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
                                // decoration: BoxDecoration(
                                //   color: Colors.yellow,
                                //   border: Border.all(color: Colors.black),
                                // ),
                                // alignment: Alignment.bottomCenter,
                                child: FlatButton(
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                        color: Color(0xff9F9F9F),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26,
                                        fontFamily: "SF-Pro-Regular",
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onPressed: () {}),
                              ),
                            ],
                          ))))
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: <Widget>[
              //     ClipRRect(
              //       borderRadius:
              //           BorderRadius.only(topRight: Radius.circular(150.0)),
              //       child: Container(
              //         decoration: BoxDecoration(color: Colors.red),
              //         height: MediaQuery.of(context).size.height * 0.07,
              //       ),
              //     )
              //   ],
              // )
            ],
          )),
    );
  }
}

// class LoginPage extends StatelessWidget {
//   final UserRepository userRepository;

//   LoginPage({Key key, @required this.userRepository})
//       : assert(userRepository != null),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login | Home Hub'),
//       ),
//       body: BlocProvider(
//         create: (context) {
//           return LoginBloc(
//             authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
//             userRepository: userRepository,
//           );
//         },
//         child: LoginForm(),
//       ),
//     );
//   }
// }
