// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getLost_app/practice/home_page2.dart';
// import 'package:getLost_app/login/bloc/login_bloc.dart';
// import 'package:getLost_app/repository/user_repository.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
// import 'package:getLost_app/login/login_button.dart';
// import 'package:getLost_app/login/create_account_button.dart';
// // import 'package:getLost_app/home/home.dart';

// class LoginForm extends StatefulWidget {
//   final UserRepository _userRepository;
//   LoginForm({Key key, @required UserRepository userRepository})
//       : assert(userRepository != null),
//         _userRepository = userRepository,
//         super(key: key);
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   LoginBloc _loginBloc;

//   UserRepository get _userRepository => widget._userRepository;
//   bool passwordVisible = true;

//   bool get isPopulated =>
//       _usernameController.text.isNotEmpty &&
//       _passwordController.text.isNotEmpty;

//   bool isLoginButtonEnabled(LoginState state) {
//     return state.isFormValid && isPopulated && !state.isSubmitting;
//   }

//   @override
//   void initState() {
//     super.initState();
//     passwordVisible = true;
//     _loginBloc = BlocProvider.of<LoginBloc>(context);
//     _usernameController.addListener(_onUsernameChanged);
//     _passwordController.addListener(_onPasswordChanged);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginBloc, LoginState>(
//       listener: (conext, state) {
//         if (state.isFailure) {
//           Scaffold.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [Text('Login Failure'), Icon(Icons.error)],
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//             );
//         }
//         if (state.isSubmitting) {
//           Scaffold.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               SnackBar(
//                 content: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Logging in..."),
//                     CircularProgressIndicator(),
//                   ],
//                 ),
//               ),
//             );
//         }
//         if (state.isSuccess) {
//           BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (BuildContext context) => HomePage(
//                     name: null,
//                   )));
//           // Navigator.of(context).pop();
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(60.0),
//               child: Form(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.center,
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       TextFormField(
//                         keyboardAppearance: Brightness.light,
//                         controller: _usernameController,
//                         // autofocus: false,
//                         decoration: InputDecoration(
//                           icon: Icon(Icons.person, color: Color(0xff9F9F9F)),
//                           // labelText: 'Username',
//                           hintText: 'Username',
//                           hintStyle: TextStyle(
//                               color: Color(0xff9F9F9F),
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: MediaQuery.of(context).size.width / 30),
//                           // labelStyle: TextStyle(
//                           //   color: Color(0xff9F9F9F),
//                           //   fontFamily: "SF-Pro-Regular",
//                           //   fontSize: MediaQuery.of(context).size.width / 10,
//                           // ),
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 10.0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide(),
//                           ),
//                           // enabledBorder: UnderlineInputBorder(
//                           //     borderSide:
//                           //         BorderSide(color: Color(0xff9F9F9F))),
//                           // focusedBorder: UnderlineInputBorder(
//                           //     borderSide:
//                           //         BorderSide(color: Color(0xff9F9F9F)))
//                         ),
//                         keyboardType: TextInputType.text,
//                         autovalidateMode: AutovalidateMode.always,
//                         autocorrect: false,
//                       ),
//                       SizedBox(height: 8.0),
//                       TextFormField(
//                         keyboardAppearance: Brightness.light,
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           icon: Icon(Icons.lock, color: Color(0xff9F9F9F)),
//                           // labelText: 'Password',
//                           hintText: 'Password',
//                           hintStyle: TextStyle(
//                               color: Color(0xff9F9F9F),
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: MediaQuery.of(context).size.width / 30),
//                           isDense: true,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 10.0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide(),
//                           ),
//                           // enabledBorder: UnderlineInputBorder(
//                           //     borderSide:
//                           //         BorderSide(color: Color(0xff9F9F9F))),
//                           // focusedBorder: UnderlineInputBorder(
//                           //     borderSide:
//                           //         BorderSide(color: Color(0xff9F9F9F))),
//                           // suffixIcon: IconButton(
//                           //   icon: passwordVisible
//                           //       ? Icon(Icons.visibility)
//                           //       : Icon(Icons.visibility_off),
//                           //   // color: Theme.of(context).primaryColorDark,
//                           //   color: Color(0xff9F9F9F),
//                           //   iconSize: 20,
//                           //   onPressed: () {
//                           //     setState(() {
//                           //       passwordVisible = !passwordVisible;
//                           //     });
//                           //   },
//                           // )
//                         ),
//                         obscureText: passwordVisible,
//                         autovalidateMode: AutovalidateMode.always,
//                         autocorrect: false,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         child: Column(
//                           // crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: <Widget>[
//                             LoginButton(
//                               // onPressed: state is! LoginLoading
//                               onPressed: isLoginButtonEnabled(state)
//                                   ? _onFormSubmitted
//                                   : null,
//                             ),
//                             CreateAccountButton(
//                                 userRepository: _userRepository),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _onUsernameChanged() {
//     _loginBloc.add(UsernameChanged(username: _usernameController.text));
//   }

//   void _onPasswordChanged() {
//     _loginBloc.add(PasswordChanged(password: _passwordController.text));
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _onFormSubmitted() {
//     _loginBloc.add(
//       LoginWithCredentialsPressed(
//         username: _usernameController.text,
//         password: _passwordController.text,
//       ),
//     );
//   }
// }

// // class LoginForm extends StatefulWidget {
// //   @override
// //   State<LoginForm> createState() => _LoginFormState();
// // }

// // class _LoginFormState extends State<LoginForm> {
// //   final _usernameController = TextEditingController();
// //   final _passwordController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     _onLoginButtonPressed() {
// //       BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
// //         username: _usernameController.text,
// //         password: _passwordController.text,
// //       ));
// //     }

// //     return BlocListener<LoginBloc, LoginState>(
// //       listener: (context, state) {
// //         if (state is LoginFaliure) {
// //           Scaffold.of(context).showSnackBar(SnackBar(
// //             // content: Text('${state.error}'),
// //             content: Text('Something is Wrong'),
// //             backgroundColor: Colors.red,
// //           ));
// //         }
// //       },
// //       child: BlocBuilder<LoginBloc, LoginState>(
// //         builder: (context, state) {
// //           return Container(
// //             child: Form(
// //               child: Padding(
// //                 padding: EdgeInsets.all(40.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: <Widget>[
// //                     TextFormField(
// //                       decoration: InputDecoration(
// //                           labelText: 'username', icon: Icon(Icons.person)),
// //                       controller: _usernameController,
// //                     ),
// //                     TextFormField(
// //                       decoration: InputDecoration(
// //                           labelText: 'password', icon: Icon(Icons.security)),
// //                       controller: _passwordController,
// //                       obscureText: true,
// //                     ),
// //                     Container(
// //                       width: MediaQuery.of(context).size.width * 0.85,
// //                       height: MediaQuery.of(context).size.width * 0.22,
// //                       child: Padding(
// //                         padding: EdgeInsets.only(top: 30.0),
// //                         child: RaisedButton(
// //                           onPressed: state is! LoginLoading
// //                               ? _onLoginButtonPressed
// //                               : null,
// //                           child: Text(
// //                             'Login',
// //                             style: TextStyle(
// //                               fontSize: 24.0,
// //                             ),
// //                           ),
// //                           shape: StadiumBorder(
// //                             side: BorderSide(
// //                               color: Colors.black,
// //                               width: 2,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     Container(
// //                       child: state is LoginLoading
// //                           ? CircularProgressIndicator()
// //                           : null,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
