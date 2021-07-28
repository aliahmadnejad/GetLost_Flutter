import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/guest_home/bloc/guest_home_bloc.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/model/api_model.dart';
import 'dart:typed_data';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Map loading flag
bool _isMapLoading = true;
// Marker loading flag
bool _areMarkersLoading = false;
Completer<GoogleMapController> _controller = Completer();
GoogleMapController _controller2;
geo.Position geoLocation;
LatLng _center;
LatLng _initialCameraPosition = LatLng(33.812511, -117.918976);
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
Marker selectedMarker;
Polyline selectedLine;
LatLng _centerPanel = LatLng(33.812511, -117.918976);
List<HostelDetail> listOfHostelDetails;
final _base = "https://getlost-245519.wl.r.appspot.com";

// Variables to do with OPENPOPUP!!
// ---------------------------------
// ---------------------------------
// Object for PolylinePoints
PolylinePoints polylinePoints;
// List of coordinates to join
List<LatLng> polylineCoordinates = [];
// Map storing polylines created by connecting
// two points
Map<PolylineId, Polyline> polylines = {};

bool _searchBarVisible = true;
bool bookingPageVisible = false;

bool infoPageVisible = false;
HostelDetail hdp;
String hdpString;
HostelDetail hostelPanel;
String hostelPanelName;
String hostelPanelCurrency;
var hostelPanelPrice;
var hostelPanelAvaliability;
String hostelPanelAddress;
var hostelPanelPhone;
String hostelPanelEmail;
String hostelPanelWebsite;
LatLng hostelPanelLocation;

getDateAndDay(DateTime date) {
  DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

  dateFormate(DateTime date) {
    var monthValue = date.month;
    String month;
    switch (monthValue) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    String newDate = "${date.day.toString()} $month ${date.year.toString()}";
    return newDate;
  }

  dayFormate(DateTime date) {
    var dayValue = date.weekday;
    String day;

    switch (dayValue) {
      case 1:
        day = "Monday";
        break;
      case 2:
        day = "Tuesday";
        break;
      case 3:
        day = "Wednesday";
        break;
      case 4:
        day = "Thursday";
        break;
      case 5:
        day = "Friday";
        break;
      case 6:
        day = "Saturday";
        break;
      case 7:
        day = "Sunday";
        break;
    }
    return day;
  }

  String todayDate = dateFormate(date);
  String tomorrowDate = dateFormate(tomorrow);
  String todayDay = dayFormate(date);
  String tomorrowDay = dayFormate(tomorrow);

  Map<String, String> datesAndDays = {
    "todayDate": todayDate,
    "tomorrowDate": tomorrowDate,
    "todayDay": todayDay,
    "tomorrowDay": tomorrowDay
  };

  // print(datesAndDays);
  return datesAndDays;
}

getUserLocation() async {
  geoLocation = await locateUser();
  _center = LatLng(geoLocation.latitude, geoLocation.longitude);
  print('center $_center');

  return _center;
}

Future<geo.Position> locateUser() async {
  var currentLocation;
  // print("--------------locateuser has run!!");
  try {
    currentLocation = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  } catch (e) {
    print("current location = Null");
    currentLocation = null;
  }
  return currentLocation;
}

Future<BitmapDescriptor> getMarkerIcon(
    String imagePath, Size size, String price, String currency) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  // Oval for the image
  Rect oval =
      Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble());

  // Add image
  ui.Image image = await loadUiImage(
      imagePath); // Alternatively use your own method to get the image
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitHeight);

  // Add tag text
  TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
  textPainter.text = TextSpan(
    text: "$currency$price",
    style: TextStyle(
      fontSize: 32.0,
      color: Colors.white,
      fontFamily: "SF-Pro-Bold",
    ),
  );

  textPainter.layout();
  textPainter.paint(
      canvas,
      Offset((size.width * 0.5) - textPainter.width * 0.5,
          (size.height * 0.45) - textPainter.height * 0.5));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

