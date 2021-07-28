// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:country_code_picker/country_localizations.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:getLost_app/api_connection/stripe_connection.dart';
// import 'package:getLost_app/bloc/authentication_bloc.dart';
// import 'package:getLost_app/api_connection/api_connection.dart';
// import 'package:getLost_app/home/settings_pages/new_card_page.dart';
// import 'package:getLost_app/model/api_model.dart';
// import 'package:getLost_app/model/hostel_model.dart';
// import 'package:getLost_app/model/user_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// // import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:stripe_sdk/stripe_sdk.dart';
// import 'package:credit_card_validator/credit_card_validator.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// // import 'dart:io';

// class HomePage extends StatefulWidget {
//   final String name;
//   final String token;
//   final TravelerSignup travelerInformation;

//   HomePage({
//     Key key,
//     @required this.name,
//     @required this.token,
//     @required this.travelerInformation,
//   });

//   @override
//   _HomeState createState() => new _HomeState(
//         name: name,
//         token: token,
//         travelerInformation: travelerInformation,
//       );
// }

// class _HomeState extends State<HomePage> {
//   final String name;
//   final String token;
//   TravelerSignup travelerInformation;
//   _HomeState({
//     this.name,
//     this.token,
//     this.travelerInformation,
//   });

//   final _stripePublishableKey =
//       'pk_test_51H0CQsHCy8Q2hv8oOWqUqzmCH9x80R555acMCP1QPVmbcLrF47nX2pwBgqUxsOsFjUUoyp0MYvLBCSUMbhBHqISx002ei3qvVk';
//   // final _returnUrl = 'stripesdk://demo.stripesdk.ezet.io';
//   // final _returnUrlWeb = 'http://demo.stripesdk.ezet.io';

//   // String getScaReturnUrl() {
//   //   return kIsWeb ? _returnUrlWeb : _returnUrl;
//   // }

//   TravelerSignup data;
//   List<dynamic> databaseItems;
//   List<HostelDetail> listOfHostelDetails;
//   List<TravelerSignup> listOfTravelerDetails;
//   TravelerSignup t;
//   int travelerId;
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   Completer<GoogleMapController> _controller = Completer();
//   // Completer<GoogleMapController> _controllerPanel = Completer();
//   LatLng _initialCameraPosition = LatLng(33.812511, -117.918976);
//   // LatLng _initialCameraPosition = LatLng(37.773972, -122.431297);
//   GoogleMapController _controller2;
//   // GoogleMapController _controller2Panel;

//   // you use 'locateUser() too many times with setState() to change these variables
//   geo.Position geoLocation;
//   LatLng _center;
//   LatLng _centerPanel = LatLng(33.812511, -117.918976);
//   // LatLng _centerPanel = LatLng(37.773972, -122.431297);

//   var _searchController = TextEditingController();
//   String searchAddress;
//   PanelController _panelController = new PanelController();
//   PanelController _panelController2 = new PanelController();
//   PanelController _panelController3 = new PanelController();
//   BitmapDescriptor pinLocationIcon;
//   bool _searchBarVisible = true;
//   bool bookingPageVisible = false;
//   bool infoPageVisible = false;
//   double menuPageSize;
//   bool menuPageVisible = false;
//   bool menuAccountVisible = false;
//   bool menuContactVisible = false;
//   bool menuPaymentVisible = false;

//   HostelDetail hdp;
//   String hdpString;

//   HostelDetail hostelPanel;
//   String hostelPanelName;
//   String hostelPanelCurrency;
//   var hostelPanelPrice;
//   var hostelPanelAvaliability;
//   String hostelPanelAddress;
//   var hostelPanelPhone;
//   String hostelPanelEmail;
//   String hostelPanelWebsite;
//   LatLng hostelPanelLocation;

//   DateTime now = DateTime.now();

//   // Object for PolylinePoints
//   PolylinePoints polylinePoints;
//   // List of coordinates to join
//   List<LatLng> polylineCoordinates = [];
//   // Map storing polylines created by connecting
//   // two points
//   Map<PolylineId, Polyline> polylines = {};
//   // Set<Polyline> selectedPolylines = {};

//   // Future<void> _launched;

//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _middleNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emergencyNameController =
//       TextEditingController();
//   final TextEditingController _emergencyPhoneController =
//       TextEditingController();
//   final TextEditingController _emergencyRelationController =
//       TextEditingController();
//   final TextEditingController _emergencyEmailController =
//       TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _oldPasswordController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _newPassword2Controller = TextEditingController();

//   StreamSubscription<Position> positionStream;
//   Timer _timer;

//   TravelerStripeInfo stripeCustomer;
//   List<Cards> stripeCustomerCards = [];
//   Cards stripeCustomerdefaultCard;

//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String cardIconPath = '';

//   String getCardIcon(String cardType) {
//     switch (cardType) {
//       case 'American Express':
//         cardIconPath = "assets/images/card_types/american_express.png";
//         break;
//       case 'Diners Club':
//         cardIconPath = "assets/images/card_types/diners_club.png";
//         break;
//       case 'Discover':
//         cardIconPath = "assets/images/card_types/discover.png";
//         break;
//       case 'JCB':
//         cardIconPath = "assets/images/card_types/jcb.png";
//         break;
//       case 'MasterCard':
//         cardIconPath = "assets/images/card_types/mastercard2.png";
//         break;
//       case 'UnionPay':
//         cardIconPath = "assets/images/card_types/credit_card.png";
//         break;
//       case 'Visa':
//         cardIconPath = "assets/images/card_types/visa_electron.png";
//         break;
//       case 'Unknown':
//         cardIconPath = "assets/images/card_types/credit_card.png";
//         break;
//     }
//     return cardIconPath;
//   }

//   void onPress() async {
//     // print('pressed $id');
//     data = await getTraveler();
//     setState(() {
//       travelerInformation = data;
//     });
//     print(travelerInformation.toString());
//   }

//   getDateAndDay(DateTime date) {
//     DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

//     dateFormate(DateTime date) {
//       var monthValue = date.month;
//       String month;
//       switch (monthValue) {
//         case 1:
//           month = "January";
//           break;
//         case 2:
//           month = "February";
//           break;
//         case 3:
//           month = "March";
//           break;
//         case 4:
//           month = "April";
//           break;
//         case 5:
//           month = "May";
//           break;
//         case 6:
//           month = "June";
//           break;
//         case 7:
//           month = "July";
//           break;
//         case 8:
//           month = "August";
//           break;
//         case 9:
//           month = "September";
//           break;
//         case 10:
//           month = "October";
//           break;
//         case 11:
//           month = "November";
//           break;
//         case 12:
//           month = "December";
//           break;
//       }
//       String newDate = "${date.day.toString()} $month ${date.year.toString()}";
//       return newDate;
//     }

//     dayFormate(DateTime date) {
//       var dayValue = date.weekday;
//       String day;

//       switch (dayValue) {
//         case 1:
//           day = "Monday";
//           break;
//         case 2:
//           day = "Tuesday";
//           break;
//         case 3:
//           day = "Wednesday";
//           break;
//         case 4:
//           day = "Thursday";
//           break;
//         case 5:
//           day = "Friday";
//           break;
//         case 6:
//           day = "Saturday";
//           break;
//         case 7:
//           day = "Sunday";
//           break;
//       }
//       return day;
//     }

//     String todayDate = dateFormate(date);
//     String tomorrowDate = dateFormate(tomorrow);
//     String todayDay = dayFormate(date);
//     String tomorrowDay = dayFormate(tomorrow);

//     Map<String, String> datesAndDays = {
//       "todayDate": todayDate,
//       "tomorrowDate": tomorrowDate,
//       "todayDay": todayDay,
//       "tomorrowDay": tomorrowDay
//     };

//     // print(datesAndDays);
//     return datesAndDays;
//   }

//   toCurrencySymbol(code) {
//     String symbol;
//     if (code == "USD") {
//       symbol = r"$";
//     } else if (code == "EUR") {
//       symbol = "€";
//     } else if (code == "GBP") {
//       symbol = "£";
//     }
//     return symbol;
//   }

//   Future<void> callNow(String url) async {
//     String urlString = ("tel://$url");
//     if (await UrlLauncher.canLaunch(urlString)) {
//       await UrlLauncher.launch(urlString);
//     } else {
//       throw 'call not possible $urlString';
//     }
//   }

//   // Map loading flag
//   bool _isMapLoading = true;
//   // Marker loading flag
//   bool _areMarkersLoading = false;
//   TravelerSignup travelerProfile;
//   final _base = "https://getlost-245519.wl.r.appspot.com";

//   changeTravelerNames(TravelerSignup names) async {
//     // print("1 the travelers token is ------ $token");
//     // print("1 the travelers username is ------ $name");
//     final String adminToken = await getAdminToken();
//     final http.Response response = await http.patch(
//       "$_base/api/travelerprofile/${travelerInformation.id}/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $token'
//       },
//       body: jsonEncode(names.toDatabaseJsonNames()),
//     );
//   }

//   changeTravelerContacts(TravelerSignup contacts) async {
//     final http.Response response = await http.patch(
//       "$_base/api/travelerprofile/${travelerInformation.id}/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $token'
//       },
//       body: jsonEncode(contacts.toDatabaseJsonContact()),
//     );
//   }

//   changeTravelerEmergencyContacts(TravelerSignup emergencyContacts) async {
//     final http.Response response = await http.patch(
//       "$_base/api/travelerprofile/${travelerInformation.id}/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $token'
//       },
//       body: jsonEncode(emergencyContacts.toDatabaseJsonEmergencyContact()),
//     );
//   }

//   changeTravelerCountry(TravelerSignup travelerCountry) async {
//     final http.Response response = await http.patch(
//       "$_base/api/travelerprofile/${travelerInformation.id}/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $token'
//       },
//       body: jsonEncode(travelerCountry.toDatabaseJsonCountry()),
//     );
//   }

//   changeTravelerPassword(Password passwords) async {
//     final http.Response response = await http.put(
//       "$_base/api/change_password/${travelerInformation.user.id}/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $token'
//       },
//       body: jsonEncode(passwords.toDatabaseJson()),
//     );
//   }

//   postReservation(Reservation reservation) async {
//     final String adminToken = await getAdminToken();
//     final http.Response response = await http.post(
//       "$_base/api/reservations/create/",
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Token $adminToken'
//       },
//       body: jsonEncode(reservation.toDatabaseJson()),
//     );
//     // if (response.statusCode == 201) {
//     //   print(response);
//     //   print("Error");
//     // } else {
//     //   print(json.decode(response.body).toString());
//     //   throw Exception(json.decode(response.body));
//     // }
//   }

// /*   Future<String> getEphemeralKey() async {
//     http.Response response = await http.get(
//         "http://127.0.0.1:8000/api/travelerstripe/${travelerInformation.id}/",
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Token $token'
//         });
//     Map<String, dynamic> databaseItem = json.decode(response.body);
//     // var databaseItem = json.decode(response.body);
//     print("here it is bitch: $databaseItem");

//     // TravelerStripe person = TravelerStripe.fromDatabaseJson(databaseItem);
//     // print(person.toDatabaseJson());
//     // final key = person.ephemeralKey;
//     // final ephemeralKey = jsonEncode(person.toDatabaseJson());
//     // print("Helloooooooo $key");
//     StripeModel key = StripeModel.fromDatabaseJson(databaseItem);
//     print("Before the main one     ${key.toDatabaseJson()}");
//     String ephemeralKey = key.ephemeralKey.toString();
//     print(ephemeralKey);
//     final finalKey = jsonEncode(key.ephemeralKey.toDatabaseJson());
//     print("here is the ${finalKey.toString()}");

