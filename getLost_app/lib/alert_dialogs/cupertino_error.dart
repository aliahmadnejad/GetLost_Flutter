import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/api_connection/hostel_api_connection.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/home/panels/hostel_booking_panel.dart';
import 'package:getLost_app/home/panels/hostel_info_panel.dart';
import 'package:getLost_app/home/buttons/hostel_list_button.dart';
import 'package:getLost_app/home/panels/menu_panel.dart';
import 'package:getLost_app/home/buttons/menu_panel_button.dart';
import 'package:getLost_app/home/settings_pages/account_page.dart';
import 'package:getLost_app/home/settings_pages/contact_page.dart';
import 'package:getLost_app/home/settings_pages/payment_page.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/place.dart';
import 'package:getLost_app/model/place_search.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

openDialog(String title, String text, String buttonText, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(buttonText),
                  onPressed: () {
                    print("Dialog is closed");
                    Navigator.of(context).pop();
                  }),
            ],
          ));
}
