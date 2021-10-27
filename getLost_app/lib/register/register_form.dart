import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/alert_dialogs/cupertino_error.dart';

import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/home/home_page.dart';
import 'package:getLost_app/register/bloc/register_bloc.dart';
import 'package:getLost_app/register/register_button.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterBloc _registerBloc;
  bool passwordVisible = true;

  bool get isPopulated =>
      _firstNameController.text.isNotEmpty &&
      // _middleNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      // _userNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _confirmEmailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool get isEmailConfirmed {
    if (_emailController.text == _confirmEmailController.text) {
      print("emails match");
      return true;
    } else {
      print("emails do NOT match");
      return false;
    }
  }

  bool get isPasswordConfirmed {
    if (_passwordController.text == _confirmPasswordController.text) {
      print("password match");
      return true;
    } else {
      print("passwords do NOT match");
      return false;
    }
  }

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid &&
        isPopulated &&
        !state.isSubmitting &&
        isEmailConfirmed &&
        isPasswordConfirmed;
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    // _userNameController.addListener(_onUsernameChanged);
    _emailController.addListener(_onEmailChanged);
    _confirmEmailController.addListener(_onConfirmEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          print("its registering...");
          // Scaffold.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text('Registering...'),
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
        if (state.isFailure) {
          openDialog("Sign Up Failed", "Your email or password is incorrect",
              "Try Again", context);
          // Scaffold.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text('Registration Failure'),
          //           Icon(Icons.error),
          //         ],
          //       ),
          //       backgroundColor: Colors.red,
          //     ),
          //   );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10, right: 50, left: 50),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        // -----------------------------------------------------------
                        // ADDED FIELDS --------------- First, Middle, and Last Name
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardAppearance: Brightness.light,
                          controller: _firstNameController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            hintText: 'First Name',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isFirstNameValid
                                ? 'Invalid First Name'
                                : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardAppearance: Brightness.light,
                          controller: _middleNameController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            hintText: 'Middle Name',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isMiddleNameValid
                                ? 'Invalid Middle Name'
                                : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          keyboardAppearance: Brightness.light,
                          controller: _lastNameController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            hintText: 'Last Name',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isLastNameValid
                                ? 'Invalid Last Name'
                                : null;
                          },
                        ),
                        SizedBox(height: 80.0),
                      ],
                    ),
                  ),
                  // -----------------------------------------------------------
                  // -----------------------------------------------------------
                  // -----------------------------------------------------------
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardAppearance: Brightness.light,
                          controller: _emailController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isEmailValid ? 'Invalid Email' : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // ADDED FIELDS --------------- CONFIRM EMAIL
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardAppearance: Brightness.light,
                          controller: _confirmEmailController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // labelText: 'Username',
                            hintText: 'Confirm Email Address',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isConfirmEmailValid
                                ? 'Invalid Confirm Email'
                                : null;
                          },
                          // validator: (String value) {
                          //   // if (value.isEmpty) {
                          //   //   return 'Please re-enter email';
                          //   // }
                          //   // print(_emailController.text);

                          //   // print(_confrimEmailController.text);

                          //   if (_emailController.text != value) {
                          //     return "email does not match";
                          //   }

                          //   return null;
                          // },
                        ),
                        SizedBox(height: 80.0),
                      ],
                    ),
                  ),
                  // -----------------------------------------------------------
                  // -----------------------------------------------------------
                  // -----------------------------------------------------------
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardAppearance: Brightness.light,
                          controller: _passwordController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.lock),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                            // suffixIcon: IconButton(
                            //     icon: passwordVisible
                            //         ? Icon(Icons.visibility)
                            //         : Icon(Icons.visibility_off),
                            //     // color: Theme.of(context).primaryColorDark,
                            //     color: Color(0xff9F9F9F),
                            //     onPressed: () {
                            //       setState(() {
                            //         passwordVisible = !passwordVisible;
                            //       });
                            //     }),
                          ),
                          obscureText: passwordVisible,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isPasswordValid
                                ? 'Invalid Password'
                                : null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        // -----------------------------------------------------------
                        // ADDED FIELDS --------------- CONFIRM PASSWORD
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.light,
                          controller: _confirmPasswordController,
                          style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                              fontSize: MediaQuery.of(context).size.width / 30),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.lock),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize:
                                    MediaQuery.of(context).size.width / 30),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff0093B1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(),
                            ),
                            // suffixIcon: IconButton(
                            //     icon: passwordVisible
                            //         ? Icon(Icons.visibility)
                            //         : Icon(Icons.visibility_off),
                            //     // color: Theme.of(context).primaryColorDark,
                            //     color: Color(0xff9F9F9F),
                            //     onPressed: () {
                            //       setState(() {
                            //         passwordVisible = !passwordVisible;
                            //       });
                            //     }),
                          ),
                          obscureText: passwordVisible,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (_) {
                            return !state.isConfirmPasswordValid
                                ? 'Invalid Confirm Password'
                                : null;
                          },
                        ),
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                        // -----------------------------------------------------------
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 90),
                    alignment: Alignment.bottomCenter,
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.blueAccent)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RegisterButton(
                          onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    _registerBloc.add(
      UsernameChanged(userName: _userNameController.text),
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onConfirmEmailChanged() {
    _registerBloc.add(
      ConfirmEmailChanged(
          email: _emailController.text,
          confirmEmail: _confirmEmailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.add(
      ConfirmPasswordChanged(
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
          firstName: _firstNameController.text,
          middleName: _middleNameController.text,
          lastName: _lastNameController.text,
          userName: _emailController.text,
          // userName: _userNameController.text,
          email: _emailController.text,
          // confirmEmail: _confirmEmailController.text,
          password: _passwordController.text),
    );
  }
}
