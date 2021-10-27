// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/alert_dialogs/cupertino_error.dart';
import 'package:getLost_app/home/home_page.dart';
import 'package:getLost_app/login/bloc/login_bloc.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/login/login_button.dart';
import 'package:getLost_app/login/create_account_button.dart';
// import 'package:getLost_app/home/home.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;
  bool passwordVisible = true;

  bool get isPopulated =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _usernameController.addListener(_onUsernameChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  final ThemeData themeDark = ThemeData(
    primaryColorBrightness: Brightness.light,
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (conext, state) {
        if (state.isFailure) {
          openDialog("Sign In Failed", "Your email or password is incorrect",
              "Try Again", context);
          _passwordController.clear();
          // Scaffold.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [Text('Login Failure'), Icon(Icons.error)],
          //       ),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
        }
        if (state.isSubmitting) {
          print("Logging in...");
          // Scaffold.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text("Logging in..."),
          //           CircularProgressIndicator(),
          //         ],
          //       ),
          //     ),
          //   );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) => HomePage(
          //           name: null,
          //           token: null,
          //           travelerInformation: null,
          //         )));
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.blueAccent)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 50.0),
                                // width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      keyboardAppearance: Brightness.light,
                                      controller: _usernameController,
                                      // autofocus: false,
                                      style: TextStyle(
                                          color: Color(0xff9F9F9F),
                                          fontFamily: "SF-Pro-Regular",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30),
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.person,
                                        //     color: Color(0xff9F9F9F)),
                                        // labelText: 'Username',
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                            color: Color(0xff9F9F9F),
                                            fontFamily: "SF-Pro-Regular",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),

                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 10.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff0093B1))),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autovalidateMode: AutovalidateMode.always,
                                      autocorrect: false,
                                    ),
                                    SizedBox(height: 8.0),
                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      keyboardAppearance: Brightness.light,
                                      controller: _passwordController,
                                      style: TextStyle(
                                          color: Color(0xff9F9F9F),
                                          fontFamily: "SF-Pro-Regular",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30),
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.lock,
                                        //     color: Color(0xff9F9F9F)),
                                        // labelText: 'Password',
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                            color: Color(0xff9F9F9F),
                                            fontFamily: "SF-Pro-Regular",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 10.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff0093B1))),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      obscureText: passwordVisible,
                                      autovalidateMode: AutovalidateMode.always,
                                      autocorrect: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: LoginButton(
                                // onPressed: state is! LoginLoading
                                onPressed: isLoginButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                              ),
                            )
                          ],
                        ),
                        CreateAccountButton(userRepository: _userRepository),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onUsernameChanged() {
    _loginBloc.add(UsernameChanged(username: _usernameController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}

// class LoginForm extends StatefulWidget {
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _onLoginButtonPressed() {
//       BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
//         username: _usernameController.text,
//         password: _passwordController.text,
//       ));
//     }

//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginFaliure) {
//           Scaffold.of(context).showSnackBar(SnackBar(
//             // content: Text('${state.error}'),
//             content: Text('Something is Wrong'),
//             backgroundColor: Colors.red,
//           ));
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           return Container(
//             child: Form(
//               child: Padding(
//                 padding: EdgeInsets.all(40.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     TextFormField(
//                       decoration: InputDecoration(
//                           labelText: 'username', icon: Icon(Icons.person)),
//                       controller: _usernameController,
//                     ),
//                     TextFormField(
//                       decoration: InputDecoration(
//                           labelText: 'password', icon: Icon(Icons.security)),
//                       controller: _passwordController,
//                       obscureText: true,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       height: MediaQuery.of(context).size.width * 0.22,
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 30.0),
//                         child: RaisedButton(
//                           onPressed: state is! LoginLoading
//                               ? _onLoginButtonPressed
//                               : null,
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 24.0,
//                             ),
//                           ),
//                           shape: StadiumBorder(
//                             side: BorderSide(
//                               color: Colors.black,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: state is LoginLoading
//                           ? CircularProgressIndicator()
//                           : null,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
