import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getLost_app/api_connection/hostel_api_connection.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/services.dart' show rootBundle;

class HostelInfoPanel extends StatefulWidget {
  final HostelDetail hostelInfo;
  final Marker marker;
  final Polyline directionLine;
  final PanelController panelController;

  HostelInfoPanel(
      {Key key,
      @required this.hostelInfo,
      @required this.marker,
      @required this.directionLine,
      @required this.panelController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HostelInfoPanelState(
        hostelInfo: hostelInfo,
        marker: marker,
        directionLine: directionLine,
        panelController: panelController);
  }
}

Future<void> callNow(String url) async {
  String urlString = ("tel://$url");
  if (await UrlLauncher.canLaunch(urlString)) {
    await UrlLauncher.launch(urlString);
  } else {
    throw 'call not possible $urlString';
  }
}

class HostelInfoPanelState extends State<HostelInfoPanel> {
  HostelDetail hostelInfo;
  Marker marker;
  Polyline directionLine;
  PanelController panelController;
  HostelInfoPanelState(
      {this.hostelInfo, this.marker, this.directionLine, this.panelController});

  Completer<GoogleMapController> _controllerPanel = Completer();
  GoogleMapController _controller2Panel;
  PolylineId id;
  Map<MarkerId, Marker> panelMarker = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> selectedPolyline = <PolylineId, Polyline>{};
  LatLng hostelLocation;
  String _mapStyle;

  geo.Position geoLocation;
  LatLng _centerPanel = LatLng(33.812511, -117.918976);

  // Timer _timer;

