// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:typed_data';
// // import 'dart:ui' as ui;

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:getLost_app/bloc/authentication_bloc.dart';
// // import 'package:getLost_app/api_connection/api_connection.dart';
// // import 'package:getLost_app/model/hostel_model.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// // import 'package:sliding_up_panel/sliding_up_panel.dart';
// // import 'package:uuid/uuid.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:geolocator/geolocator.dart' as geo;

// // class HomePage extends StatefulWidget {
// //   final String name;

// //   HomePage({
// //     Key key,
// //     @required this.name,
// //   });

// //   @override
// //   _HomeState createState() => new _HomeState(
// //         name: name,
// //       );
// // }

// // class _HomeState extends State<HomePage> {
// //   final String name;
// //   _HomeState({
// //     this.name,
// //   });

// //   List<dynamic> databaseItems;
// //   List<HostelDetail> listOfHostelDetails;
// //   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
// //   Completer<GoogleMapController> _controller = Completer();
// //   LatLng _initialCameraPosition = LatLng(33.812511, -117.918976);

// //   getHostelData() async {
// //     final String adminToken = await getAdminToken();
// //     http.Response response = await http.get(
// //         "http://127.0.0.1:8000/api/hostelroomdetail/",
// //         headers: <String, String>{
// //           'Content-Type': 'application/json; charset=UTF-8',
// //           'Authorization': 'Token $adminToken'
// //         });
// //     databaseItems = json.decode(response.body);
// //     listOfHostelDetails = databaseItems
// //         .map((data) => HostelDetail.fromDatabaseJson(data))
// //         .toList();
// //     // print(listOfHostelDetails);
// //     int index = 0;
// //     for (HostelDetail hostel in listOfHostelDetails) {
// //       index += 1;
// //       // print("hostel number $index is: $hostel");
// //       initMarker(hostel);
// //     }
// //     return listOfHostelDetails;
// //   }

// //   void initMarker(hostelInfo) async {
// //     HostelDetail hostelData = hostelInfo;
// //     var hostelId = (hostelData.hostel.id).toString();
// //     var markerId = MarkerId(hostelId);
// //     LatLng markerLocation = LatLng((double.parse(hostelData.hostel.latitude)),
// //         (double.parse(hostelData.hostel.longitude)));
// //     // print(markerId);
// //     // print(markerLocation);
// //     final Marker marker = Marker(markerId: markerId, position: markerLocation);
// //     // print(marker);
// //     setState(() {
// //       markers[markerId] = marker;
// //       // print(markers);
// //       // print(Set<Marker>.of(markers.values));
// //     });
// //   }

// //   Future<LatLngBounds> _getVisibleRegion() async {
// //     final GoogleMapController controller = await _controller.future;
// //     final LatLngBounds bounds = await controller.getVisibleRegion();
// //     // print("bounds are $bounds");
// //     return bounds;
// //   }

// //   checkMarkers() async {
// //     LatLngBounds bounds = await _getVisibleRegion();
// //     Set<Marker> markerss = Set<Marker>.of(markers.values);
// //     Marker mark;
// //     List<dynamic> contained = List<dynamic>();

// //     markerss.forEach((marker) {
// //       // print("Marker ID: ${marker.markerId}");
// //       // print(
// //       // 'Position: ${marker.position} - Contains: ${bounds.contains(marker.position)}');
// //       if (bounds.contains(marker.position) == true) {
// //         // print("it is true");
// //         mark = marker;
// //         contained.add(mark);
// //       } else {
// //         // print("it is false");
// //       }
// //     });
// //     // print("Containedddd $contained");
// //     // print("also markers are $markerss");
// //     print(contained.length);

// //     // setState(() {});
// //     // print("Contained ${contained2.length}");

// //     // contained.clear();
// //     // return markerss;
// //     return contained;
// //   }

