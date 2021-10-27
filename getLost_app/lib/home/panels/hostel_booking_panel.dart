import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getLost_app/alert_dialogs/cupertino_error.dart';
import 'package:getLost_app/api_connection/hostel_api_connection.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';

class HostelBookingPanel extends StatefulWidget {
  final HostelDetail hostelInfo;
  final TravelerSignup travelerInfo;
  final TravelerStripeInfo travelerStripeInfo;
  final DateTime currentDateTime;
  final PanelController panelController;

  HostelBookingPanel({
    Key key,
    @required this.hostelInfo,
    @required this.travelerInfo,
    @required this.travelerStripeInfo,
    @required this.currentDateTime,
    @required this.panelController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HostelBookingPanelState(
      hostelInfo: hostelInfo,
      travelerInfo: travelerInfo,
      travelerStripeInfo: travelerStripeInfo,
      currentDateTime: currentDateTime,
      panelController: panelController,
    );
  }
}

class HostelBookingPanelState extends State<HostelBookingPanel> {
  HostelDetail hostelInfo;
  TravelerSignup travelerInfo;
  TravelerStripeInfo travelerStripeInfo;
  DateTime currentDateTime;
  PanelController panelController;
  HostelBookingPanelState({
    this.hostelInfo,
    this.travelerInfo,
    this.travelerStripeInfo,
    this.currentDateTime,
    this.panelController,
  });

  Reservation reservation;
  var stripeCharge;

  void bookReservation(HostelDetail hostel, TravelerSignup traveler) {
    reservation = Reservation(
        hostelId: hostel.hostel.id,
        travelerId: traveler.id,
        // isCheckedIn: false, // REMOVE
        isCheckedOut: false,
        isConfirmed: false);
    postReservation(reservation);
  }

  void chargeTraveler(HostelDetail hostel, TravelerSignup traveler, provider) {
    stripeCharge = StripeService.chargeCard(
        amount: hostel.price,
        currency: hostel.currency,
        card: provider.stripeCustomerDefaultCard,
        hostelId: hostel.hostel.stripeId,
        travelerId: traveler.stripeId);
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    setState(() {
      applicationBloc.getSelectedHostelInfo(hostelInfo);
      hostelInfo = applicationBloc.hostelInfo;
    });
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 0, right: 20),
                    child: Text(
                      "${hostelInfo.hostel.hostelName}",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontFamily: "SF-Pro-SB",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50, bottom: 50, left: 30, right: 30),
                child: Container(
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE9E7E3), width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, bottom: 30),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Arrival:   ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                          Text(
                            "${getDateAndDay(currentDateTime)['todayDay']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "${getDateAndDay(currentDateTime)['todayDate']}",
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Colors.black,
                        fontFamily: "SF-Pro-Medium",
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 0, left: 20, right: 20),
                        child: Divider(
                          thickness: 2,
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, bottom: 30),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Departure:   ",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                          Text(
                            "${getDateAndDay(currentDateTime)['tomorrowDay']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        "${getDateAndDay(currentDateTime)['tomorrowDate']}",
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.black,
                          fontFamily: "SF-Pro-Medium",
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 30),
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        "Your Total:  ",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: "SF-Pro-Regular",
                        ),
                      ),
                      Text(
                        "${hostelInfo.currency}${hostelInfo.price}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: "SF-Pro-SB",
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20),
                child: Container(
                    child: Center(
                        child: Text(
                  "Confrim today's Booking?",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontFamily: "SF-Pro-Regular",
                  ),
                ))),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 120.0, right: 120.0),
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width / 2.2,
                  height: MediaQuery.of(context).size.height / 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Color(0xff0093B1),
                  textColor: Colors.white,
                  onPressed: (hostelInfo.avaliability >= 1)
                      ? () {
                          if (travelerStripeInfo.defaultSource != null) {
                            bookReservation(hostelInfo, travelerInfo);
                            chargeTraveler(
                                hostelInfo, travelerInfo, applicationBloc);
                            panelController.close();
                            hostelConfirmedPage();
                          } else {
                            print(
                                "there is no card connected to your account yet");
                            openDialog(
                                "No Card Connected",
                                "There is no card connected to your account, please go to your menu and add a new card",
                                "Ok",
                                context);
                          }
                        }
                      : () {
                          print("Sorry, the Hostel has no Avaliable rooms");
                          openDialog(
                              "No More Avaliability",
                              "Sorry, this hostel is fully booked",
                              "Ok",
                              context);
                        },
                  child: Text(
                    "Confirm!",
                    style: TextStyle(
                      fontSize: 26.0,
                      // color: Colors.black,
                      fontFamily: "SF-Pro-Medium",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xff9F9F9F),
                      fontSize: MediaQuery.of(context).size.width / 26,
                      fontFamily: "SF-Pro-Bold",
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    applicationBloc.setBookingPanelPage(true, false);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, bottom: 0, left: 25, right: 25),
                child: Container(
                  child: Text(
                    "*All 'Avaliable Beds' are Co-ed beds. It is at the Hostels discretion to decide in what co-ed bed you will be residing and in which co-ed room",
                    softWrap: true,
                    style: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontFamily: "SF-Pro-Regular",
                        fontSize: 11),
                  ),
                ),
              )
            ]));
  }

  hostelConfirmedPage() {
    print("HostelConfirmPage");
    return showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
              alignment: Alignment.center,
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    // // margin: EdgeInsets.only(
                    //     top: 50, bottom: 50, left: 12, right: 12),
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 10),
                          child: Center(
                              child: Icon(Icons.check_circle,
                                  size: 120, color: Color(0xff0B93B1))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Center(
                              child: Text(
                            "Confirmed!",
                            style: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-SB",
                                fontSize: 36),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Center(
                              child: Text("Your stay with:",
                                  style: TextStyle(
                                      color: Color(0xff9F9F9F),
                                      fontFamily: "SF-Pro-Medium",
                                      fontSize: 18))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Center(
                              child: Text("${hostelInfo.hostel.hostelName}",
                                  style: TextStyle(
                                      color: Color(0xff9F9F9F),
                                      fontFamily: "SF-Pro-SB",
                                      fontSize: 18))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Center(
                              child: Text("has been confirmed!",
                                  style: TextStyle(
                                      color: Color(0xff9F9F9F),
                                      fontFamily: "SF-Pro-Medium",
                                      fontSize: 18))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4, left: 50, right: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Arrival:",
                                    style: TextStyle(
                                        color: Color(0xff9F9F9F),
                                        fontFamily: "SF-Pro-Medium",
                                        fontSize: 14)),
                                Text(
                                    "${getDateAndDay(currentDateTime)['todayDate']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "SF-Pro-Medium",
                                        fontSize: 14))
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4, left: 50, right: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Departure:",
                                    style: TextStyle(
                                        color: Color(0xff9F9F9F),
                                        fontFamily: "SF-Pro-Medium",
                                        fontSize: 14)),
                                Text(
                                    "${getDateAndDay(currentDateTime)['tomorrowDate']}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "SF-Pro-Medium",
                                        fontSize: 14))
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 130, right: 130, left: 130),
                          child: OutlineButton(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xffE4E4E4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-Regular",
                                fontSize: 16,
                              ),
                            ),
                            // color: Color(0xff0093B1),
                            disabledBorderColor: Color(0xff9F9F9F),
                            // highlightedBorderColor: Colors.red,
                          ),
                        ),
                      ]),
                    ),
                  )));
        });
  }
}