//     // CustomerSession.initCustomerSession((version) => response.body);
//     // TravelerStripe ephemeralKey = databaseItem
//     //     .map((data) => TravelerStripe.fromDatabaseJson(data))
//     //     .toList();
//     // List<TravelerStripe> ephemeralKey = (databaseItem as List)
//     //     .map((data) => TravelerStripe.fromDatabaseJson(data))
//     //     .toList();
//     // print("Here is the Ephemeral Key:  $ephemeralKey");
//     return ephemeralKey;
//   } */

//   getTravelerStripeInformation() async {
//     TravelerStripeInfo customer =
//         await StripeService.getStripeCustomer(travelerInformation.stripeId);

//     String defaultCardId = customer.defaultSource;
//     // print("Current default card ID: $defaultCardId");
//     Cards defaultCard;
//     List<Cards> cards = [];
//     var index = 1;
//     for (Cards item in customer.sources.data) {
//       // print("Card number $index is: ${item.toString()}");
//       cards.add(item);
//       index++;
//     }
//     // print(cards);
//     for (Cards card in cards) {
//       // print(card.last4);
//       if (card.id == defaultCardId) {
//         defaultCard = card;
//       }
//     }
//     if (mounted)
//       setState(() {
//         stripeCustomer = customer;
//         stripeCustomerdefaultCard = defaultCard;
//         stripeCustomerCards = cards;

//         // print(stripeCustomer.toString());
//       });
//     return customer;
//   }

//   getHostelData() async {
//     final String adminToken = await getAdminToken();
//     http.Response response = await http.get("$_base/api/hostelroomdetail/",
//         // "http://getlost-245519.wl.r.appspot.com/api/hostelroomdetail/",
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': 'Token $adminToken'
//         });
//     databaseItems = json.decode(response.body);
//     if (mounted)
//       setState(() {
//         listOfHostelDetails = databaseItems
//             .map((data) => HostelDetail.fromDatabaseJson(data))
//             .toList();
//         // print(listOfHostelDetails);
//       });

//     // print(listOfHostelDetails);
//     int index = 0;
//     for (HostelDetail hostel in listOfHostelDetails) {
//       index += 1;
//       // print("hostel number $index is: $hostel");
//       initMarker(hostel);
//     }
//     return listOfHostelDetails;
//   }

//   void initMarker(hostelInfo) async {
//     HostelDetail hostelData = hostelInfo;
//     var hostelId = (hostelData.hostel.id).toString();
//     var hostelCost = ((hostelData.price).toString()).substring(0, 2);
//     var hostelCurrency = toCurrencySymbol(hostelData.currency);
//     var markerId = MarkerId(hostelId);
//     // final Uint8List markerIcon =
//     //     await getBytesFromCanvas(80, 80, hostelCost, hostelCurrency);
//     LatLng markerLocation = LatLng((double.parse(hostelData.hostel.latitude)),
//         (double.parse(hostelData.hostel.longitude)));
//     // print(markerId);
//     // print(markerLocation);
//     BitmapDescriptor icon = await getMarkerIcon(
//         "assets/images/markerIcon_whiteBorder2.png",
//         Size(100.0, 100.0),
//         hostelCost,
//         hostelCurrency);

//     final Marker marker = Marker(
//         markerId: markerId,
//         position: markerLocation,
//         // icon: BitmapDescriptor.fromBytes(markerIcon),
//         // icon: pinLocationIcon
//         icon: icon,
//         onTap: () async {
//           print("The marker has been selected");
//           // print(markerId);
//           // print((hostelData.hostel.hostelName).toString());
//           if (mounted)
//             _openPopup(context, hostelData, icon, markerId, markerLocation);
//           geoLocation = await locateUser();
//           if (mounted)
//             setState(() {
//               _center = LatLng(geoLocation.latitude, geoLocation.longitude);
//               _centerPanel =
//                   LatLng(geoLocation.latitude, geoLocation.longitude);
//               // print("The center is :    $_centerPanel");
//             });
//         });
//     // print(marker);
//     if (mounted)
//       setState(() {
//         markers[markerId] = marker;
//         // print(markers);
//         // print(Set<Marker>.of(markers.values));
//       });
//   }

//   Marker selectedMarker;
//   Polyline selectedLine;

//   _openPopup(BuildContext context, HostelDetail hostelData,
//       BitmapDescriptor icon, var markerId, LatLng markerLocation) async {
//     HostelDetail data = hostelData;
//     hostelPanelLocation = LatLng(double.parse(data.hostel.latitude),
//         double.parse(data.hostel.longitude));
//     geoLocation = await locateUser();
//     _centerPanel = LatLng(geoLocation.latitude, geoLocation.longitude);

//     selectedLine = await _createPolylines(_centerPanel, hostelPanelLocation);
//     if (mounted)
//       setState(() {
//         _searchBarVisible = false;
//         bookingPageVisible = false;
//         selectedMarker = Marker(
//             markerId: markerId,
//             position: markerLocation,
//             icon: icon,
//             consumeTapEvents: true);
//         selectedLine = selectedLine;

//         // hdp = data;
//       });
//     // print("The location is $hostelPanelLocation");
//     // print("The users location is $_center");

//     // print("The hostel name is: ${data.hostel.hostelName}");

