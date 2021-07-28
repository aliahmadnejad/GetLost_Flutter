import 'package:flutter/material.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/settings_pages/account_pages/contact_popup.dart';
import 'package:getLost_app/home/settings_pages/account_pages/emergency_contact_popup.dart';
import 'package:getLost_app/home/settings_pages/account_pages/language_country_popup.dart';
import 'package:getLost_app/home/settings_pages/account_pages/name_popup.dart';
import 'package:getLost_app/home/settings_pages/account_pages/password_popup.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  final String token;
  final TravelerSignup travelerInformation;
  AccountPage({
    Key key,
    @required this.token,
    @required this.travelerInformation,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountPageState(
        token: token, travelerInformation: travelerInformation);
  }
}

class AccountPageState extends State<AccountPage> {
  final String token;
  TravelerSignup travelerInformation;
  AccountPageState({
    this.token,
    this.travelerInformation,
  });

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Padding(
        padding: const EdgeInsets.only(top: 50, left: 0, right: 0),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: MenuButton(
                  title: "Names",
                  onPressed: () {
                    // _firstNameController.clear();
                    // _middleNameController.clear();
                    // _lastNameController.clear();
                    namePopup(applicationBloc);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: MenuButton(
                  title: "Email & Phone Number",
                  onPressed: () {
                    // _emailController.clear();
                    // _phoneController.clear();
                    contactPopup(applicationBloc);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: MenuButton(
                  title: "Emergency Contact",
                  onPressed: () {
                    // _emergencyNameController.clear();
                    // _emergencyRelationController.clear();
                    // _emergencyPhoneController.clear();
                    // _emergencyEmailController.clear();
                    emergencyContactPopup(applicationBloc);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: MenuButton(
                  title: "Language/Country",
                  onPressed: () {
                    // _countryController.clear();
                    // // _emergencyPhoneController.clear();
                    languageCountryPopup(applicationBloc);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: MenuButton(
                  title: "Change Password",
                  onPressed: () {
                    // _oldPasswordController.clear();
                    // _newPasswordController.clear();
                    // _newPassword2Controller.clear();
                    passwordChangePopup(applicationBloc);
                  },
                ),
              ),
            ]));
  }

  namePopup(app) async {
    await app.getTravelerInfo();
    return showGeneralDialog(
        barrierLabel: "Name",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        // barrierColor: null,
        transitionDuration: Duration(milliseconds: 400),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return NamePopup(
            token: token,
          );
        }).then((value) {
      print("the dialog has closed bro");
      // get updated traveler information when it closes
      // app.getTravelerInfo();
      print("${app.travelerInfo.firstName}");
    });
  }

  contactPopup(app) async {
    await app.getTravelerInfo();
    return showGeneralDialog(
      barrierLabel: "Contact",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // barrierColor: null,
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return ContactPopup(token: token);
      },
    ).then((value) {
      print("the dialog has closed bro");
    });
  }

  emergencyContactPopup(app) async {
    await app.getTravelerInfo();
    return showGeneralDialog(
      barrierLabel: "EmergContact",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // barrierColor: null,
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return EmergencyContactPopup(token: token);
      },
    ).then((value) {
      print("the dialog has closed bro");
    });
  }

  languageCountryPopup(app) async {
    await app.getTravelerInfo();
    return showGeneralDialog(
      barrierLabel: "LangAndCountry",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // barrierColor: null,
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return LanguageCountryPopup(token: token);
      },
    ).then((value) {
      print("the dialog has closed bro");
    });
  }

  passwordChangePopup(app) async {
    await app.getTravelerInfo();
    return showGeneralDialog(
      barrierLabel: "PasswordChange",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // barrierColor: null,
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return PasswordPopup(token: token);
      },
    ).then((value) {
      print("the dialog has closed bro");
    });
  }
}
