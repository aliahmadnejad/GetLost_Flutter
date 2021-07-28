import 'package:flutter/material.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:provider/provider.dart';

class EmergencyContactPopup extends StatefulWidget {
  final String token;
  EmergencyContactPopup({
    Key key,
    @required this.token,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmergencyContactPopupState(token: token);
  }
}

class EmergencyContactPopupState extends State<EmergencyContactPopup> {
  final String token;
  EmergencyContactPopupState({this.token});

  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _emergencyRelationController =
      TextEditingController();
  final TextEditingController _emergencyEmailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(top: 200, bottom: 315, left: 30, right: 30),
            decoration: BoxDecoration(
              color: Color(0xffFBF9F8),
              border: Border.all(color: Color(0xffE9E7E3), width: 2),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 6.0, // soften the shadow
                  spreadRadius: 2.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    5.0, // Move to bottom 10 Vertically
                  ),
                ),
              ],
            ),
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 10, left: 40, right: 40),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Emergency Contact Name",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  controller: _emergencyNameController,
                  // autofocus: false,
                  style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontFamily: "SF-Pro-Regular",
                      fontSize: 16),
                  decoration: InputDecoration(
                    // labelText: 'Username',
                    hintText: '${applicationBloc.travelerInfo.emergencyName}',
                    hintStyle: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 16),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff0093B1))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xffE4E4E4))),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Relation",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  controller: _emergencyRelationController,
                  // autofocus: false,
                  style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontFamily: "SF-Pro-Regular",
                      fontSize: 16),
                  decoration: InputDecoration(
                    // labelText: 'Username',
                    hintText:
                        '${applicationBloc.travelerInfo.emergencyRelation}',
                    hintStyle: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 16),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff0093B1))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xffE4E4E4))),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Phone",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  controller: _emergencyPhoneController,
                  // autofocus: false,
                  style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontFamily: "SF-Pro-Regular",
                      fontSize: 16),
                  decoration: InputDecoration(
                    // labelText: 'Username',
                    hintText: '${applicationBloc.travelerInfo.emergencyPhone}',
                    hintStyle: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 16),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff0093B1))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xffE4E4E4))),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  controller: _emergencyEmailController,
                  // autofocus: false,
                  style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontFamily: "SF-Pro-Regular",
                      fontSize: 16),
                  decoration: InputDecoration(
                    // labelText: 'Username',
                    hintText: '${applicationBloc.travelerInfo.emergencyEmail}',
                    hintStyle: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 16),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff0093B1))),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xffE4E4E4))),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 0.0, left: 00, right: 00),
                  child: Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 7.0),
                        child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width / 4.5,
                          height: MediaQuery.of(context).size.height / 40,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                            side:
                                BorderSide(color: Color(0xff464646), width: 1),
                          ),
                          color: Color(0xff222222),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 13.0,
                              // color: Colors.black,
                              fontFamily: "SF-Pro-bold",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
                        child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width / 4.5,
                          height: MediaQuery.of(context).size.height / 40,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                            side:
                                BorderSide(color: Color(0xff464646), width: 1),
                          ),
                          color: Color(0xff6C6C6C),
                          textColor: Colors.white,
                          onPressed: () {
                            if (_emergencyEmailController.text.isEmpty &&
                                _emergencyNameController.text.isEmpty &&
                                _emergencyPhoneController.text.isEmpty &&
                                _emergencyRelationController.text.isEmpty) {
                              print("its empty");
                            } else {
                              TravelerSignup emergencyContacts = TravelerSignup(
                                  emergencyName: _emergencyNameController.text,
                                  emergencyRelation:
                                      _emergencyRelationController.text,
                                  emergencyPhone:
                                      _emergencyPhoneController.text,
                                  emergencyEmail:
                                      _emergencyEmailController.text);
                              changeTravelerEmergencyContacts(
                                  applicationBloc.travelerInfo,
                                  emergencyContacts,
                                  token);
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 13.0,
                              // color: Colors.black,
                              fontFamily: "SF-Pro-Bold",
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