//     return showGeneralDialog(
//       barrierLabel: "Label",
//       barrierDismissible: false,
//       // barrierColor: Colors.black.withOpacity(0.5),
//       barrierColor: null,
//       transitionDuration: Duration(milliseconds: 700),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 200,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0, right: 0.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             // Expanded(
//                             //   child:
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width / 1.6,
//                                 // child: Expanded(
//                                 child: Text(
//                                   "${data.hostel.hostelName}",
//                                   overflow: TextOverflow.ellipsis,
//                                   softWrap: false,
//                                   style: TextStyle(
//                                     fontSize: 24.0,
//                                     color: Colors.black,
//                                     fontFamily: "SF-Pro-SB",
//                                   ),
//                                 ),
//                                 // ),
//                               ),
//                             ),
//                             // ),
//                             // Expanded(
//                             //   child:
//                             ButtonTheme(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 0.0, right: 0),
//                                 child: FlatButton(
//                                   height: 25,
//                                   minWidth: 15,
//                                   onPressed: () {
//                                     setState(() {
//                                       _searchBarVisible = true;
//                                     });
//                                     // _panelController.close();
//                                     Navigator.of(context, rootNavigator: true)
//                                         .pop('dialog');
//                                   },
//                                   child: Icon(
//                                     Icons.close,
//                                     color: Color(0xff707070),
//                                     size: 20.0,
//                                   ),
//                                   // padding: EdgeInsets.only(right: 0.0),
//                                   shape: CircleBorder(),
//                                   color: Color(0xffECEBE9),
//                                 ),
//                               ),
//                             ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 39.0, right: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             // Expanded(
//                             // child:
//                             Padding(
//                               padding:
//                                   // const EdgeInsets.only(right: 36.0),
//                                   const EdgeInsets.only(right: 0.0),
//                               child: Column(
//                                 children: <Widget>[
//                                   Text(
//                                     "Total Price:",
//                                     style: TextStyle(
//                                       fontSize: 14.0,
//                                       color: Colors.black,
//                                       fontFamily: "SF-Pro-Regular",
//                                     ),
//                                   ),
//                                   Text(
//                                     "${toCurrencySymbol(data.currency)} ${data.price}",
//                                     style: TextStyle(
//                                       fontSize: 25.0,
//                                       color: Colors.black,
//                                       fontFamily: "SF-Pro-SB",
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             // ),
//                             // Expanded(
//                             // child:
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 0.0,
//                                   bottom: 0.0,
//                                   left: 25.0,
//                                   right: 0.0),
//                               child: FlatButton(
//                                 minWidth:
//                                     MediaQuery.of(context).size.width / 2.2,
//                                 height: MediaQuery.of(context).size.height / 16,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                                 color: Color(0xff0093B1),
//                                 textColor: Colors.white,
//                                 onPressed: () {
//                                   print(
//                                       "The Customers ID is - ${travelerInformation.id} and Name is - ${travelerInformation.user.username}");
//                                   print(
//                                       "The Hostels ID is - ${data.hostel.id} and Name is - ${data.hostel.hostelName}");
//                                   Reservation pr = Reservation(
//                                       hostelId: data.hostel.id,
//                                       travelerId: travelerInformation.id,
//                                       isCheckedIn: false,
//                                       isConfirmed: false);
//                                   print(
//                                       "hostel ID: ${pr.hostelId} - traveler ID: ${pr.travelerId} - is checked in: ${pr.isCheckedIn} - is confirmed: ${pr.isConfirmed}");
//                                   print(pr.toDatabaseJson());
//                                   // postReservation(pr);
//                                   setState(() {
//                                     bookingPageVisible = true;
//                                     infoPageVisible = false;
//                                     hdp = data;
//                                     hdpString = data.hostel.hostelName;
//                                     hostelPanel = data;
//                                     hostelPanelName = data.hostel.hostelName;
//                                     hostelPanelCurrency = data.currency;
//                                     hostelPanelPrice = data.price;
//                                     hostelPanelAvaliability = data.avaliability;
//                                     hostelPanelAddress =
//                                         ("${data.hostel.address} ${data.hostel.cityState} ${data.hostel.country} ${data.hostel.zipCode}");
//                                     hostelPanelPhone = data.hostel.phone;
//                                     hostelPanelEmail = data.hostel.email;
//                                     hostelPanelWebsite = data.hostel.website;
//                                     hostelPanelLocation = LatLng(
//                                         double.parse(data.hostel.latitude),
//                                         double.parse(data.hostel.longitude));
//                                     _searchBarVisible = true;
//                                   });
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                   if (_panelController2.isPanelClosed) {
//                                     _panelController2.open();
//                                   } else {
//                                     _panelController2.close();
//                                   }
//                                 },
//                                 child: Text(
//                                   "Book!",
//                                   style: TextStyle(
//                                     fontSize: 26.0,
//                                     // color: Colors.black,
//                                     fontFamily: "SF-Pro-Medium",
//                                   ),
//                                 ),
//                               ),
//                             )
//                             // ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       Row(
//                         // crossAxisAlignment: CrossAxisAlignment.end,
//                         // mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           Padding(
//                               padding:
//                                   const EdgeInsets.only(bottom: 0.0, left: 0),
//                               // child: Expanded(
//                               child: FlatButton(
//                                 onPressed: () {
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                   if (_panelController2.isPanelClosed) {
//                                     _panelController2.open();
//                                   } else {
//                                     _panelController2.close();
//                                   }

//                                   setState(() {
//                                     hdp = data;
//                                     hdpString = data.hostel.hostelName;
//                                     hostelPanel = data;
//                                     hostelPanelName = data.hostel.hostelName;
//                                     hostelPanelCurrency = data.currency;
//                                     hostelPanelPrice = data.price;
//                                     hostelPanelAvaliability = data.avaliability;
//                                     hostelPanelAddress =
//                                         ("${data.hostel.address} ${data.hostel.cityState} ${data.hostel.country} ${data.hostel.zipCode}");
//                                     hostelPanelPhone = data.hostel.phone;
//                                     hostelPanelEmail = data.hostel.email;
//                                     hostelPanelWebsite = data.hostel.website;
//                                     _searchBarVisible = true;
//                                     infoPageVisible = true;

//                                     hostelPanelLocation = LatLng(
//                                         double.parse(data.hostel.latitude),
//                                         double.parse(data.hostel.longitude));
//                                   });

//                                   // maybe setstate to the hostel data so that you can transfer it to the panel since
//                                   // its hard to find another way.
//                                 },
//                                 child: Text(
//                                   "more \u2228",
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Color(0xff8B8985),
//                                     fontFamily: "SF-Pro-Regular",
//                                   ),
//                                 ),
//                               )
//                               // ),
//                               ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position:
//               Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
//           child: child,
//         );
//       },
//     );
//   }

//   Future<ui.Image> loadUiImage(String imageAssetPath) async {
//     final ByteData data = await rootBundle.load(imageAssetPath);
//     final Completer<ui.Image> completer = Completer();
//     ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
//       return completer.complete(img);
//     });
//     return completer.future;
//   }

//   Future<BitmapDescriptor> getMarkerIcon(
//       String imagePath, Size size, String price, String currency) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);

//     // Oval for the image
//     Rect oval =
//         Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble());

//     // Add image
//     ui.Image image = await loadUiImage(
//         imagePath); // Alternatively use your own method to get the image
//     paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitHeight);

//     // Add tag text
//     TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
//     textPainter.text = TextSpan(
//       text: "$currency$price",
//       style: TextStyle(
//         fontSize: 30.0,
//         color: Colors.white,
//         fontFamily: "SF-Pro-Bold",
//       ),
//     );

//     textPainter.layout();
//     textPainter.paint(
//         canvas,
//         Offset((size.width * 0.5) - textPainter.width * 0.5,
//             (size.height * 0.45) - textPainter.height * 0.5));

//     // Add path for oval image
//     canvas.clipPath(Path()..addOval(oval));

//     // Convert canvas to image
//     final ui.Image markerAsImage = await pictureRecorder
//         .endRecording()
//         .toImage(size.width.toInt(), size.height.toInt());

//     // Convert image to bytes
//     final ByteData byteData =
//         await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
//     final Uint8List uint8List = byteData.buffer.asUint8List();

//     return BitmapDescriptor.fromBytes(uint8List);
//   }

//   Future<LatLngBounds> _getVisibleRegion() async {
//     final GoogleMapController controller = await _controller.future;
//     final LatLngBounds bounds = await controller.getVisibleRegion();
//     // print("bounds are $bounds");
//     return bounds;
//   }

//   checkMarkers() async {
//     LatLngBounds bounds = await _getVisibleRegion();
//     Set<Marker> markerss = Set<Marker>.of(markers.values);
//     Marker mark;
//     List<dynamic> contained = List<dynamic>();

//     if (markerss.isNotEmpty) {
//       markerss.forEach((marker) {
//         // print("Marker ID: ${marker.markerId}");
//         // print(
//         // 'Position: ${marker.position} - Contains: ${bounds.contains(marker.position)}');
//         if (bounds.contains(marker.position) == true) {
//           mark = marker;
//           contained.add(mark);
//         }
//       });
//       // print(contained.length);
//     }
//     return contained;
//   }

//   listHostel() async {
//     List<dynamic> m = await checkMarkers();
//     // List<dynamic> h = await getHostelData();
//     List<dynamic> h = listOfHostelDetails;
//     List<dynamic> hostelsOnMap = List<dynamic>();
//     if (m.isNotEmpty && h != null) {
//       // print("List of markers ON THE MAP ------- $m");
//       // print("List of Hostels ------- $h");
//       // print("LIST OF HOSTEL DETAILS +++++===== $listOfHostelDetails");
//       // m.forEach((element) {
//       //   print("MARKER ID ${element.markerId.value}");
//       // });
//       // h.forEach((element) {
//       //   print("HOSTEL ID ${element.hostel.id}");
//       // });
//       m.forEach((marker) {
//         h.forEach((hostel) {
//           if (int.parse(marker.markerId.value) == hostel.hostel.id) {
//             String price = hostel.price.substring(0, 2);
//             // print("Hostels that are on the map ${hostel.hostel.id}");
//             // print("hostel price ${hostel.price}");
//             // print("Sub string price $price");
//             hostelsOnMap.add(hostel);
//           }
//         });
//       });
//       // print("The hostels we will use $hostelsOnMap");
//     }

//     return hostelsOnMap;
//   }

//   void _onMapCreated(GoogleMapController _cntlr) async {
//     _controller.complete(_cntlr);
//     _controller2 = _cntlr;
//     setState(() {
//       _isMapLoading = false;
//     });
//     // Error here because this function is called at the start twice (function 1/2)
//     print("getUserLocation run (1)");
//     await getUserLocation();
//     // checkMarkers();
//   }

//   Future<geo.Position> locateUser() async {
//     var currentLocation;
//     print("--------------locateuser has run!!");
//     try {
//       currentLocation = await geo.Geolocator()
//           .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
//     } catch (e) {
//       print("current location = Null");
//       currentLocation = null;
//     }
//     return currentLocation;

//     // return geo.Geolocator()
//     // .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
//   }

//   getUserLocation() async {
//     // print("button pressed");
//     geoLocation = await locateUser();
//     setState(() {
//       _center = LatLng(geoLocation.latitude, geoLocation.longitude);
//     });
//     print('center $_center');
//     _controller2.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: _center, zoom: 16),
//       ),
//     );
//   }

//   getDirectionView(LatLng startCoordinates, LatLng destinationCoordinates,
//       GoogleMapController controller) {
//     // Define two position variables
//     LatLng _northeastCoordinates;
//     LatLng _southwestCoordinates;

// // Calculating to check that
// // southwest coordinate <= northeast coordinate
//     if (startCoordinates.latitude <= destinationCoordinates.latitude) {
//       _southwestCoordinates = startCoordinates;
//       _northeastCoordinates = destinationCoordinates;
//     } else {
//       _southwestCoordinates = destinationCoordinates;
//       _northeastCoordinates = startCoordinates;
//     }

// // Accommodate the two locations within the
// // camera view of the map
//     controller.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           northeast: _northeastCoordinates,
//           southwest: _southwestCoordinates,
//         ),
//         40.0, // padding
//       ),
//     );
//   }

//   searchAndNavigate() {
//     geo.Geolocator().placemarkFromAddress(searchAddress).then((result) {
//       _controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target:
//               LatLng(result[0].position.latitude, result[0].position.longitude),
//           zoom: 10.0)));
//     });
//   }

// // Create the polylines for showing the route between two places
//   _createPolylines(LatLng start, LatLng destination) async {
//     polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyDJ-TSQ5f2kwiGcnJBv2RWm5fhkEJy4DpA", // Google Maps API Key
//       PointLatLng(start.latitude, start.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//       travelMode: TravelMode.transit,
//     );

//     polylineCoordinates.clear();
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }

//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Color(0xff0093B1),
//       points: polylineCoordinates,
//       width: 4,
//       jointType: JointType.round,
//     );
//     // polylines[id] = polyline;
//     return polyline;
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Future<String> ephKey = getEphemeralKey();
//     // getEphemeralKey();
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey:
//             'pk_test_51H0CQsHCy8Q2hv8oOWqUqzmCH9x80R555acMCP1QPVmbcLrF47nX2pwBgqUxsOsFjUUoyp0MYvLBCSUMbhBHqISx002ei3qvVk',
//         merchantId: 'tomasmbriseno@gmail.com',
//         androidPayMode: 'test',
//       ),
//     );

//     getTravelerStripeInformation();
//     print("this is the stripe acount: ${stripeCustomer.toString()}");

//     // StripeService.init();

//     // var owner = StripePayment.setStripeAccount(travelerInformation.stripeId);
//     // print("The Stripe Customer Account is: $owner ");

//     // final session = CustomerSession.instance;
//     // var value = session.retrieveCurrentCustomer();

//     // HERE

//     // CustomerSession.initCustomerSession((version) => getEphemeralKey());

//     // CustomerSession.initCustomerSession(
//     //   getEphemeralKey(),
//     //   (apiVersion) => null,
//     //   stripeAccount: travelerInformation.stripeId,
//     //   prefetchKey: true,
//     // );
//     // final sess = CustomerSession.instance;
//     // var value = sess.retrieveCurrentCustomer();
//     // print("The Stripe Customer Account is: ${sess} ");

//     // final session = CustomerSession((apiVersion) => server.getEphemeralKeyFromServer(apiVersion));
//     // final stripe = Stripe(_stripePublishableKey,
//     //     returnUrlForSca: 'stripesdk://3ds.stripesdk.io',
//     //     stripeAccount: travelerInformation.stripeId);
//     // CustomerSession.initCustomerSession((version) => locator.get<NetworkService>().getEphemeralKey(version));

//     // getTravelerData();
//     getHostelData();
//     _timer = Timer.periodic(Duration(seconds: 30), (_) {
//       // print("Get Hostel Detail Again");
//       getHostelData();
//     });

//     // Error here because this function is called at the start twice (function 2/2)
//     // getUserLocation();

//     // print(now.hour.toString() +
//     //     ":" +
//     //     now.minute.toString() +
//     //     ":" +
//     //     now.second.toString());
//     // print(now.weekday.toString());
//     getDateAndDay(now);

//     positionStream = geo.Geolocator()
//         .getPositionStream(
//             LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 10))
//         .listen((position) {
//       // Do something here
//       if (position == null) {
//         print("it is null");
//       } else {
//         print("The user position has changed:    $position");
//         // geoLocation = await locateUser();
//         _center = LatLng(position.latitude, position.longitude);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller2.dispose();
//     _searchController.dispose();
//     _timer.cancel();
//     positionStream.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // CustomerSession.initCustomerSession((version) => getEphemeralKey());
//     return Material(
//       child: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           print("Gesture detector: outside search bar pressed");
//           /*This method here will hide the soft keyboard.*/
//           // FocusScope.of(context).requestFocus(new FocusNode());
//           // FocusScope.of(context).unfocus();
//           FocusScopeNode currentFocus = FocusScope.of(context);

//           if (!currentFocus.hasPrimaryFocus) {
//             currentFocus.unfocus();
//           }
//         },
//         child: Stack(
//           children: <Widget>[
//             SlidingUpPanel(
//               backdropEnabled: true,
//               panelBuilder: (ScrollController sc) => _scrollingList(sc),
//               controller: _panelController,
//               maxHeight: MediaQuery.of(context).size.height - 60,
//               minHeight: 0,
//               border: Border.all(color: Color(0xffE9E7E3), width: 2),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(18.0),
//                   topRight: Radius.circular(18.0)),
//               header: Padding(
//                 padding: const EdgeInsets.only(right: 0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 5.0),
//                     child: Row(
//                       children: <Widget>[
//                         const Spacer(),
//                         Expanded(
//                             child: Center(
//                                 child: Icon(
//                           Icons.horizontal_rule_rounded,
//                           color: Color(0xffC2C1C1),
//                           size: 50,
//                         ))),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: ButtonTheme(
//                               padding: EdgeInsets.only(right: 0),
//                               child: FlatButton(
//                                 height: 25,
//                                 minWidth: 25,
//                                 onPressed: () {
//                                   _panelController.close();
//                                 },
//                                 child: Icon(
//                                   Icons.close_rounded,
//                                   color: Color(0xff707070),
//                                   size: 20.0,
//                                 ),
//                                 // padding: EdgeInsets.all(0.0),
//                                 shape: CircleBorder(),
//                                 color: Color(0xffECEBE9),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               body: Scaffold(
//                 extendBodyBehindAppBar: true,
//                 appBar: AppBar(
//                   automaticallyImplyLeading: false,
//                   backgroundColor: Colors.transparent,
//                   elevation: 0.0,
//                   actions: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(right: 20.0),
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Row(
//                           children: [
//                             ButtonTheme(
//                               minWidth: MediaQuery.of(context).size.width / 12,
//                               height: MediaQuery.of(context).size.height / 20,
//                               child: RaisedButton(
//                                 color: Color(0xffFBF9F8),
//                                 // color: Colors.blue,
//                                 elevation: 2.5,
//                                 shape: RoundedRectangleBorder(
//                                   side: BorderSide(
//                                     color: Color(0xffE9E7E3),
//                                     width: 0.5,
//                                   ),
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(12),
//                                       topRight: Radius.circular(0),
//                                       bottomLeft: Radius.circular(12),
//                                       bottomRight: Radius.circular(0)),
//                                 ),
//                                 onPressed: () {
//                                   if (_panelController.isPanelClosed) {
//                                     _panelController.open();
//                                   } else {
//                                     _panelController.close();
//                                   }
//                                 },
//                                 child: Icon(
//                                   Icons.menu,
//                                   color: Color(0xff9F9F9F),
//                                 ),
//                               ),
//                             ),
//                             ButtonTheme(
//                               minWidth: MediaQuery.of(context).size.width / 12,
//                               height: MediaQuery.of(context).size.height / 20,
//                               child: RaisedButton(
//                                 color: Color(0xffFBF9F8),
//                                 elevation: 2.5,
//                                 shape: RoundedRectangleBorder(
//                                   side: BorderSide(
//                                       color: Color(0xffE9E7E3), width: 0.5),
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(0),
//                                       topRight: Radius.circular(12),
//                                       bottomLeft: Radius.circular(0),
//                                       bottomRight: Radius.circular(12)),
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     menuPageVisible = true;
//                                     menuAccountVisible = false;
//                                     menuContactVisible = false;
//                                     menuPaymentVisible = false;
//                                   });
//                                   // print("3 the travelers token is ------ $token");
//                                   // print(
//                                   //     "3 the travelers username is ------ $name");
//                                   // print(
//                                   //     "3 the travelers username is ------ ${travelerInformation.id}");
//                                   if (_panelController3.isPanelClosed) {
//                                     _panelController3.open();
//                                   } else {
//                                     _panelController3.close();
//                                   }
//                                 },
//                                 child: Icon(
//                                   Icons.more_vert,
//                                   color: Color(
//                                     0xff9F9F9F,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 body: Stack(children: <Widget>[
//                   Opacity(
//                     opacity: _isMapLoading ? 0 : 1,
//                     child: GoogleMap(
//                       onMapCreated: _onMapCreated,
//                       zoomGesturesEnabled: true,
//                       mapType: MapType.normal,
//                       myLocationButtonEnabled: false,
//                       myLocationEnabled: true,
//                       zoomControlsEnabled: true,
//                       scrollGesturesEnabled: true,
//                       compassEnabled: true,
//                       // markers:
//                       initialCameraPosition: //getUserLocation(),
//                           CameraPosition(
//                               target: _initialCameraPosition, zoom: 3),
//                       markers: Set<Marker>.of(markers.values),
//                       onCameraIdle: () async {
//                         // geoLocation = await locateUser();
//                         setState(() {
//                           // print("3 the travelers token is ------ $token");
//                           // print("3 the travelers username is ------ $name");
//                           // print(
//                           //     "3 the travelers username is ------ ${travelerInformation.id}");
//                           // _centerPanel =
//                           //     LatLng(geoLocation.latitude, geoLocation.longitude);
//                           checkMarkers();
//                           listHostel();
//                         });
//                       },
//                       // onMapCreated: (GoogleMapController controller) async {
//                       //   _controller.complete(controller);
//                       //   checkMarkers();
//                       // },
//                     ),
//                   ),
//                   // Map loading indicator
//                   Opacity(
//                     opacity: _isMapLoading ? 1 : 0,
//                     child: Center(child: CircularProgressIndicator()),
//                   ),
//                   // Map markers loading indicator
//                   if (_areMarkersLoading)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 40.0),
//                       child: Align(
//                         alignment: Alignment.topCenter,
//                         child: Card(
//                           elevation: 2,
//                           color: Colors.grey.withOpacity(0.9),
//                           child: Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: Text(
//                               'Loading',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                       bottom: 30,
//                       right: 20,
//                       left: 20,
//                       child: Visibility(
//                         visible: _searchBarVisible,
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
//                           child: Row(
//                             children: <Widget>[
//                               IconButton(
//                                 padding: EdgeInsets.only(
//                                     top: 6, bottom: 2, left: 2, right: 2),
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
//                                   keyboardAppearance: Brightness.light,
//                                   controller: _searchController,
//                                   textInputAction: TextInputAction.search,
//                                   cursorColor: Color(0xff9F9F9F),
//                                   // keyboardType: TextInputType.text,
//                                   // textInputAction: TextInputAction.go,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         top: 10,
//                                         bottom: 8,
//                                         left: 10,
//                                         right: 10),
//                                     // EdgeInsets.symmetric(horizontal: 1),
//                                     hintText: "Search for a hostel or address",
//                                     hintStyle: TextStyle(
//                                         color: Color(0xff9F9F9F),
//                                         fontFamily: "SF-Pro-Regular",
//                                         fontSize:
//                                             MediaQuery.of(context).size.width /
//                                                 26),
//                                   ),
//                                   onSubmitted: (val) {
//                                     //   setState(() {
//                                     //     searchAddress = val;
//                                     //   });
//                                     searchAndNavigate();
//                                   },
//                                   onChanged: (val) {
//                                     setState(() {
//                                       searchAddress = val;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Padding(
//                                   padding: const EdgeInsets.only(right: 4.0),
//                                   child: IconButton(
//                                     padding: EdgeInsets.only(bottom: 1, top: 4),
//                                     icon: Icon(Icons.near_me),
//                                     color: Color(0xff0093B1),
//                                     onPressed: () async {
//                                       print(
//                                           "location button pressed - getUserLocation run (2)");
//                                       await getUserLocation();
//                                     },
//                                   )),
//                             ],
//                           ),
//                         ),
//                       )),
//                 ]),
//               ),
//             ),
//             SlidingUpPanel(
//               backdropEnabled: true,
//               controller: _panelController2,
//               panel: hostelPanelPage(),
//               maxHeight: MediaQuery.of(context).size.height - 60,
//               minHeight: 0,
//               border: Border.all(color: Color(0xffE9E7E3), width: 2),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(18.0),
//                   topRight: Radius.circular(18.0)),
//               header: Padding(
//                 padding: const EdgeInsets.all(0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 5.0),
//                     child: Row(
//                       children: <Widget>[
//                         const Spacer(),
//                         Expanded(
//                             child: Center(
//                                 child: Icon(
//                           Icons.horizontal_rule_rounded,
//                           color: Color(0xffC2C1C1),
//                           size: 50,
//                         ))),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: ButtonTheme(
//                               padding: EdgeInsets.all(0),
//                               child: FlatButton(
//                                 height: 25,
//                                 minWidth: 25,
//                                 onPressed: () {
//                                   _panelController2.close();
//                                   infoPageVisible = false;
//                                   bookingPageVisible = false;
//                                 },
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Color(0xff707070),
//                                   size: 20.0,
//                                 ),
//                                 padding: EdgeInsets.all(0.0),
//                                 shape: CircleBorder(),
//                                 color: Color(0xffECEBE9),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SlidingUpPanel(
//               backdropEnabled: true,
//               controller: _panelController3,
//               panel: menuPanelPage(),
//               maxHeight: menuPageSize,
//               minHeight: 0,
//               border: Border.all(color: Color(0xffE9E7E3), width: 2),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(18.0),
//                   topRight: Radius.circular(18.0)),
//               header: Padding(
//                 padding: const EdgeInsets.all(0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 0.0, right: 5.0),
//                     child: Row(
//                       children: <Widget>[
//                         // const Spacer(),
//                         returnButton(),
//                         Expanded(
//                             child: Center(
//                                 child: Icon(
//                           Icons.horizontal_rule_rounded,
//                           color: Color(0xffC2C1C1),
//                           size: 50,
//                         ))),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: ButtonTheme(
//                               padding: EdgeInsets.all(0),
//                               child: FlatButton(
//                                 height: 25,
//                                 minWidth: 25,
//                                 onPressed: () {
//                                   _panelController3.close();
//                                 },
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Color(0xff707070),
//                                   size: 20.0,
//                                 ),
//                                 padding: EdgeInsets.all(0.0),
//                                 shape: CircleBorder(),
//                                 color: Color(0xffECEBE9),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // const Padding(padding: EdgeInsets.all(16.0)),
//             // FutureBuilder<void>(future: _launched, builder: _launchStatus),
//           ],
//         ),
//       ),
//     );
//   }

//   returnButton() {
//     if (menuPageVisible == false) {
//       return Expanded(
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: ButtonTheme(
//             padding: EdgeInsets.all(0),
//             child: FlatButton(
//               height: 25,
//               minWidth: 25,
//               onPressed: () {
//                 setState(() {
//                   menuPageVisible = true;
//                   menuAccountVisible = false;
//                   menuContactVisible = false;
//                   menuPaymentVisible = false;
//                 });
//               },
//               child: Icon(
//                 Icons.arrow_back_ios_rounded,
//                 color: Color(0xff9F9F9F),
//                 size: 20.0,
//               ),
//               padding: EdgeInsets.all(0.0),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return const Spacer();
//     }
//   }

//   menuPanelPage() {
//     if (menuPageVisible == true) {
//       menuPageSize = MediaQuery.of(context).size.height / 2.6;
//       return hostelMenuPanel();
//     } else if (menuAccountVisible == true) {
//       menuPageSize = MediaQuery.of(context).size.height - 60;
//       return accountMenuPanel();
//     } else if (menuPaymentVisible == true) {
//       menuPageSize = MediaQuery.of(context).size.height - 60;
//       return paymentMenuPanel();
//     } else if (menuContactVisible == true) {
//       menuPageSize = MediaQuery.of(context).size.height - 60;
//       return contactMenuPanel();
//     } else {
//       menuPageSize = MediaQuery.of(context).size.height - 60;
//       return Container(
//         child: Text("HELLO"),
//       );
//     }
//   }

//   namePopup() {
//     return showGeneralDialog(
//       barrierLabel: "Name",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 400, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 200,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 10, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Name",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _firstNameController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.firstName}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _middleNameController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.middleName}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _lastNameController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.lastName}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                                 // _firstNameController.clear();
//                                 // _middleNameController.clear();
//                                 // _lastNameController.clear();
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 onPress();
//                                 TravelerSignup names = TravelerSignup(
//                                     firstName: _firstNameController.text,
//                                     middleName: _middleNameController.text,
//                                     lastName: _lastNameController.text);

//                                 if (names.firstName.isEmpty &&
//                                     names.middleName.isEmpty &&
//                                     names.lastName.isEmpty) {
//                                   print("They're all empty");
//                                   return null;
//                                 } else {
//                                   print(names.toDatabaseJsonNames());
//                                   changeTravelerNames(names);
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                   // _firstNameController.clear();
//                                   // _middleNameController.clear();
//                                   // _lastNameController.clear();
//                                 }
//                               },
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   contactPopup() {
//     return showGeneralDialog(
//       barrierLabel: "Contact",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 430, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 300,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 10, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Phone",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _phoneController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.phone}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Email",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _emailController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.user.email}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                                 // _firstNameController.clear();
//                                 // _middleNameController.clear();
//                                 // _lastNameController.clear();
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 onPress();
//                                 UserSignup userEmail =
//                                     UserSignup(email: _emailController.text);
//                                 TravelerSignup contacts = TravelerSignup(
//                                     user: userEmail,
//                                     phone: _phoneController.text);

//                                 if (contacts.user.email.isEmpty &&
//                                     contacts.phone.isEmpty) {
//                                   print("They're all empty");
//                                   return null;
//                                 } else {
//                                   changeTravelerContacts(contacts);
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                 }
//                               },
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   emergencyContactPopup() {
//     return showGeneralDialog(
//       barrierLabel: "EmergContact",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 315, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 450,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 10, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Emergency Contact Name",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _emergencyNameController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.emergencyName}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Relation",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _emergencyRelationController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.emergencyRelation}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Phone",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _emergencyPhoneController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.emergencyPhone}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Email",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _emergencyEmailController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: '${travelerInformation.emergencyEmail}',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                                 // _firstNameController.clear();
//                                 // _middleNameController.clear();
//                                 // _lastNameController.clear();
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 onPress();
//                                 TravelerSignup emergencyContacts =
//                                     TravelerSignup(
//                                         emergencyName:
//                                             _emergencyNameController.text,
//                                         emergencyRelation:
//                                             _emergencyRelationController.text,
//                                         emergencyPhone:
//                                             _emergencyPhoneController.text,
//                                         emergencyEmail:
//                                             _emergencyEmailController.text);

//                                 if (emergencyContacts.emergencyName.isEmpty &&
//                                     emergencyContacts.emergencyPhone.isEmpty &&
//                                     emergencyContacts
//                                         .emergencyRelation.isEmpty &&
//                                     emergencyContacts.emergencyEmail.isEmpty) {
//                                   print("They're all empty");
//                                   return null;
//                                 } else {
//                                   changeTravelerEmergencyContacts(
//                                       emergencyContacts);
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                 }
//                               },
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   languageCountryPopup() {
//     return showGeneralDialog(
//       barrierLabel: "LangAndCountry",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 430, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 275,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 10, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Language",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       enabled: true,
//                       readOnly: true,
//                       // controller: _emergencyNameController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: 'English',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Country or Region",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       padding:
//                           EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
//                       decoration: BoxDecoration(
//                         // color: Color(0xffFBF9F8),
//                         border: Border.all(color: Color(0xffE4E4E4), width: 2),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: CountryCodePicker(
//                         padding: EdgeInsets.only(
//                             top: 0, bottom: 0, left: 0, right: 0),
//                         onChanged: (e) {
//                           print(e.name);
//                           print(e.code);
//                           _countryController.text = e.code.toString();
//                           print("code is ${_countryController.text}");
//                         },
//                         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//                         initialSelection: '${travelerInformation.country}',
//                         // favorite: ['+39', 'FR'],
//                         // countryFilter: ['IT', 'FR'],
//                         showFlagDialog: true,
//                         showFlagMain: true,
//                         showCountryOnly: true,
//                         showOnlyCountryWhenClosed: true,
//                         comparator: (a, b) => b.name.compareTo(a.name),
//                         //Get the country information relevant to the initial selection
//                         onInit: (code) => print(
//                             "on init ${code.name} ${code.dialCode} ${code.name}"),
//                         alignLeft: true,
//                         hideSearch: true,
//                         flagWidth: 20.0,
//                         dialogSize: Size(
//                             MediaQuery.of(context).size.width - 100,
//                             MediaQuery.of(context).size.height - 100),
//                         textOverflow: TextOverflow.ellipsis,
//                         textStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                                 // _firstNameController.clear();
//                                 // _middleNameController.clear();
//                                 // _lastNameController.clear();
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 onPress();
//                                 TravelerSignup travelerCountry = TravelerSignup(
//                                     country: _countryController.text);

//                                 print(
//                                     "YOYOYO ${travelerCountry.toDatabaseJsonCountry()}");
//                                 if (travelerCountry.country.isEmpty) {
//                                   print("They're all empty");
//                                   return null;
//                                 } else {
//                                   changeTravelerCountry(travelerCountry);
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                 }
//                               },
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   passwordChangePopup() {
//     return showGeneralDialog(
//       barrierLabel: "PasswordChange",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 380, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 220,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 10, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "Current Password",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _oldPasswordController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: 'Old Password',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       obscureText: true,
//                       // keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(
//                           "New Password",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 12),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _newPasswordController,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: 'New Password',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       obscureText: true,
//                       // keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     SizedBox(height: 8.0),
//                     TextFormField(
//                       keyboardAppearance: Brightness.light,
//                       controller: _newPassword2Controller,
//                       // autofocus: false,
//                       style: TextStyle(
//                           color: Color(0xff9F9F9F),
//                           fontFamily: "SF-Pro-Regular",
//                           fontSize: 16),
//                       decoration: InputDecoration(
//                         // labelText: 'Username',
//                         hintText: 'Confirm New Password',
//                         hintStyle: TextStyle(
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                             fontSize: 16),
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 10.0),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xff0093B1))),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(width: 2, color: Color(0xffE4E4E4))),
//                       ),
//                       obscureText: true,
//                       // keyboardType: TextInputType.text,
//                       autovalidateMode: AutovalidateMode.always,
//                       autocorrect: false,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                                 // _firstNameController.clear();
//                                 // _middleNameController.clear();
//                                 // _lastNameController.clear();
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 onPress();
//                                 Password passwords = Password(
//                                     oldPassword: _oldPasswordController.text,
//                                     newPassword: _newPasswordController.text,
//                                     newPassword2: _newPassword2Controller.text);
//                                 print(passwords.oldPassword);
//                                 print(passwords.newPassword);
//                                 print(passwords.newPassword2);
//                                 if (passwords.oldPassword.isEmpty ||
//                                     passwords.newPassword.isEmpty ||
//                                     passwords.newPassword2.isEmpty) {
//                                   print("They're all empty");
//                                   return null;
//                                 } else {
//                                   print(passwords.toDatabaseJson());
//                                   changeTravelerPassword(passwords);
//                                   Navigator.of(context, rootNavigator: true)
//                                       .pop('dialog');
//                                   // _firstNameController.clear();
//                                   // _middleNameController.clear();
//                                   // _lastNameController.clear();
//                                 }
//                               },
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   List cards = [
//     {
//       'cardNumber': '4242424242424242',
//       'expiryDate': '04/24',
//       'cardHolderName': 'Ali Nejad',
//       'cvvCode': '424',
//       'showBackView': false,
//     },
//     {
//       'cardNumber': '3566002020360505',
//       'expiryDate': '04/24',
//       'cardHolderName': 'Tracer',
//       'cvvCode': '123',
//       'showBackView': false,
//     }
//   ];

//   paymentMenuPanel() {
//     List testing = ['a', 'b', 'c'];
//     return Padding(
//         padding: const EdgeInsets.only(top: 60, left: 0, right: 0),
//         child: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//                   Widget>[
//             Padding(
//               padding:
//                   const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
//               child: Text(
//                 "Payment Methods",
//                 style: TextStyle(
//                   color: Color(0xff9F9F9F),
//                   fontSize: 24,
//                   fontFamily: "SF-Pro-Bold",
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: FlatButton(
//                 child: Row(
//                   children: [
//                     Icon(Icons.add_circle, color: Color(0xff9F9F9F)),
//                     Text(
//                       "  Add New Card",
//                       style: TextStyle(
//                         color: Color(0xff9F9F9F),
//                         fontSize: 16,
//                         fontFamily: "SF-Pro-Medium",
//                       ),
//                     ),
//                   ],
//                 ),
//                 onPressed: () async {
//                   print(travelerInformation.stripeId);
//                   final result =
//                       await Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) =>
//                         CreditCardPage(stripeId: travelerInformation.stripeId),
//                   ));
//                   if (result != null) {
//                     print(result);
//                     print(result.toString());
//                     await getTravelerStripeInformation();
//                   }

//                   // newCardPage();

//                   // var newCard = await StripeService.payWithNewCard(
//                   //     amount: '150', currency: 'USD');

//                   print(stripeCustomer.email);
//                   // TravelerStripeInfo stripeCustomer =
//                   //     await StripeService.getStripeCustomer(
//                   //         travelerInformation.stripeId);
//                   // print(stripeCustomer.toString());

//                   // var stripeCustomerPayments =
//                   //     await StripeService.getStripeCustomerCards(
//                   //         travelerInformation.stripeId);
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 16.0, right: 16, top: 5, bottom: 5),
//               child: Divider(),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 20.0),
//               child: Container(
//                 padding: const EdgeInsets.all(0.0),
//                 child: Text(
//                   "Existing Cards:",
//                   style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontSize: 20,
//                     fontFamily: "SF-Pro-Bold",
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 5.0),
//               child: Container(
//                 padding: const EdgeInsets.all(0),
//                 child: MediaQuery.removePadding(
//                   removeTop: true,
//                   context: context,
//                   child: ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     itemCount: stripeCustomerCards.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       Cards card = stripeCustomerCards[index];
//                       String indexCardId = card.id;
//                       String path = getCardIcon(card.brand);
//                       return Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(0),
//                             child: ListTile(
//                               // minVerticalPadding: 0.0,
//                               // dense: true,
//                               enabled: true,
//                               leading: Container(
//                                 // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//                                 // padding: EdgeInsets.only(
//                                 //     left: MediaQuery.of(context).size.width / 10,
//                                 //     right: MediaQuery.of(context).size.width / 10),
//                                 child: IconButton(
//                                   iconSize: 40,
//                                   color: Color(0xff9F9F9F),
//                                   icon: ImageIcon(
//                                     AssetImage(path),
//                                   ),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                               // Text("${card.brand}"),
//                               title: Text("**** **** **** ${card.last4}",
//                                   style: TextStyle(
//                                     color: Color(0xff9F9F9F),
//                                     fontSize: 18,
//                                     fontFamily: "SF-Pro-SB",
//                                   )),
//                               subtitle:
//                                   // card == stripeCustomerdefaultCard
//                                   //     ? Text(
//                                   //         "${card.expMonth}/${card.expYear}    Default",
//                                   //         style: TextStyle(
//                                   //           color: Color(0xff9F9F9F),
//                                   //           fontSize: 16,
//                                   //           fontFamily: "SF-Pro-Regular",
//                                   //         ))
//                                   //     :
//                                   Text("${card.expMonth}/${card.expYear}",
//                                       style: TextStyle(
//                                         color: Color(0xff9F9F9F),
//                                         fontSize: 14,
//                                         fontFamily: "SF-Pro-Regular",
//                                       )),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//                                   // IconButton(
//                                   //   padding: const EdgeInsets.all(0.0),
//                                   //   icon: Icon(
//                                   //     Icons.edit,
//                                   //     size: 15.0,
//                                   //     color: Color(0xff9F9F9F),
//                                   //   ),
//                                   //   onPressed: () {
//                                   //     print("Edit");
//                                   //   },
//                                   // ),
//                                   card != stripeCustomerdefaultCard
//                                       ? IconButton(
//                                           padding: const EdgeInsets.all(0.0),
//                                           icon: Icon(
//                                             Icons.check,
//                                             size: 20.0,
//                                             color: Color(0xff9F9F9F),
//                                           ),
//                                           onPressed: () async {
//                                             // print("Set as Default $indexCardId");
//                                             await StripeService
//                                                 .changeDefaultCard(
//                                                     travelerInformation
//                                                         .stripeId,
//                                                     indexCardId);
//                                             await getTravelerStripeInformation();
//                                           },
//                                         )
//                                       : Text("Default",
//                                           style: TextStyle(
//                                             color: Color(0xff9F9F9F),
//                                             fontSize: 14,
//                                             fontFamily: "SF-Pro-SB",
//                                           )),
//                                   IconButton(
//                                     padding: const EdgeInsets.all(0.0),
//                                     icon: Icon(
//                                       Icons.delete,
//                                       size: 20.0,
//                                       color: Color(0xff9F9F9F),
//                                     ),
//                                     onPressed: () async {
//                                       print("Delete $indexCardId");
//                                       await StripeService.deleteCard(
//                                           travelerInformation.stripeId,
//                                           indexCardId);
//                                       await getTravelerStripeInformation();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(0),
//                             child: Divider(),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             )
//           ]),
//         ));
//   }

