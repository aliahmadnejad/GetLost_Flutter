import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

class MenuPanel extends StatefulWidget {
  MenuPanel({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MenuPanelState();
  }
}

class MenuPanelState extends State<MenuPanel> {
  PanelController _panelController3 = new PanelController();
  double menuPageSize;

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: MenuButton(
              title: "Account",
              onPressed: () {
                applicationBloc.setSettingsPage2("account");
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
              title: "Payment",
              onPressed: () {
                applicationBloc.setSettingsPage2("payment");
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
              title: "Support/ Contact Us",
              onPressed: () {
                applicationBloc.setSettingsPage2("contact");
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
              title: "Log Out",
              onPressed: () {
                logoutPopup();
              },
            ),
          ),
        ],
      ),
    );
  }

  logoutPopup() {
    return showGeneralDialog(
      barrierLabel: "Logout",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // barrierColor: null,
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.all(0),
                margin:
                    EdgeInsets.only(top: 200, bottom: 490, left: 30, right: 30),
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
                height: 140,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 0, left: 40, right: 40),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 0.0, left: 00, right: 00),
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
                                side: BorderSide(
                                    color: Color(0xff464646), width: 1),
                              ),
                              color: Color(0xff222222),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                              child: Text(
                                "No",
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
                                side: BorderSide(
                                    color: Color(0xff464646), width: 1),
                              ),
                              color: Color(0xff6C6C6C),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                Navigator.of(context).maybePop();
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(LoggedOut());
                              },
                              child: Text(
                                "Yes",
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
      },
    );
  }
}