// //   Future obj;
// //   @override
// //   void initState() {
// //     super.initState();
// //     getHostelData();
// //     // obj = checkMarkers();
// //     // print("the object is $obj");
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(actions: <Widget>[
// //         Row(
// //           children: [
// //             Container(
// //               child: FutureBuilder(
// //                 future: checkMarkers(),
// //                 builder: (BuildContext context, AsyncSnapshot snapshot) {
// //                   if (snapshot.data == null) {
// //                     return Container(child: Center(child: Text("Loading...")));
// //                   } else {
// //                     // var mark = snapshot.data;
// //                     // print(mark);
// //                     print("ITEM COUNT ${snapshot.data.length}");
// //                     print("heres the stuff ${snapshot.data}");
// //                     return ListView.builder(
// //                       // controller: sc,
// //                       itemCount: snapshot.data.length,
// //                       itemBuilder: (BuildContext context, int index) {
// //                         print(snapshot.data[index]);
// //                         var item = snapshot.data[index];
// //                         print("more stuff --- ${item.markerId}");
// //                         return Container();
// //                       },
// //                     );
// //                   }
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ]),
// //       body: GoogleMap(
// //         zoomGesturesEnabled: true,
// //         // mapType: MapType.hybrid,
// //         myLocationButtonEnabled: false,
// //         myLocationEnabled: true,
// //         zoomControlsEnabled: true,
// //         scrollGesturesEnabled: true,
// //         compassEnabled: true,
// //         // markers:
// //         initialCameraPosition:
// //             CameraPosition(target: _initialCameraPosition, zoom: 10),
// //         markers: Set<Marker>.of(markers.values),
// //         onCameraIdle: () {
// //           setState(() {
// //             checkMarkers();
// //           });
// //         },
// //         onMapCreated: (GoogleMapController controller) async {
// //           _controller.complete(controller);
// //           checkMarkers();
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
// import 'package:getLost_app/api_connection/api_connection.dart';
// import 'package:getLost_app/model/hostel_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:fluster/fluster.dart';
// import 'package:getLost_app/helpers/map_marker.dart';
// import 'package:getLost_app/helpers/map_helper.dart';

// class HomePage extends StatefulWidget {
//   final String name;

//   HomePage({Key key, @required this.name});

//   @override
//   _HomePageState createState() => _HomePageState(
//         name: name,
//       );
// }

// class _HomePageState extends State<HomePage> {
//   final String name;
//   _HomePageState({this.name});

//   final Completer<GoogleMapController> _mapController = Completer();

//   /// Set of displayed markers and cluster markers on the map
//   final Set<Marker> _markers = Set();

//   /// Minimum zoom at which the markers will cluster
//   final int _minClusterZoom = 0;

//   /// Maximum zoom at which the markers will cluster
//   final int _maxClusterZoom = 19;

//   /// [Fluster] instance used to manage the clusters
//   Fluster<MapMarker> _clusterManager;

//   /// Current map zoom. Initial zoom will be 15, street level
//   double _currentZoom = 15;

//   /// Map loading flag
//   bool _isMapLoading = true;

//   /// Markers loading flag
//   bool _areMarkersLoading = true;

//   /// Url image used on normal markers
//   final String _markerImageUrl =
//       'https://img.icons8.com/office/80/000000/marker.png';

//   /// Color of the cluster circle
//   final Color _clusterColor = Colors.blue;

//   /// Color of the cluster text
//   final Color _clusterTextColor = Colors.white;

//   Future<List<HostelDetail>> getMarkerData() async {
//     final String adminToken = await getAdminToken();
//     http.Response response = await http.get(
//         "http://127.0.0.1:8000/api/hostelroomdetail/",
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Token $adminToken'
//         });
//     List<dynamic> items = json.decode(response.body);
//     List<HostelDetail> listOfHostelDetails =
//         items.map((data) => HostelDetail.fromDatabaseJson(data)).toList();
//     List<LatLng> _markerslocation;
//     // print(listOfHostelDetails.length);
//     // print("++++++++++++++++++");
//     // print(listOfHostelDetails);

//     List<dynamic> mapmarkers = List<dynamic>();
//     // print(listOfHostelDetails[0].hostel);
//     for (HostelDetail hostel in listOfHostelDetails) {
//       double lat = double.parse(hostel.hostel.latitude);
//       double lng = double.parse(hostel.hostel.longitude);
//       // print(lat);
//       // print(lng);
//       _markerslocation = [LatLng(lat, lng)];
//       // print("markers locarions are: $_markerslocation");
//       mapmarkers.add(_markerslocation);
//       // print(hostel.avaliability);
//       // print(hostel.hostel.hostelName);
//       // var hostelName = hostel.hostel.hostelName;
//     }
//     // print("mapmarker list is ------- $mapmarkers");
//     // print(_markerslocation[0]);
//     return listOfHostelDetails;
//     // return mapmarkers;
//   }