//   newCardPage() {
//     print("newCardPage");
//     return showGeneralDialog(
//         context: context,
//         pageBuilder: (context, anim1, anim2) {
//           return Align(
//               alignment: Alignment.center,
//               child: Material(
//                   type: MaterialType.transparency,
//                   child: Container(
//                     padding: EdgeInsets.all(0),
//                     // // margin: EdgeInsets.only(
//                     //     top: 50, bottom: 50, left: 12, right: 12),
//                     decoration: BoxDecoration(
//                       color: Color(0xffFBF9F8),
//                       border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black38,
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 2.0, //extend the shadow
//                           offset: Offset(
//                             0.0, // Move to right 10  horizontally
//                             5.0, // Move to bottom 10 Vertically
//                           ),
//                         ),
//                       ],
//                     ),
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SafeArea(
//                         child: Column(
//                           children: <Widget>[
//                             CreditCardWidget(
//                               cardBgColor: Colors.redAccent[200],
//                               cardNumber: cardNumber,
//                               expiryDate: expiryDate,
//                               cardHolderName: cardHolderName,
//                               cvvCode: cvvCode,
//                               showBackView: isCvvFocused,
//                               obscureCardNumber: true,
//                               obscureCardCvv: true,
//                               // animationDuration: Duration(milliseconds: 1000),
//                             ),
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     CreditCardForm(
//                                       formKey: formKey,
//                                       obscureCvv: true,
//                                       obscureNumber: true,
//                                       cardNumberDecoration:
//                                           const InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Number',
//                                         hintText: 'XXXX XXXX XXXX XXXX',
//                                       ),
//                                       expiryDateDecoration:
//                                           const InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Expired Date',
//                                         hintText: 'XX/XX',
//                                       ),
//                                       cvvCodeDecoration: const InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'CVV',
//                                         hintText: 'XXX',
//                                       ),
//                                       cardHolderDecoration:
//                                           const InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Card Holder',
//                                       ),
//                                       onCreditCardModelChange:
//                                           onCreditCardModelChange,
//                                     ),
//                                     RaisedButton(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(8.0),
//                                       ),
//                                       child: Container(
//                                         margin: const EdgeInsets.all(8),
//                                         child: const Text(
//                                           'Validate',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontFamily: 'halter',
//                                             fontSize: 14,
//                                             package: 'flutter_credit_card',
//                                           ),
//                                         ),
//                                       ),
//                                       color: const Color(0xff1b447b),
//                                       onPressed: () {
//                                         if (formKey.currentState.validate()) {
//                                           print('valid!');
//                                           print(cardHolderName);
//                                           Navigator.of(context,
//                                                   rootNavigator: true)
//                                               .pop('dialog');
//                                         } else {
//                                           print('invalid!');
//                                         }
//                                       },
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // ListView(children: <Widget>[
//                       //   Text("Add new card"),
//                       //   Padding(
//                       //     padding: const EdgeInsets.only(
//                       //         top: 150, right: 130, left: 130),
//                       //     child: OutlineButton(
//                       //       borderSide: BorderSide(
//                       //         width: 2,
//                       //         color: Color(0xffE4E4E4),
//                       //       ),
//                       //       shape: RoundedRectangleBorder(
//                       //         borderRadius: BorderRadius.circular(10.0),
//                       //       ),
//                       //       onPressed: () {
//                       //         Navigator.of(context, rootNavigator: true)
//                       //             .pop('dialog');
//                       //       },
//                       //       child: Text(
//                       //         'Done',
//                       //         style: TextStyle(
//                       //           color: Color(0xff9F9F9F),
//                       //           fontFamily: "SF-Pro-Regular",
//                       //           fontSize: 16,
//                       //         ),
//                       //       ),
//                       //       // color: Color(0xff0093B1),
//                       //       disabledBorderColor: Color(0xff9F9F9F),
//                       //       // highlightedBorderColor: Colors.red,
//                       //     ),
//                       //   ),
//                       // ]),
//                     ),
//                   )));
//         });
//   }

//   contactMenuPanel() {
//     return Padding(
//         padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: FlatButton(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Questions/ Comments",
//                             style: TextStyle(
//                               color: Color(0xff9F9F9F),
//                               fontSize: 16,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, left: 10.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "info@getlost.com",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 16.0, right: 16, top: 5, bottom: 5),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: FlatButton(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Call Us",
//                             style: TextStyle(
//                               color: Color(0xff9F9F9F),
//                               fontSize: 16,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, left: 10.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "+1 (800)923-3841",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 16.0, right: 16, top: 5, bottom: 5),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: FlatButton(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Career Opportunities",
//                             style: TextStyle(
//                               color: Color(0xff9F9F9F),
//                               fontSize: 16,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8, left: 10.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "career@getlost.com",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ]));
//   }

//   accountMenuPanel() {
//     return Padding(
//         padding: const EdgeInsets.only(top: 50, left: 0, right: 0),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Names",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: 16,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                   onPressed: () {
//                     _firstNameController.clear();
//                     _middleNameController.clear();
//                     _lastNameController.clear();
//                     namePopup();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Email & Phone Number",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: 16,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                   onPressed: () {
//                     _emailController.clear();
//                     _phoneController.clear();
//                     contactPopup();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Emergency Contact",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: 16,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                   onPressed: () {
//                     _emergencyNameController.clear();
//                     _emergencyRelationController.clear();
//                     _emergencyPhoneController.clear();
//                     _emergencyEmailController.clear();
//                     emergencyContactPopup();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Language/Country",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: 16,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                   onPressed: () {
//                     _countryController.clear();
//                     // _emergencyPhoneController.clear();
//                     languageCountryPopup();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16),
//                 child: Divider(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Change Password",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: 16,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                   onPressed: () {
//                     _oldPasswordController.clear();
//                     _newPasswordController.clear();
//                     _newPassword2Controller.clear();
//                     passwordChangePopup();
//                   },
//                 ),
//               ),
//             ]));
//   }

//   hostelMenuPanel() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: FlatButton(
//                 child: Text(
//                   "Account",
//                   style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontSize: 16,
//                     fontFamily: "SF-Pro-Medium",
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     menuPageVisible = false;
//                     menuAccountVisible = true;
//                     menuContactVisible = false;
//                     menuPaymentVisible = false;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, right: 16),
//             child: Divider(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: FlatButton(
//                 child: Text(
//                   "Payment",
//                   style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontSize: 16,
//                     fontFamily: "SF-Pro-Medium",
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     menuPageVisible = false;
//                     menuAccountVisible = false;
//                     menuContactVisible = false;
//                     menuPaymentVisible = true;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Divider(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: FlatButton(
//                 child: Text(
//                   "Support/ Contact Us",
//                   style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontSize: 16,
//                     fontFamily: "SF-Pro-Medium",
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     menuPageVisible = false;
//                     menuAccountVisible = false;
//                     menuContactVisible = true;
//                     menuPaymentVisible = false;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Divider(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: FlatButton(
//                 child: Text(
//                   "Log Out",
//                   style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontSize: 16,
//                     fontFamily: "SF-Pro-Medium",
//                   ),
//                 ),
//                 onPressed: () {
//                   logoutPopup();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   logoutPopup() {
//     return showGeneralDialog(
//       barrierLabel: "Logout",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       // barrierColor: null,
//       transitionDuration: Duration(milliseconds: 400),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Align(
//             alignment: Alignment.bottomCenter,
//             child: Material(
//               type: MaterialType.transparency,
//               child: Container(
//                 padding: EdgeInsets.all(0),
//                 margin:
//                     EdgeInsets.only(top: 200, bottom: 490, left: 30, right: 30),
//                 decoration: BoxDecoration(
//                   color: Color(0xffFBF9F8),
//                   border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       blurRadius: 6.0, // soften the shadow
//                       spreadRadius: 2.0, //extend the shadow
//                       offset: Offset(
//                         0.0, // Move to right 10  horizontally
//                         5.0, // Move to bottom 10 Vertically
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 140,
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 0, left: 40, right: 40),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, bottom: 15),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "Are you sure you want to logout?",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                               fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 0.0, left: 00, right: 00),
//                       child: Row(
//                         children: [
//                           const Spacer(),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 7.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff222222),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                               },
//                               child: Text(
//                                 "No",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 0.0, bottom: 0.0, left: 7.0, right: 0.0),
//                             child: FlatButton(
//                               minWidth: MediaQuery.of(context).size.width / 4.5,
//                               height: MediaQuery.of(context).size.height / 40,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(3.0),
//                                 side: BorderSide(
//                                     color: Color(0xff464646), width: 1),
//                               ),
//                               color: Color(0xff6C6C6C),
//                               textColor: Colors.white,
//                               onPressed: () {
//                                 Navigator.of(context).maybePop();
//                                 BlocProvider.of<AuthenticationBloc>(context)
//                                     .add(LoggedOut());
//                               },
//                               child: Text(
//                                 "Yes",
//                                 style: TextStyle(
//                                   fontSize: 13.0,
//                                   // color: Colors.black,
//                                   fontFamily: "SF-Pro-Bold",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ),
//               ),
//             ));
//       },
//     );
//   }

