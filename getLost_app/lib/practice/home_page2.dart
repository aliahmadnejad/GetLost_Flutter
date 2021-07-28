// import 'package:getLost_app/api_connection/api_connection.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getLost_app/traveler_portal/portal_page.dart';
// // import 'package:charts_flutter/flutter.dart' as charts;

// // import 'graph_space.dart';

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

//   int _currentIndex = 0;
// //  final List<Widget> _children = [SimpleLineChart(_createSampleData())];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff0093B1),
//         automaticallyImplyLeading: false,
//         title: _currentIndex == 0 ? Text('Dashboard') : Text('Hostels'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () {
//               BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//               Navigator.of(context).pop();
//             },
//           )
//         ],
//       ),
//       // body: Center(
//       //   child: RaisedButton(
//       //     child: Text("Get Data"),
//       //     onPressed: getHostelData,
//       //   ),
//       // ),
//       body: Container(
//         child: FutureBuilder(
//           future: getHostelData(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             // print(snapshot.data);
//             if (snapshot.data == null) {
//               return Container(child: Center(child: Text("Loading...")));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // print(snapshot.data[index].hostelName);
//                   return ListTile(
//                     title: Text(snapshot.data[index].hostelName),
//                     subtitle: Text("longitude: " +
//                         snapshot.data[index].longitude +
//                         "    " +
//                         "Latitude: " +
//                         snapshot.data[index].latitude),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         // backgroundColor: Color(0xff0093B1),
//         onTap: onTabTapped,
//         currentIndex: _currentIndex,
//         // this will be set when a new tab is tapped
//         items: [
//           BottomNavigationBarItem(
//             icon: new Icon(
//               Icons.home,
//               // color: Colors.white,
//             ),
//             title: new Text('Dashboard'),
//           ),
//           BottomNavigationBarItem(
//             icon: new Icon(Icons.hotel),
//             title: new Text('Hostels'),
//           ),
//         ],
//       ),
//     );
//   }
// }
