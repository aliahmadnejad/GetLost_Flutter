import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/guest_home/bloc/guest_home_bloc.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/model/api_model.dart';
import 'dart:typed_data';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/user_model.dart';
import 'package:getLost_app/register/register_screen.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

openPopup(
    BuildContext context,
    HostelDetail hostelData,
    BitmapDescriptor icon,
    var markerId,
    LatLng markerLocation,
    panelController,
    ValueChanged updateSearchBar,
    UserRepository userRepository) async {
  print("Open popup is running");
  final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
  final guestApplicationBloc =
      Provider.of<GuestApplicationBloc>(context, listen: false);
  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    // barrierColor: Colors.black.withOpacity(0.5),
    barrierColor: null,
    transitionDuration: Duration(milliseconds: 200),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Color(0xffFBF9F8),
                border: Border.all(color: Color(0xffE9E7E3), width: 2),
                borderRadius: BorderRadius.circular(20),
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
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: Text(
                                "${hostelData.hostel.hostelName}",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black,
                                  fontFamily: "SF-Pro-SB",
                                ),
                              ),
                            ),
                          ),
                          ButtonTheme(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
                              child: FlatButton(
                                height: 25,
                                minWidth: 15,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xff707070),
                                  size: 20.0,
                                ),
                                shape: CircleBorder(),
                                color: Color(0xffECEBE9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 39.0, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Total Price:",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontFamily: "SF-Pro-Regular",
                                  ),
                                ),
                                Text(
                                  "${toCurrencySymbol(hostelData.currency)} ${hostelData.price}",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                    fontFamily: "SF-Pro-SB",
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 25.0, right: 0.0),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width / 2.2,
                              height: MediaQuery.of(context).size.height / 16,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: (hostelData.avaliability >= 1)
                                  ? Color(0xff0093B1)
                                  : Color(0xff707070),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return RegisterScreen(
                                      userRepository: userRepository);
                                }));
                              },
                              child: Text(
                                "Book!",
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontFamily: "SF-Pro-Medium",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.only(bottom: 0.0, left: 0),
                            child: FlatButton(
                              onPressed: () {
                                guestApplicationBloc.setBookingPanelPage(true);
                                applicationBloc.setBookingPanelPage(
                                    true, false);
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                if (panelController.isPanelClosed) {
                                  panelController.open();
                                }
                                // else {
                                //   panelController.close();
                                // }
                              },
                              child: Text(
                                "more \u2228",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0xff8B8985),
                                  fontFamily: "SF-Pro-Regular",
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  ).then((value) {
    print("the dialog has closed bro");
    updateSearchBar(true);
  });
}