//   Widget _scrollingList(ScrollController sc) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: FutureBuilder(
//           // future: checkMarkers(),
//           future: listHostel(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return Container(child: Center(child: Text("Loading...")));
//             } else {
//               // var mark = snapshot.data;
//               // print(mark);
//               // print("ITEM COUNT ${snapshot.data.length}");
//               // print("heres the stuff ${snapshot.data}");
//               return ListView.builder(
//                 // controller: sc,
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // print(snapshot.data[index]);
//                   var item = snapshot.data[index];
//                   // print("more stuff --- ${item.markerId}");
//                   return Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 0, bottom: 0, left: 10, right: 40),
//                         child: ListTile(
//                           enabled: true,
//                           // title: Text("${item.markerId}"),
//                           title: Text(item.hostel.hostelName,
//                               style: TextStyle(
//                                 color: Color(0xff9F9F9F),
//                                 fontSize: 16,
//                                 fontFamily: "SF-Pro-Regular",
//                               )),
//                           //SET A DEFAULT FOR CURRENCY IF NULL OR IF STATMENT TO CHANGE
//                           trailing:
//                               Text(toCurrencySymbol(item.currency) + item.price,
//                                   style: TextStyle(
//                                     color: Color(0xff9F9F9F),
//                                     fontSize: 16,
//                                     fontFamily: "SF-Pro-Regular",
//                                   )),
//                           onTap: () async {
//                             HostelDetail hostelData = item;
//                             var hostelId = (hostelData.hostel.id).toString();
//                             var hostelCost =
//                                 ((hostelData.price).toString()).substring(0, 2);
//                             var hostelCurrency =
//                                 toCurrencySymbol(hostelData.currency);
//                             var markerId = MarkerId(hostelId);