  getDirectionView(LatLng startCoordinates, LatLng destinationCoordinates,
      GoogleMapController controller) {
    // Define two position variables
    LatLng _northeastCoordinates;
    LatLng _southwestCoordinates;

// Calculating to check that
// southwest coordinate <= northeast coordinate
    if (startCoordinates.latitude <= destinationCoordinates.latitude) {
      _southwestCoordinates = startCoordinates;
      _northeastCoordinates = destinationCoordinates;
    } else {
      _southwestCoordinates = destinationCoordinates;
      _northeastCoordinates = startCoordinates;
    }

// Accommodate the two locations within the
// camera view of the map
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: _northeastCoordinates,
          southwest: _southwestCoordinates,
        ),
        40.0, // padding
      ),
    );
  }

  openMapsSheet(context, HostelDetail hostelData) async {
    try {
      final coords = mapLauncher.Coords(
          double.parse(hostelData.hostel.latitude),
          double.parse(hostelData.hostel.longitude));
      final title = hostelData.hostel.hostelName;
      final availableMaps = await mapLauncher.MapLauncher.installedMaps;

      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffE9E7E3), width: 2),
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                // decoration: BoxDecoration(
                //   color: Color(0xffFBF9F8),
                //   border: Border.all(color: Color(0xffE9E7E3), width: 2),
                //   borderRadius: BorderRadius.circular(25),
                // ),
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF-Pro-Regular",
                                color: Colors.black)),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // final applicationBloc =
    //     Provider.of<ApplicationBloc>(context, listen: false);
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    id = PolylineId("${marker.markerId}");
    panelMarker[marker.markerId] = marker;
    selectedPolyline[id] = directionLine;
    hostelLocation = LatLng(double.parse(hostelInfo.hostel.latitude),
        double.parse(hostelInfo.hostel.longitude));

    // getCurrentHostelData(hostelInfo);
    // applicationBloc.getSelectedHostelInfo(hostelInfo);
    // _timer = Timer.periodic(Duration(seconds: 10), (_) {
    //   // getCurrentHostelData(hostelInfo);
    //   print("WE running");
    //   applicationBloc.getSelectedHostelInfo(hostelInfo);
    // });
    // getCurrentHostelData(hostelInfo);
  }

  @override
  void dispose() {
    // _controller2Panel.dispose();
    // _controller2Panel.takeSnapshot();
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    setState(() {
      applicationBloc.getSelectedHostelInfo(hostelInfo);
      hostelInfo = applicationBloc.hostelInfo;
      // print("From Build: ${hostelInfo.avaliability}");
    });
    // applicationBloc.getSelectedHostelInfo(hostelInfo);
    return Visibility(
      visible: applicationBloc.infoPanelVisible,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Expanded(
                  //   child:
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 0, right: 20),
                      child: Text(
                        "${hostelInfo.hostel.hostelName}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontFamily: "SF-Pro-SB",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Expanded(
                  //   child:
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 0),
                      child: (hostelInfo.avaliability >= 1)
                          ? Text(
                              "Avaliable Beds:   ${hostelInfo.avaliability}",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-SB",
                              ),
                            )
                          : Text(
                              "Avaliable Beds:   ${hostelInfo.avaliability}  --   No Rooms Avaliable!",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xff9F9F9F),
                                fontFamily: "SF-Pro-SB",
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 46.0, bottom: 26, left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Expanded(
                  // child:
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "Total Price:",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "${hostelInfo.currency} ${hostelInfo.price}",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontFamily: "SF-Pro-SB",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            "No additional fees!",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff9F9F9F),
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                  // Expanded(
                  // child:
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height / 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: (hostelInfo.avaliability >= 1)
                          ? Color(0xff0093B1)
                          : Color(0xff707070),
                      textColor: Colors.white,
                      onPressed: (hostelInfo.avaliability >= 1)
                          ? () {
                              applicationBloc.setBookingPanelPage(false, true);
                            }
                          : () {
                              print(
                                  "No Avaliable rooms for ${hostelInfo.hostel.hostelName}");
                            },
                      child: Text(
                        "Book!",
                        style: TextStyle(
                          fontSize: 26.0,
                          // color: Colors.black,
                          fontFamily: "SF-Pro-Medium",
                        ),
                      ),
                    ),
                  )
                  // ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
              child: Divider(),
            ),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, right: 50.0, left: 50.0),
                  child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Icon(Icons.bathtub,
                                size: 35, color: Color(0xff8B8985))),
                        Expanded(
                            child: Icon(Icons.wifi,
                                size: 35, color: Color(0xff8B8985))),
                        Expanded(
                            child: Icon(Icons.free_breakfast,
                                size: 35, color: Color(0xff8B8985))),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 26.0, left: 10, right: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height / 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(0xffE9E7E3),
                      textColor: Colors.black,
                      onPressed: () {
                        // panelController.close();
                        openMapsSheet(context, hostelInfo);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.directions, size: 22, color: Colors.black),
                          Text(
                            "Directions",
                            style: TextStyle(
                              fontSize: 12.0,
                              // color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 5.0, right: 0.0),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height / 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(0xffE9E7E3),
                      textColor: Colors.black,
                      onPressed: () {
                        callNow(hostelInfo.hostel.phone);
                        print("CALL PRESSED ${hostelInfo.hostel.phone}");
                      },
                      child: Column(
                        children: [
                          Icon(Icons.call, size: 22, color: Colors.black),
                          Text(
                            "Call",
                            style: TextStyle(
                              fontSize: 12.0,
                              // color: Colors.black,
                              fontFamily: "SF-Pro-Regular",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 5, right: 8),
              child: Container(
                height: 200,
                // decoration: BoxDecoration(color: Colors.blueAccent),
                child: AbsorbPointer(
                  absorbing: true,
                  child: GoogleMap(
                    // key: UniqueKey(),
                    onMapCreated: (GoogleMapController controller) async {
                      _controllerPanel.complete(controller);
                      _controller2Panel = controller;
                      _controller2Panel..setMapStyle(_mapStyle);
                      _centerPanel = LatLng(
                          applicationBloc.currentLocation.latitude,
                          applicationBloc.currentLocation.longitude);

                      getDirectionView(
                          _centerPanel, hostelLocation, _controller2Panel);
                    },
                    // onCameraIdle: () async {},
                    markers: Set<Marker>.of(panelMarker.values),
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition:
                        CameraPosition(target: _centerPanel, zoom: 10),
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    polylines: Set<Polyline>.of(selectedPolyline.values),
                    // polylines: selectedPolylines,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Address",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "SF-Pro-Regular",
                                color: Color(0xff8B8985)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Text("${hostelInfo.hostel.address}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF-Pro-Regular",
                                color: Colors.black))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 20),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Text("Phone",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "SF-Pro-Regular",
                                color: Color(0xff8B8985)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Text("${hostelInfo.hostel.phone}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF-Pro-Regular",
                                color: Colors.black))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 20),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Text("Website",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "SF-Pro-Regular",
                                color: Color(0xff8B8985)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text("${hostelInfo.hostel.website}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF-Pro-Regular",
                                color: Colors.black))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 20),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Text("Email",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "SF-Pro-Regular",
                                color: Color(0xff8B8985)))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Text("${hostelInfo.hostel.email}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF-Pro-Regular",
                                color: Colors.black))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, bottom: 50, left: 25, right: 25),
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
          ],
        ),
      ),
    );
  }
}
