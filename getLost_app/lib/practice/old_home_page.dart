// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
// import 'package:getLost_app/api_connection/api_connection.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';

// class HomePage extends StatefulWidget {
//   final String name;

//   HomePage({
//     Key key,
//     @required this.name,
//   });

//   @override
//   _HomeState createState() => new _HomeState(
//         name: name,
//       );
// }

// class _HomeState extends State<HomePage> {
//   final String name;
//   _HomeState({
//     this.name,
//   });

//   LatLng _initialCameraPosition = LatLng(37.77483, -122.41942);

//   // Controllers
//   GoogleMapController _controller;
//   PanelController _panelController = new PanelController();
//   // Variables for Search Bar
//   var _searchController = TextEditingController();
//   String searchAddress;

//   bool _visible = false;
//   Location _location = Location();

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _onMapCreated(GoogleMapController _cntlr) {
//     setState(() {
//       _controller = _cntlr;
//     });
//     _location.onLocationChanged.listen((l) {
//       LatLng currentLocation = LatLng(l.latitude, l.longitude);
//       print(currentLocation);
//       // print("hello");
//       // print(_cntlr.getVisibleRegion());
//       // print("is it me youre looking for");
//       _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: currentLocation, zoom: 15),
//         ),
//       );
//     });
//   }

//   void _currentLocation() async {
//     print("button pressed");
//     var currentLocation = _location.getLocation();
//     print(currentLocation.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _panelHeightOpen = MediaQuery.of(context).size.height * .80;
//     // _panelController.hide();

//     return Material(
//       child: SlidingUpPanel(
//         backdropEnabled: true,
//         panelBuilder: (ScrollController sc) => _scrollingList(sc),
//         // panel: Center(
//         //   child: Text("Heelloooo"),
//         // ),
//         header: Padding(
//           padding: const EdgeInsets.all(0),
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               children: <Widget>[
//                 const Spacer(),
//                 Expanded(
//                     child: Center(
//                         child: Icon(
//                   Icons.horizontal_rule_rounded,
//                   color: Color(0xffC2C1C1),
//                   size: 50,
//                 ))),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: ButtonTheme(
//                       padding: EdgeInsets.all(0),
//                       child: FlatButton(
//                         onPressed: () {
//                           _panelController.close();
//                         },
//                         child: Icon(
//                           Icons.close,
//                           color: Color(0xff707070),
//                           size: 20.0,
//                         ),
//                         padding: EdgeInsets.all(0.0),
//                         shape: CircleBorder(),
//                         color: Color(0xffECEBE9),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         // renderPanelSheet: _visible,
//         controller: _panelController,
//         maxHeight: MediaQuery.of(context).size.height - 60,
//         minHeight: 0,
//         border: Border.all(color: Color(0xffE9E7E3), width: 2),
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
//         body: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Row(
//                     children: [
//                       ButtonTheme(
//                         minWidth: MediaQuery.of(context).size.width / 12,
//                         height: MediaQuery.of(context).size.height / 20,
//                         // padding: EdgeInsets.all(0),
//                         child: RaisedButton(
//                           color: Color(0xffFBF9F8),
//                           elevation: 2.5,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               color: Color(0xffE9E7E3),
//                               width: 0.5,
//                             ),
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(12),
//                                 topRight: Radius.circular(0),
//                                 bottomLeft: Radius.circular(12),
//                                 bottomRight: Radius.circular(0)),
//                           ),
//                           onPressed: () {
//                             // getHostelDetailData();
//                             // if (_visible == false) {
//                             //   // _panelController.show();
//                             //   _panelController.open();
//                             //   _visible = true;
//                             // } else {
//                             //   // _panelController.hide();
//                             //   _panelController.close();
//                             //   _visible = false;
//                             // }
//                             if (_panelController.isPanelClosed) {
//                               // _panelController.show();
//                               _panelController.open();
//                             } else {
//                               // _panelController.hide();
//                               _panelController.close();
//                             }
//                           },
//                           child: Icon(
//                             Icons.menu,
//                             color: Color(0xff9F9F9F),
//                           ),
//                         ),
//                       ),
//                       ButtonTheme(
//                         minWidth: MediaQuery.of(context).size.width / 12,
//                         height: MediaQuery.of(context).size.height / 20,
//                         // padding: EdgeInsets.all(0),
//                         child: RaisedButton(
//                           color: Color(0xffFBF9F8),
//                           elevation: 2.5,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                                 color: Color(0xffE9E7E3), width: 0.5),
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(0),
//                                 topRight: Radius.circular(12),
//                                 bottomLeft: Radius.circular(0),
//                                 bottomRight: Radius.circular(12)),
//                           ),
//                           onPressed: () {
//                             BlocProvider.of<AuthenticationBloc>(context)
//                                 .add(LoggedOut());
//                             Navigator.of(context).pop();
//                           },
//                           child: Icon(
//                             Icons.exit_to_app,
//                             color: Color(
//                               0xff9F9F9F,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               // IconButton(
//               //   color: Colors.grey,
//               //   icon: Icon(Icons.exit_to_app),
//               //   onPressed: () {
//               //     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//               //     Navigator.of(context).pop();
//               //   },
//               // )
//             ],
//           ),
//           body: Container(
//             child: FutureBuilder(
//               future: getHostelData(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData) {
//                   return (Center(child: CircularProgressIndicator()));
//                 } else {
//                   // List<dynamic> parsedJson = jsonDecode(snapshot.data);
//                   var allMarkers = snapshot.data.map((element) {
//                     return Marker(
//                       markerId: MarkerId(element.hostelName),
//                       draggable: false,
//                       onTap: () {
//                         print('Marker Tapped');
//                         print(element.hostelName);
//                       },
//                       position: LatLng(double.parse(element.latitude),
//                           double.parse(element.longitude)),
//                     );
//                   }).toList();

//                   return Stack(children: <Widget>[
//                     GoogleMap(
//                       zoomGesturesEnabled: true,
//                       // mapType: MapType.hybrid,
//                       onMapCreated: _onMapCreated,
//                       myLocationButtonEnabled: false,
//                       myLocationEnabled: true,
//                       zoomControlsEnabled: true,
//                       scrollGesturesEnabled: true,
//                       compassEnabled: true,
//                       // markers:
//                       initialCameraPosition:
//                           CameraPosition(target: _initialCameraPosition),
//                       markers: Set.from(allMarkers),
//                     ),
//                     Positioned(
//                         bottom: 30,
//                         right: 20,
//                         left: 20,
//                         child: Container(
//                           height: 40,
//                           padding: EdgeInsets.only(bottom: 8, top: 3),
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black38,
//                                 blurRadius: 6.0, // soften the shadow
//                                 spreadRadius: 2.0, //extend the shadow
//                                 offset: Offset(
//                                   0.0, // Move to right 10  horizontally
//                                   5.0, // Move to bottom 10 Vertically
//                                 ),
//                               ),
//                             ],
//                             color: Colors.white,
//                             border: Border.all(
//                                 color: Color(0xffE9E7E3), width: 1.5),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           // color: Colors.white,
//                           child: Row(
//                             children: <Widget>[
//                               IconButton(
//                                 splashColor: Colors.grey,
//                                 icon: Icon(
//                                   Icons.search,
//                                   color: Color(0xff9F9F9F),
//                                   size: 20,
//                                 ),
//                                 onPressed: searchAndNavigate,
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _searchController,
//                                   cursorColor: Color(0xff9F9F9F),
//                                   keyboardType: TextInputType.text,
//                                   textInputAction: TextInputAction.go,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.all(10),
//                                     // EdgeInsets.symmetric(horizontal: 1),
//                                     hintText: "Search for a hostel or address",
//                                     hintStyle: TextStyle(
//                                         color: Color(0xff9F9F9F),
//                                         fontFamily: "SF-Pro-Regular",
//                                         fontSize:
//                                             MediaQuery.of(context).size.width /
//                                                 26),
//                                     // isDense: true,
//                                     // contentPadding: EdgeInsets.symmetric(
//                                     //     vertical: 8.0, horizontal: 10.0),
//                                     // focusedBorder: OutlineInputBorder(
//                                     //     borderSide: BorderSide(
//                                     //         width: 2,
//                                     //         color: Color(0xff0093B1))),
//                                     // border: OutlineInputBorder(
//                                     //   borderRadius: BorderRadius.circular(5.0),
//                                     //   borderSide: BorderSide(),
//                                     // ),
//                                   ),
//                                   onChanged: (val) {
//                                     setState(() {
//                                       searchAddress = val;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Padding(
//                                   padding: const EdgeInsets.only(right: 4.0),
//                                   // child: CircleAvatar(
//                                   // backgroundColor: Colors.deepPurple,
//                                   child: IconButton(
//                                     padding: EdgeInsets.only(bottom: 1, top: 4),
//                                     // padding: EdgeInsets.all(1),
//                                     icon: Icon(Icons.near_me),
//                                     color: Color(0xff0093B1),
//                                     onPressed: _currentLocation,
//                                   )
//                                   // ),
//                                   ),
//                             ],
//                           ),
//                         )),
//                   ]);
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   searchAndNavigate() {
//     Geolocator().placemarkFromAddress(searchAddress).then((result) {
//       _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target:
//               LatLng(result[0].position.latitude, result[0].position.longitude),
//           zoom: 10.0)));
//     });
//   }

//   Widget _scrollingList(ScrollController sc) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: FutureBuilder(
//           // future: getHostelData(),
//           future: getHostelDetailData(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             // print(snapshot.data);
//             if (snapshot.data == null) {
//               return Container(child: Center(child: Text("Loading...")));
//             } else {
//               return ListView.builder(
//                 controller: sc,
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   print((snapshot.data[index].avaliability).toString());
//                   print(snapshot.data[index].hostel.hostelName);
//                   var item = snapshot.data[index];
//                   print(item.price);
//                   return Column(
//                     children: <Widget>[
//                       ListTile(
//                         title: Text(item.hostel.hostelName),
//                         //SET A DEFAULT FOR CURRENCY IF NULL OR IF STATMENT TO CHANGE
//                         trailing: Text(item.currency + " " + item.price),
//                         // title: Text(
//                         //     (snapshot.data[index].avaliability).toString()),
//                         // title: Text(snapshot.data[index].hostelName),
//                         // subtitle: Text("longitude: " +
//                         //     snapshot.data[index].longitude +
//                         //     "    " +
//                         //     "Latitude: " +
//                         //     snapshot.data[index].latitude),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 0, bottom: 0, left: 10, right: 10),
//                         child: Divider(),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// // Widget _scrollingList(ScrollController sc) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(2),
// //         child: MediaQuery.removePadding(
// //           context: context,
// //           removeTop: true,
// //           removeBottom: true,
// //           child: AppBar(
// //             backgroundColor: Colors.green,
// //             elevation: 0,
// //             title: Icon(Icons.drag_handle, color: Colors.grey),
// //             centerTitle: true,
// //           ),
// //         ),
// //       ),
// //       body: FutureBuilder(
// //         future: getHostelData(),
// //         builder: (BuildContext context, AsyncSnapshot snapshot) {
// //           // print(snapshot.data);
// //           if (snapshot.data == null) {
// //             return Container(child: Center(child: Text("Loading...")));
// //           } else {
// //             return ListView.builder(
// //               controller: sc,
// //               itemCount: snapshot.data.length,
// //               itemBuilder: (BuildContext context, int index) {
// //                 // print(snapshot.data[index].hostelName);
// //                 return ListTile(
// //                   title: Text(snapshot.data[index].hostelName),
// //                   subtitle: Text("longitude: " +
// //                       snapshot.data[index].longitude +
// //                       "    " +
// //                       "Latitude: " +
// //                       snapshot.data[index].latitude),
// //                 );
// //               },
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }

// // @override
// // Widget build(BuildContext context) {
// //   // _panelHeightOpen = MediaQuery.of(context).size.height * .80;
// //   // _panelController.hide();

// //   return Scaffold(
// //     extendBodyBehindAppBar: true,
// //     appBar: AppBar(
// //       automaticallyImplyLeading: false,
// //       backgroundColor: Colors.transparent,
// //       elevation: 0.0,
// //       actions: <Widget>[
// //         Padding(
// //           padding: const EdgeInsets.only(right: 20.0),
// //           child: Align(
// //             alignment: Alignment.centerRight,
// //             child: Row(
// //               children: [
// //                 ButtonTheme(
// //                   minWidth: MediaQuery.of(context).size.width / 12,
// //                   height: MediaQuery.of(context).size.height / 20,
// //                   // padding: EdgeInsets.all(0),
// //                   child: RaisedButton(
// //                     color: Color(0xffFBF9F8),
// //                     elevation: 2.5,
// //                     shape: RoundedRectangleBorder(
// //                       side: BorderSide(
// //                         color: Color(0xffE9E7E3),
// //                         width: 0.5,
// //                       ),
// //                       borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(12),
// //                           topRight: Radius.circular(0),
// //                           bottomLeft: Radius.circular(12),
// //                           bottomRight: Radius.circular(0)),
// //                     ),
// //                     onPressed: () {
// //                       // if (_visible == false) {
// //                       //   // _panelController.show();
// //                       //   _panelController.open();
// //                       //   _visible = true;
// //                       // } else {
// //                       //   // _panelController.hide();
// //                       //   _panelController.close();
// //                       //   _visible = false;
// //                       // }
// //                       if (_panelController.isPanelClosed) {
// //                         // _panelController.show();
// //                         _panelController.open();
// //                       } else {
// //                         // _panelController.hide();
// //                         _panelController.close();
// //                       }
// //                     },
// //                     child: Icon(
// //                       Icons.menu,
// //                       color: Color(0xff9F9F9F),
// //                     ),
// //                   ),
// //                 ),
// //                 ButtonTheme(
// //                   minWidth: MediaQuery.of(context).size.width / 12,
// //                   height: MediaQuery.of(context).size.height / 20,
// //                   // padding: EdgeInsets.all(0),
// //                   child: RaisedButton(
// //                     color: Color(0xffFBF9F8),
// //                     elevation: 2.5,
// //                     shape: RoundedRectangleBorder(
// //                       side: BorderSide(color: Color(0xffE9E7E3), width: 0.5),
// //                       borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(0),
// //                           topRight: Radius.circular(12),
// //                           bottomLeft: Radius.circular(0),
// //                           bottomRight: Radius.circular(12)),
// //                     ),
// //                     onPressed: () {
// //                       BlocProvider.of<AuthenticationBloc>(context)
// //                           .add(LoggedOut());
// //                       Navigator.of(context).pop();
// //                     },
// //                     child: Icon(
// //                       Icons.exit_to_app,
// //                       color: Color(
// //                         0xff9F9F9F,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         )
// //         // IconButton(
// //         //   color: Colors.grey,
// //         //   icon: Icon(Icons.exit_to_app),
// //         //   onPressed: () {
// //         //     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
// //         //     Navigator.of(context).pop();
// //         //   },
// //         // )
// //       ],
// //     ),
// //     body: SlidingUpPanel(
// //         panelBuilder: (ScrollController sc) => _scrollingList(sc),
// //         // panel: Center(
// //         //   child: Text("Heelloooo"),
// //         // ),
// //         header: Padding(
// //           padding: const EdgeInsets.all(0),
// //           child: Container(
// //             width: MediaQuery.of(context).size.width,
// //             child: Row(
// //               children: <Widget>[
// //                 const Spacer(),
// //                 Expanded(
// //                     child: Center(
// //                         child: Icon(
// //                   Icons.horizontal_rule_rounded,
// //                   color: Color(0xffC2C1C1),
// //                   size: 50,
// //                 ))),
// //                 Expanded(
// //                   child: Align(
// //                     alignment: Alignment.centerRight,
// //                     child: ButtonTheme(
// //                       padding: EdgeInsets.all(0),
// //                       child: FlatButton(
// //                         onPressed: () {
// //                           _panelController.close();
// //                         },
// //                         child: Icon(
// //                           Icons.close,
// //                           color: Color(0xff707070),
// //                           size: 20.0,
// //                         ),
// //                         padding: EdgeInsets.all(0.0),
// //                         shape: CircleBorder(),
// //                         color: Color(0xffECEBE9),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //         // renderPanelSheet: _visible,
// //         controller: _panelController,
// //         minHeight: 0,
// //         borderRadius: BorderRadius.only(
// //             topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
// //         body: Container(
// //           child: FutureBuilder(
// //             future: getHostelData(),
// //             builder: (BuildContext context, AsyncSnapshot snapshot) {
// //               if (!snapshot.hasData) {
// //                 return (Center(child: CircularProgressIndicator()));
// //               } else {
// //                 // List<dynamic> parsedJson = jsonDecode(snapshot.data);
// //                 var allMarkers = snapshot.data.map((element) {
// //                   return Marker(
// //                     markerId: MarkerId(element.hostelName),
// //                     draggable: false,
// //                     onTap: () {
// //                       print('Marker Tapped');
// //                       print(element.hostelName);
// //                     },
// //                     position: LatLng(double.parse(element.latitude),
// //                         double.parse(element.longitude)),
// //                   );
// //                 }).toList();

// //                 return GoogleMap(
// //                   zoomGesturesEnabled: true,
// //                   // mapType: MapType.hybrid,
// //                   onMapCreated: _onMapCreated,
// //                   myLocationButtonEnabled: true,
// //                   myLocationEnabled: true,
// //                   // markers:
// //                   initialCameraPosition:
// //                       CameraPosition(target: _initialCameraPosition),
// //                   markers: Set.from(allMarkers),
// //                 );
// //               }
// //             },
// //           ),
// //         )),
// //   );
// // }