//                             LatLng markerLocation = LatLng(
//                                 (double.parse(hostelData.hostel.latitude)),
//                                 (double.parse(hostelData.hostel.longitude)));
//                             BitmapDescriptor icon = await getMarkerIcon(
//                                 "assets/images/markerIcon_whiteBorder2.png",
//                                 Size(80.0, 80.0),
//                                 hostelCost,
//                                 hostelCurrency);
//                             print(
//                                 "Open up popup for ${item.hostel.hostelName}");

//                             _openPopup(context, hostelData, icon, markerId,
//                                 markerLocation);
//                             // geoLocation = await locateUser();
//                             _panelController.close();
//                             setState(() {
//                               //   _center = LatLng(
//                               //       geoLocation.latitude, geoLocation.longitude);
//                               //   _centerPanel = LatLng(
//                               //       geoLocation.latitude, geoLocation.longitude);
//                             });
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 0, bottom: 0, left: 20, right: 20),
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

//   hostelPanelPage() {
//     if (bookingPageVisible == true) {
//       return hostelBookingPanel();
//     } else if (infoPageVisible == true) {
//       return hostelInfoPanel();
//     } else {
//       // selectedMarkers.clear();
//       return Container(
//         child: Text("HELLO"),
//       );
//     }
//   }

//   Widget hostelBookingPanel() {
//     print("Hostel Booking Panel");
//     return Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: ListView(
//             // crossAxisAlignment: CrossAxisAlignment.stretch,
//             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(top: 0.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0, top: 0),
//                     child: Text(
//                       "${hostelPanelName}",
//                       softWrap: true,
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         color: Colors.black,
//                         fontFamily: "SF-Pro-SB",
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     top: 50, bottom: 50, left: 30, right: 30),
//                 child: Container(
//                   padding: EdgeInsets.all(0.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Column(children: <Widget>[
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 15, left: 15, bottom: 30),
//                       child: Row(
//                         children: <Widget>[
//                           Text(
//                             "Arrival:   ",
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                           Text(
//                             "${getDateAndDay(now)['todayDay']}",
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Color(0xff9F9F9F),
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Text(
//                       "${getDateAndDay(now)['todayDate']}",
//                       style: TextStyle(
//                         fontSize: 21.0,
//                         color: Colors.black,
//                         fontFamily: "SF-Pro-Medium",
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.only(
//                             top: 30, bottom: 0, left: 20, right: 20),
//                         child: Divider(
//                           thickness: 2,
//                         )),
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 10, left: 15, bottom: 30),
//                       child: Row(
//                         children: <Widget>[
//                           Text(
//                             "Departure:   ",
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               color: Colors.black,
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           ),
//                           Text(
//                             "${getDateAndDay(now)['tomorrowDay']}",
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Color(0xff9F9F9F),
//                               fontFamily: "SF-Pro-Regular",
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 30),
//                       child: Text(
//                         "${getDateAndDay(now)['tomorrowDate']}",
//                         style: TextStyle(
//                           fontSize: 21.0,
//                           color: Colors.black,
//                           fontFamily: "SF-Pro-Medium",
//                         ),
//                       ),
//                     )
//                   ]),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                     child: Padding(
//                   padding: const EdgeInsets.only(left: 0, right: 0, bottom: 30),
//                   child: Row(
//                     children: [
//                       const Spacer(),
//                       Text(
//                         "Your Total:  ",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black,
//                           fontFamily: "SF-Pro-Regular",
//                         ),
//                       ),
//                       Text(
//                         "$hostelPanelCurrency$hostelPanelPrice",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black,
//                           fontFamily: "SF-Pro-SB",
//                         ),
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 )),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 25, bottom: 20),
//                 child: Container(
//                     child: Center(
//                         child: Text(
//                   "Confrim today's Booking?",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.black,
//                     fontFamily: "SF-Pro-Regular",
//                   ),
//                 ))),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     top: 0.0, bottom: 0.0, left: 120.0, right: 120.0),
//                 child: FlatButton(
//                   minWidth: MediaQuery.of(context).size.width / 2.2,
//                   height: MediaQuery.of(context).size.height / 16,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   color: Color(0xff0093B1),
//                   textColor: Colors.white,
//                   onPressed: () {
//                     // print(
//                     //     "The Customers ID is - ${travelerProfile.id} and Name is - ${travelerProfile.user.username}");
//                     // print(
//                     //     "The Hostels ID is - ${hostelPanel.hostel.id} and Name is - ${hostelPanel.hostel.hostelName}");
//                     Reservation pr = Reservation(
//                         hostelId: hostelPanel.hostel.id,
//                         travelerId: travelerInformation.id,
//                         isCheckedIn: false,
//                         isConfirmed: false);
//                     // print(
//                     //     "hostel ID: ${pr.hostelId} - traveler ID: ${pr.travelerId} - is checked in: ${pr.isCheckedIn} - is confirmed: ${pr.isConfirmed}");
//                     // print(pr.toDatabaseJson());
//                     postReservation(pr);
//                     // Charge customer here
//                     var charge = StripeService.chargeCard(
//                         amount: hostelPanelPrice,
//                         currency: hostelPanel.currency,
//                         card: stripeCustomerdefaultCard,
//                         hostelId: hostelPanel.hostel.stripeId,
//                         travelerId: travelerInformation.stripeId);
//                     print(charge);
//                     _panelController2.close();
//                     hostelConfirmedPage();
//                   },
//                   child: Text(
//                     "Confirm!",
//                     style: TextStyle(
//                       fontSize: 26.0,
//                       // color: Colors.black,
//                       fontFamily: "SF-Pro-Medium",
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 40.0),
//                 child: FlatButton(
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(
//                       color: Color(0xff9F9F9F),
//                       fontSize: MediaQuery.of(context).size.width / 26,
//                       fontFamily: "SF-Pro-Bold",
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       bookingPageVisible = false;
//                       infoPageVisible = true;
//                     });

//                     // _panelController2.close();
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     top: 30.0, bottom: 0, left: 25, right: 25),
//                 child: Container(
//                   child: Text(
//                     "*All 'Avaliable Beds' are Co-ed beds. It is at the Hostels discretion to decide in what co-ed bed you will be residing and in which co-ed room",
//                     softWrap: true,
//                     style: TextStyle(
//                         color: Color(0xff9F9F9F),
//                         fontFamily: "SF-Pro-Regular",
//                         fontSize: 11),
//                   ),
//                 ),
//               )
//             ]));
//   }

