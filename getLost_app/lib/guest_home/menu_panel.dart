import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getLost_app/bloc/authentication_bloc.dart';
import 'package:getLost_app/guest_home/bloc/guest_home_bloc.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';
import 'package:getLost_app/login/login_screen.dart';
import 'package:getLost_app/register/register_screen.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

class MenuPanel extends StatefulWidget {
  final UserRepository _userRepository;
  MenuPanel({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MenuPanelState(userRepository: _userRepository);
  }
}

class MenuPanelState extends State<MenuPanel> {
  final UserRepository userRepository;
  PanelController _panelController3 = new PanelController();
  double menuPageSize;

  MenuPanelState({this.userRepository});

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<GuestApplicationBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 5, right: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: MenuButton(
              title: "Create Account",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return RegisterScreen(userRepository: userRepository);
                }));
                // applicationBloc.setSettingsPage2("account");
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
              title: "Login",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LoginScreen(userRepository: userRepository);
                }));
                // applicationBloc.setSettingsPage2("payment");
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
              title: "Back",
              onPressed: () {
                Navigator.of(context).pop();
                // applicationBloc.setSettingsPage2("contact");
              },
            ),
          ),
        ],
      ),
    );
  }
}
