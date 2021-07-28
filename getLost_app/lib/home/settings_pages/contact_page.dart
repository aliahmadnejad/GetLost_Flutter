import 'package:flutter/material.dart';
import 'package:getLost_app/home/settings_pages/buttons/menu_button.dart';

class ContactPage extends StatefulWidget {
  ContactPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContactPageState();
  }
}

class ContactPageState extends State<ContactPage> {
  ContactPageState();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: FlatButton(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Questions/ Comments",
                            style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontSize: 16,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "info@getlost.com",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 5, bottom: 5),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: FlatButton(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Call Us",
                            style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontSize: 16,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "+1 (800)923-3841",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 5, bottom: 5),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: FlatButton(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Career Opportunities",
                            style: TextStyle(
                              color: Color(0xff9F9F9F),
                              fontSize: 16,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "career@getlost.com",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ]));
  }
}