//   hostelConfirmedPage() {
//     print("HostelConfirmPage");
//     return showGeneralDialog(
//         context: context,
//         pageBuilder: (context, anim1, anim2) {
//           return Align(
//               alignment: Alignment.center,
//               child: Material(
//                   type: MaterialType.transparency,
//                   child: Container(
//                     padding: EdgeInsets.all(0),
//                     // // margin: EdgeInsets.only(
//                     //     top: 50, bottom: 50, left: 12, right: 12),
//                     decoration: BoxDecoration(
//                       color: Color(0xffFBF9F8),
//                       border: Border.all(color: Color(0xffE9E7E3), width: 2),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black38,
//                           blurRadius: 6.0, // soften the shadow
//                           spreadRadius: 2.0, //extend the shadow
//                           offset: Offset(
//                             0.0, // Move to right 10  horizontally
//                             5.0, // Move to bottom 10 Vertically
//                           ),
//                         ),
//                       ],
//                     ),
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ListView(children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 100, bottom: 10),
//                           child: Center(
//                               child: Icon(Icons.check_circle,
//                                   size: 120, color: Color(0xff0B93B1))),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 50),
//                           child: Center(
//                               child: Text(
//                             "Confirmed!",
//                             style: TextStyle(
//                                 color: Color(0xff9F9F9F),
//                                 fontFamily: "SF-Pro-SB",
//                                 fontSize: 36),
//                           )),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5.0),
//                           child: Center(
//                               child: Text("Your stay with:",
//                                   style: TextStyle(
//                                       color: Color(0xff9F9F9F),
//                                       fontFamily: "SF-Pro-Medium",
//                                       fontSize: 18))),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5.0),
//                           child: Center(
//                               child: Text("$hostelPanelName",
//                                   style: TextStyle(
//                                       color: Color(0xff9F9F9F),
//                                       fontFamily: "SF-Pro-SB",
//                                       fontSize: 18))),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 100.0),
//                           child: Center(
//                               child: Text("has been confirmed!",
//                                   style: TextStyle(
//                                       color: Color(0xff9F9F9F),
//                                       fontFamily: "SF-Pro-Medium",
//                                       fontSize: 18))),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               bottom: 4, left: 50, right: 50),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text("Arrival:",
//                                     style: TextStyle(
//                                         color: Color(0xff9F9F9F),
//                                         fontFamily: "SF-Pro-Medium",
//                                         fontSize: 14)),
//                                 Text("${getDateAndDay(now)['todayDate']}",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: "SF-Pro-Medium",
//                                         fontSize: 14))
//                               ]),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 50, right: 50),
//                           child: Divider(
//                             thickness: 2,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 4, left: 50, right: 50),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text("Departure:",
//                                     style: TextStyle(
//                                         color: Color(0xff9F9F9F),
//                                         fontFamily: "SF-Pro-Medium",
//                                         fontSize: 14)),
//                                 Text("${getDateAndDay(now)['tomorrowDate']}",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: "SF-Pro-Medium",
//                                         fontSize: 14))
//                               ]),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 150, right: 130, left: 130),
//                           child: OutlineButton(
//                             borderSide: BorderSide(
//                               width: 2,
//                               color: Color(0xffE4E4E4),
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _searchBarVisible = true;
//                               });
//                               // _panelController.close();
//                               Navigator.of(context, rootNavigator: true)
//                                   .pop('dialog');
//                             },
//                             child: Text(
//                               'Done',
//                               style: TextStyle(
//                                 color: Color(0xff9F9F9F),
//                                 fontFamily: "SF-Pro-Regular",
//                                 fontSize: 16,
//                               ),
//                             ),
//                             // color: Color(0xff0093B1),
//                             disabledBorderColor: Color(0xff9F9F9F),
//                             // highlightedBorderColor: Colors.red,
//                           ),
//                         ),
//                       ]),
//                     ),
//                   )));
//         });
//   }