//   Future<List<dynamic>> getMarkers() async {
//     final List<HostelDetail> listOfHostels = await getMarkerData();
//     // print("hello hello hello $listOfHostels");
//     List<LatLng> _markerslocation;
//     List<dynamic> mapmarkers = List<dynamic>();
//     for (HostelDetail hostel in listOfHostels) {
//       double lat = double.parse(hostel.hostel.latitude);
//       double lng = double.parse(hostel.hostel.longitude);
//       _markerslocation = [LatLng(lat, lng)];
//       mapmarkers.add(_markerslocation);
//     }
//     print("hi again $mapmarkers");
//     return (mapmarkers);
//   }

//   /// Example marker coordinates
//   final List<LatLng> _markerLocations = [
//     LatLng(41.147125, -8.611249),
//     LatLng(41.145599, -8.610691),
//     LatLng(41.145645, -8.614761),
//     LatLng(41.146775, -8.614913),
//     LatLng(41.146982, -8.615682),
//     LatLng(41.140558, -8.611530),
//     LatLng(41.138393, -8.608642),
//     LatLng(41.137860, -8.609211),
//     LatLng(41.138344, -8.611236),
//     LatLng(41.139813, -8.609381),
//   ];

//   /// Called when the Google Map widget is created. Updates the map loading state
//   /// and inits the markers.
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController.complete(controller);

//     setState(() {
//       _isMapLoading = false;
//     });

//     _initMarkers();
//     // getMarkerData();
//     getMarkers();
//   }

//   /// Inits [Fluster] and all the markers with network images and updates the loading state.
//   void _initMarkers() async {
//     final List<MapMarker> markers = [];
//     for (LatLng markerLocation in _markerLocations) {
//       final BitmapDescriptor markerImage =
//           await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

//       markers.add(
//         MapMarker(
//           id: _markerLocations.indexOf(markerLocation).toString(),
//           position: markerLocation,
//           icon: markerImage,
//         ),
//       );
//     }

//     _clusterManager = await MapHelper.initClusterManager(
//       markers,
//       _minClusterZoom,
//       _maxClusterZoom,
//     );

//     await _updateMarkers();
//   }

//   /// Gets the markers and clusters to be displayed on the map for the current zoom level and
//   /// updates state.
//   Future<void> _updateMarkers([double updatedZoom]) async {
//     if (_clusterManager == null || updatedZoom == _currentZoom) return;

//     if (updatedZoom != null) {
//       _currentZoom = updatedZoom;
//     }

//     setState(() {
//       _areMarkersLoading = true;
//     });

//     final updatedMarkers = await MapHelper.getClusterMarkers(
//       _clusterManager,
//       _currentZoom,
//       _clusterColor,
//       _clusterTextColor,
//       80,
//     );

//     _markers
//       ..clear()
//       ..addAll(updatedMarkers);

//     setState(() {
//       _areMarkersLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Markers and Clusters Example'),
//       ),
//       body: Stack(
//         children: <Widget>[
//           // Google Map widget
//           Opacity(
//             opacity: _isMapLoading ? 0 : 1,
//             child: GoogleMap(
//               mapToolbarEnabled: false,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(41.143029, -8.611274),
//                 zoom: _currentZoom,
//               ),
//               markers: _markers,
//               onMapCreated: (controller) => _onMapCreated(controller),
//               onCameraMove: (position) => _updateMarkers(position.zoom),
//             ),
//           ),

//           // Map loading indicator
//           Opacity(
//             opacity: _isMapLoading ? 1 : 0,
//             child: Center(child: CircularProgressIndicator()),
//           ),

//           // Map markers loading indicator
//           if (_areMarkersLoading)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Card(
//                   elevation: 2,
//                   color: Colors.grey.withOpacity(0.9),
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: Text(
//                       'Loading',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
