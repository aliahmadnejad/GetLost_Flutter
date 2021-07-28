import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:provider/provider.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';

class LanguageCountryPopup extends StatefulWidget {
  final String token;
  LanguageCountryPopup({
    Key key,
    @required this.token,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LanguageCountryPopupState(token: token);
  }
}

class LanguageCountryPopupState extends State<LanguageCountryPopup> {
  final String token;
  LanguageCountryPopupState({this.token});

  final TextEditingController _countryController = TextEditingController();

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
            margin: EdgeInsets.only(top: 200, bottom: 430, left: 30, right: 30),
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
            height: 275,
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
                      "Language",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  enabled: true,
                  readOnly: true,
                  // controller: _emergencyNameController,
                  // autofocus: false,
                  style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontFamily: "SF-Pro-Regular",
                      fontSize: 16),
                  decoration: InputDecoration(
                    // labelText: 'Username',
                    hintText: 'English',
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
                      "Country or Region",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                          fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                  decoration: BoxDecoration(
                    // color: Color(0xffFBF9F8),
                    border: Border.all(color: Color(0xffE4E4E4), width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CountryCodePicker(
                    padding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                    onChanged: (e) {
                      print(e.name);
                      print(e.code);
                      _countryController.text = e.code.toString();
                      print("code is ${_countryController.text}");
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: '${applicationBloc.travelerInfo.country}',
                    // favorite: ['+39', 'FR'],
                    // countryFilter: ['IT', 'FR'],
                    showFlagDialog: true,
                    showFlagMain: true,
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    comparator: (a, b) => b.name.compareTo(a.name),
                    //Get the country information relevant to the initial selection
                    onInit: (code) => print(
                        "on init ${code.name} ${code.dialCode} ${code.name}"),
                    alignLeft: true,
                    hideSearch: true,
                    flagWidth: 20.0,
                    dialogSize: Size(MediaQuery.of(context).size.width - 100,
                        MediaQuery.of(context).size.height - 100),
                    textOverflow: TextOverflow.ellipsis,
                    textStyle: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 16),
                  ),
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
                            // _firstNameController.clear();
                            // _middleNameController.clear();
                            // _lastNameController.clear();
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
                            if (_countryController.text.isEmpty) {
                              print("its empty");
                            } else {
                              print("its not empty");
                              TravelerSignup travelerCountry = TravelerSignup(
                                  country: _countryController.text);
                              changeTravelerCountry(
                                  applicationBloc.travelerInfo,
                                  travelerCountry,
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