//   // Set<Polyline> selectedPolylines = {};
//   Widget hostelInfoPanel() {
//     Completer<GoogleMapController> _controllerPanel = Completer();
//     GoogleMapController _controller2Panel;
//     PolylineId id = PolylineId("${selectedMarker.markerId}");
//     // print("Hostel Info Panel: -- hostel location -- $hostelPanelLocation");
//     // print("Hostel Info Panel: -- user location -- $_center");

//     Map<MarkerId, Marker> selectedMarkers = <MarkerId, Marker>{};
//     selectedMarkers[selectedMarker.markerId] = selectedMarker;
//     Map<PolylineId, Polyline> selectedPolylines = <PolylineId, Polyline>{};

//     // selectedPolylines.remove(selectedPolylines.values);
//     // Set<Polyline> selectedPolylines = {};
//     // selectedPolylines.add(selectedLine);
//     selectedPolylines[id] = selectedLine;

//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: ListView(
//         // crossAxisAlignment: CrossAxisAlignment.stretch,
//         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(top: 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 // Expanded(
//                 //   child:
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0, top: 0),
//                     child: Text(
//                       "${hostelPanelName}",
//                       softWrap: true,
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         color: Colors.black,
//                         fontFamily: "SF-Pro-SB",
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 // Expanded(
//                 //   child:
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0, top: 0),
//                     child: Text(
//                       "Avaliable Beds:   ${hostelPanelAvaliability}",
//                       softWrap: true,
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: Color(0xff9F9F9F),
//                         fontFamily: "SF-Pro-SB",
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//                 top: 46.0, bottom: 26, left: 39, right: 12),
//             child: Row(
//               children: <Widget>[
//                 // Expanded(
//                 // child:
//                 Padding(
//                   padding: const EdgeInsets.only(right: 0.0),
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(0),
//                         child: Text(
//                           "Total Price:",
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.black,
//                             fontFamily: "SF-Pro-Regular",
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(0),
//                         child: Text(
//                           "${hostelPanelCurrency} ${hostelPanelPrice}",
//                           style: TextStyle(
//                             fontSize: 25.0,
//                             color: Colors.black,
//                             fontFamily: "SF-Pro-SB",
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(0),
//                         child: Text(
//                           "No additional fees!",
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             color: Color(0xff9F9F9F),
//                             fontFamily: "SF-Pro-Regular",
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // ),
//                 // Expanded(
//                 // child:
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 0.0, bottom: 0.0, left: 25.0, right: 0.0),
//                   child: FlatButton(
//                     minWidth: MediaQuery.of(context).size.width / 2.2,
//                     height: MediaQuery.of(context).size.height / 16,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     color: Color(0xff0093B1),
//                     textColor: Colors.white,
//                     onPressed: () {
//                       // print(
//                       //     "The Customers ID is - ${travelerProfile.id} and Name is - ${travelerProfile.user.username}");
//                       // print(
//                       //     "The Hostels ID is - ${hostelPanel.hostel.id} and Name is - ${hostelPanel.hostel.hostelName}");
//                       // Reservation pr = Reservation(
//                       //     hostelId: hostelPanel.hostel.id,
//                       //     travelerId: travelerProfile.id,
//                       //     isCheckedIn: false,
//                       //     isConfirmed: false);
//                       // print(
//                       //     "hostel ID: ${pr.hostelId} - traveler ID: ${pr.travelerId} - is checked in: ${pr.isCheckedIn} - is confirmed: ${pr.isConfirmed}");
//                       // print(pr.toDatabaseJson());
//                       // postReservation(pr);
//                       setState(() {
//                         bookingPageVisible = true;
//                         infoPageVisible = false;
//                       });
//                     },
//                     child: Text(
//                       "Book!",
//                       style: TextStyle(
//                         fontSize: 26.0,
//                         // color: Colors.black,
//                         fontFamily: "SF-Pro-Medium",
//                       ),
//                     ),
//                   ),
//                 )
//                 // ),
//               ],
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
//             child: Divider(),
//           ),
//           Center(
//             child: Align(
//               alignment: Alignment.center,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20, bottom: 20, right: 50.0, left: 50.0),
//                 child: Row(
//                     // crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Expanded(
//                           child: Icon(Icons.bathtub,
//                               size: 35, color: Color(0xff8B8985))),
//                       Expanded(
//                           child: Icon(Icons.wifi,
//                               size: 35, color: Color(0xff8B8985))),
//                       Expanded(
//                           child: Icon(Icons.free_breakfast,
//                               size: 35, color: Color(0xff8B8985))),
//                     ]),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 26.0, left: 10, right: 10),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 5.0),
//                   child: FlatButton(
//                     minWidth: MediaQuery.of(context).size.width / 2.2,
//                     height: MediaQuery.of(context).size.height / 16,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     color: Color(0xffE9E7E3),
//                     textColor: Colors.black,
//                     onPressed: () {},
//                     child: Column(
//                       children: [
//                         Icon(Icons.directions, size: 22, color: Colors.black),
//                         Text(
//                           "Directions",
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             // color: Colors.black,
//                             fontFamily: "SF-Pro-Regular",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 0.0, bottom: 0.0, left: 5.0, right: 0.0),
//                   child: FlatButton(
//                     minWidth: MediaQuery.of(context).size.width / 2.2,
//                     height: MediaQuery.of(context).size.height / 16,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     color: Color(0xffE9E7E3),
//                     textColor: Colors.black,
//                     onPressed: () {
//                       // setState(() {
//                       //   _launched = callNow(hostelPanelPhone);
//                       // });
//                       callNow(hostelPanelPhone);
//                       print("CALL PRESSED $hostelPanelPhone");
//                     },
//                     child: Column(
//                       children: [
//                         Icon(Icons.call, size: 22, color: Colors.black),
//                         Text(
//                           "Call",
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             // color: Colors.black,
//                             fontFamily: "SF-Pro-Regular",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20.0, left: 5, right: 8),
//             child: Container(
//               height: 200,
//               // decoration: BoxDecoration(color: Colors.blueAccent),
//               child: AbsorbPointer(
//                 absorbing: true,
//                 child: GoogleMap(
//                   onMapCreated: (GoogleMapController controller) async {
//                     _controllerPanel.complete(controller);
//                     _controller2Panel = controller;
//                     geoLocation = await locateUser();
//                     _centerPanel =
//                         LatLng(geoLocation.latitude, geoLocation.longitude);
//                     // _controller2Panel.animateCamera(
//                     //   CameraUpdate.newCameraPosition(
//                     //     CameraPosition(target: _centerPanel, zoom: 10),
//                     //   ),
//                     // );
//                     getDirectionView(
//                         _centerPanel, hostelPanelLocation, _controller2Panel);
//                   },
//                   // onCameraIdle: () async {},
//                   markers: Set<Marker>.of(selectedMarkers.values),
//                   // onMapCreated: _onMapCreated,
//                   zoomGesturesEnabled: true,
//                   mapType: MapType.normal,
//                   initialCameraPosition:
//                       CameraPosition(target: _centerPanel, zoom: 10),
//                   myLocationButtonEnabled: false,
//                   myLocationEnabled: true,
//                   polylines: Set<Polyline>.of(selectedPolylines.values),
//                   // polylines: selectedPolylines,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text("Address",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Color(0xff8B8985)))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: Row(
//                     children: [
//                       Text("${hostelPanelAddress}",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Colors.black))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 0, bottom: 0, left: 20, right: 20),
//                   child: Divider(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Row(
//                     children: [
//                       Text("Phone",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Color(0xff8B8985)))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: Row(
//                     children: [
//                       Text("${hostelPanelPhone}",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Colors.black))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 0, bottom: 0, left: 20, right: 20),
//                   child: Divider(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Row(
//                     children: [
//                       Text("Website",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Color(0xff8B8985)))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Row(
//                     children: [
//                       Text("${hostelPanelWebsite}",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Colors.black))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 0, bottom: 0, left: 20, right: 20),
//                   child: Divider(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Row(
//                     children: [
//                       Text("Email",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Color(0xff8B8985)))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: Row(
//                     children: [
//                       Text("${hostelPanelEmail}",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: "SF-Pro-Regular",
//                               color: Colors.black))
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//                 top: 50.0, bottom: 50, left: 25, right: 25),
//             child: Container(
//               child: Text(
//                 "*All 'Avaliable Beds' are Co-ed beds. It is at the Hostels discretion to decide in what co-ed bed you will be residing and in which co-ed room",
//                 softWrap: true,
//                 style: TextStyle(
//                     color: Color(0xff9F9F9F),
//                     fontFamily: "SF-Pro-Regular",
//                     fontSize: 11),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }

//   // Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
//   //   if (snapshot.hasError) {
//   //     return Text('Error: ${snapshot.error}');
//   //   } else {
//   //     return const Text('');
//   //   }
//   // }
// }

// // void setCustomMapPin() async {
// //   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
// //       ImageConfiguration(devicePixelRatio: 2.5),
// //       'assets/images/markerIcon.png');
// // }

// // Future<Uint8List> getBytesFromCanvas(
// //     int width, int height, String price, String currency) async {
// //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
// //   final Canvas canvas = Canvas(pictureRecorder);
// //   final Paint paint = Paint()..color = Color(0xff0B93B1);
// //   final Radius radius = Radius.circular(width / 2);
// //   canvas.drawRRect(
// //       RRect.fromRectAndCorners(
// //         Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
// //         topLeft: radius,
// //         topRight: radius,
// //         bottomLeft: radius,
// //         bottomRight: radius,
// //       ),
// //       paint);

// //   TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
// //   painter.text = TextSpan(
// //     text: "$currency$price",
// //     style: TextStyle(
// //       fontSize: 25.0,
// //       color: Colors.white,
// //       fontFamily: "SF-Pro-Bold",
// //     ),
// //   );

// //   painter.layout();
// //   painter.paint(
// //       canvas,
// //       Offset((width * 0.5) - painter.width * 0.5,
// //           (height * .5) - painter.height * 0.5));

// //   final img = await pictureRecorder.endRecording().toImage(width, height);
// //   final data = await img.toByteData(format: ui.ImageByteFormat.png);
// //   return data.buffer.asUint8List();
// // }

// // getTravelerData() async {
// //   final String adminToken = await getAdminToken();
// //   http.Response response = await http.get(
// //       "http://127.0.0.1:8000/api/travelerprofile/",
// //       headers: <String, String>{
// //         'Content-Type': 'application/json; charset=UTF-8',
// //         'Authorization': 'Token $adminToken'
// //       });
// //   databaseItems = json.decode(response.body);
// //   listOfTravelerDetails = databaseItems
// //       .map((data) => TravelerSignup.fromDatabaseJson(data))
// //       .toList();
// //   // print(listOfTravelerDetails);
// //   TravelerSignup currentTraveler;
// //   for (TravelerSignup traveler in listOfTravelerDetails) {
// //     // print(traveler.user.username);
// //     if ((traveler.user.username).toString() == name) {
// //       print(traveler.id);
// //       print(traveler.firstName);
// //       print(traveler.middleName);
// //       print(traveler.lastName);
// //       currentTraveler = traveler;
// //     }
// //   }
// //   setState(() {
// //     travelerProfile = currentTraveler;
// //     // travelerId = currentTraveler.id;
// //   });
// //   return currentTraveler;
// // }