// Create the polylines for showing the route between two places
createPolylines(LatLng start, LatLng destination) async {
  print("The start is ${start.toString()}, and end ${destination.toString()}");
  polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    "AIzaSyDJE-s-LSBuxG8rzUNoUn8dNfegNV-afMQ", // Google Maps API Key
    PointLatLng(start.latitude, start.longitude),
    PointLatLng(destination.latitude, destination.longitude),
    travelMode: TravelMode.driving,
  );

  polylineCoordinates.clear();
  if (result.points.isNotEmpty) {
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  }

  PolylineId id = PolylineId('poly');
  Polyline polyline = Polyline(
    polylineId: id,
    color: Color(0xff0093B1),
    points: polylineCoordinates,
    width: 4,
    jointType: JointType.round,
  );
  // polylines[id] = polyline;
  return polyline;
}
//  ---------------------------------
//  ---------------------------------
// Variables to do with OPENPOPUP!!

toCurrencySymbol(code) {
  String symbol;
  if (code == "USD") {
    symbol = r"$";
  } else if (code == "EUR") {
    symbol = "€";
  } else if (code == "GBP") {
    symbol = "£";
  }
  return symbol;
}

checkMarkers(markers, _controller) async {
  LatLngBounds bounds = await _getVisibleRegion(_controller);
  Set<Marker> markerss = Set<Marker>.of(markers.values);
  Marker mark;
  List<dynamic> contained = List<dynamic>();

  if (markerss.isNotEmpty) {
    markerss.forEach((marker) {
      // print("Marker ID: ${marker.markerId}");
      // print(
      // 'Position: ${marker.position} - Contains: ${bounds.contains(marker.position)}');
      if (bounds.contains(marker.position) == true) {
        mark = marker;
        contained.add(mark);
      }
    });
    // print(contained.length);
  }
  return contained;
}

Future<LatLngBounds> _getVisibleRegion(_controller) async {
  final GoogleMapController controller = await _controller.future;
  final LatLngBounds bounds = await controller.getVisibleRegion();
  // print("bounds are $bounds");
  return bounds;
}

listHostel(markers, _controller, listOfHostelDetails) async {
  List<dynamic> m = await checkMarkers(markers, _controller);
  // List<dynamic> h = await getHostelData();
  List<dynamic> h = listOfHostelDetails;
  List<dynamic> hostelsOnMap = List<dynamic>();
  if (m.isNotEmpty && h != null) {
    // print("List of markers ON THE MAP ------- $m");
    // print("List of Hostels ------- $h");
    // print("LIST OF HOSTEL DETAILS +++++===== $listOfHostelDetails");
    // m.forEach((element) {
    //   print("MARKER ID ${element.markerId.value}");
    // });
    // h.forEach((element) {
    //   print("HOSTEL ID ${element.hostel.id}");
    // });
    m.forEach((marker) {
      h.forEach((hostel) {
        if (int.parse(marker.markerId.value) == hostel.hostel.id) {
          String price = hostel.price.substring(0, 2);
          // print("Hostels that are on the map ${hostel.hostel.id}");
          // print("hostel price ${hostel.price}");
          // print("Sub string price $price");
          hostelsOnMap.add(hostel);
        }
      });
    });
    // print("The hostels we will use $hostelsOnMap");
  }

  return hostelsOnMap;
}

searchAndNavigate(searchAddress, _controller2) {
  geo.Geolocator().placemarkFromAddress(searchAddress).then((result) {
    _controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 10.0)));
  });
}

openPopup(
    BuildContext context,
    HostelDetail hostelData,
    BitmapDescriptor icon,
    var markerId,
    LatLng markerLocation,
    panelController,
    ValueChanged updateSearchBar) async {
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
                              onPressed: (hostelData.avaliability >= 1)
                                  ? () {
                                      applicationBloc.setBookingPanelPage(
                                          false, true);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                      if (panelController.isPanelClosed) {
                                        panelController.open();
                                      }
                                    }
                                  : () {
                                      print(
                                          "No Avaliable rooms for ${hostelData.hostel.hostelName}");
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
