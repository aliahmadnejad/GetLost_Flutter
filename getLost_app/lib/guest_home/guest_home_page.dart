import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/api_connection/hostel_api_connection.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/guest_home/bloc/guest_home_bloc.dart';
import 'package:getLost_app/guest_home/hostel_info_panel.dart';
import 'package:getLost_app/guest_home/menu_panel.dart';
import 'package:getLost_app/guest_home/google_map_functions.dart' as guest;
import 'package:getLost_app/home/buttons/hostel_list_button.dart';
import 'package:getLost_app/home/buttons/menu_panel_button.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/place.dart';
import 'package:getLost_app/model/place_search.dart';
import 'package:getLost_app/repository/user_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
// import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/services.dart' show rootBundle;

class GuestHomePage extends StatefulWidget {
  final UserRepository _userRepository;

  GuestHomePage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _HomeState createState() => _HomeState(userRepository: _userRepository);
}

class _HomeState extends State<GuestHomePage> {
  final UserRepository userRepository;
  _HomeState({this.userRepository});

  // Sliding Up Panel Controllers
  PanelController _panelController = new PanelController();
  PanelController panelController2 = new PanelController();
  PanelController _panelController3 = new PanelController();
  PanelController _panelController4 = new PanelController();
  double menuPageSize;
  bool menuPageVisible = false;
  bool menuAccountVisible = false;
  bool menuContactVisible = false;
  bool menuPaymentVisible = false;

  // Google Map controllers and variables
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller2;
  geo.Position geoLocation;
  LatLng _center;
  LatLng _centerPanel = LatLng(33.812511, -117.918976);
  LatLng _initialCameraPosition = LatLng(33.812511, -117.918976);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String _mapStyle;

  List<HostelDetail> listOfHostelDetails;
  Timer _timer;

  bool _searchBarVisible = true;
  final _searchController = TextEditingController();
  String searchAddress;
  FocusNode searchFocusNode;
  StreamSubscription locationSubscription;

  Marker selectedMarker;
  Polyline selectedLine;

  DateTime currentDateTime = DateTime.now();

  int bookingPanelIndex = 0;
  bool bookingPageVisible = false;
  bool infoPageVisible = false;

  TravelerStripeInfo stripeCustomer;
  List<Cards> stripeCustomerCards = [];
  Cards stripeCustomerdefaultCard;

  void _updateSearchBar(dynamic searchBarVisible) {
    setState(() {
      _searchBarVisible = searchBarVisible;
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    final applicationBloc =
        Provider.of<GuestApplicationBloc>(context, listen: false);
    _controller.complete(_cntlr);
    _controller2 = _cntlr;
    _controller2.setMapStyle(_mapStyle);
    _center = await getUserLocation(); // Not using anymore
    _controller2.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(applicationBloc.currentLocation.latitude,
                applicationBloc.currentLocation.longitude),
            zoom: 16 /*zoom: 4*/),
      ),
    );
  }

  void updateHostelDetail() async {
    List<HostelDetail> listOfHostels = await getHostelData();
    if (mounted)
      setState(() {
        listOfHostelDetails = listOfHostels;
      });
    for (HostelDetail hostel in listOfHostelDetails) {
      // print("hostel number $index is: $hostel");
      initMarker(hostel);
    }
  }

  void initMarker(hostelInfo) async {
    final applicationBloc =
        Provider.of<GuestApplicationBloc>(context, listen: false);
    HostelDetail hostelData = hostelInfo;
    var hostelId = (hostelData.hostel.id).toString();
    var hostelCost = ((hostelData.price).toString()).substring(0, 2);
    var hostelCurrency = toCurrencySymbol(hostelData.currency);
    var markerId = MarkerId(hostelId);

    LatLng markerLocation = LatLng((double.parse(hostelData.hostel.latitude)),
        (double.parse(hostelData.hostel.longitude)));
    String markerImagePath;
    if (hostelData.avaliability >= 1) {
      markerImagePath = "assets/images/markerIcon_whiteBorder2.png";
    } else {
      markerImagePath = "assets/images/markerIcon_grey.png";
    }
    BitmapDescriptor icon = await getMarkerIcon(
        markerImagePath, Size(100.0, 100.0), hostelCost, hostelCurrency);

    final Marker marker = Marker(
        markerId: markerId,
        position: markerLocation,
        icon: icon,
        onTap: () async {
          geoLocation = await locateUser();
          _centerPanel = LatLng(geoLocation.latitude, geoLocation.longitude);
          selectedLine = await createPolylines(_centerPanel, markerLocation);
          selectedMarker = Marker(
              markerId: markerId,
              position: markerLocation,
              icon: icon,
              consumeTapEvents: true);
          selectedLine = selectedLine;
          applicationBloc.setHostelSelected(
              hostelData, selectedMarker, selectedLine);
          // ------------------ uncomment when ready ----------
          print("The marker has been selected ${selectedMarker.markerId}");

          if (mounted)
            guest.openPopup(context, hostelData, icon, markerId, markerLocation,
                panelController2, _updateSearchBar, userRepository);
          setState(() {
            _center = LatLng(geoLocation.latitude, geoLocation.longitude);
            _centerPanel = LatLng(geoLocation.latitude, geoLocation.longitude);
            _searchBarVisible = false;
          });
          // --------------------------------------------------
        });
    if (mounted)
      setState(() {
        markers[markerId] = marker;
        // print(markers);
        // print(Set<Marker>.of(markers.values));
      });
  }

  @override
  void initState() {
    final applicationBloc =
        Provider.of<GuestApplicationBloc>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateHostelDetail();
    });
    //Listen for selected Location
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _searchController.text = place.name;
        _goToPlace(place);
      } else
        _searchController.text = "";
    });
    applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // final applicationBloc =
    //     Provider.of<GuestApplicationBloc>(context, listen: false);
    // applicationBloc.dispose();
    _controller2.dispose();
    _searchController.dispose();
    locationSubscription.cancel();
    // _timer.cancel();
    searchFocusNode.dispose();
    // positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<GuestApplicationBloc>(context);

    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("Gesture detector: outside search bar pressed");
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            SlidingUpPanel(
              backdropEnabled: true,
              panelBuilder: (ScrollController sc) => _scrollingList(sc),
              controller: _panelController,
              maxHeight: MediaQuery.of(context).size.height - 60,
              minHeight: 0,
              border: Border.all(color: Color(0xffE9E7E3), width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              header: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                      children: <Widget>[
                        const Spacer(),
                        Expanded(
                            child: Transform.translate(
                          offset: Offset(0.0, -10.0),
                          child: Center(
                              child: Icon(
                            Icons.horizontal_rule_rounded,
                            color: Color(0xffC2C1C1),
                            size: 50,
                          )),
                        )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                              padding: EdgeInsets.only(right: 0),
                              child: FlatButton(
                                height: 25,
                                minWidth: 25,
                                onPressed: () {
                                  _panelController.close();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Color(0xff707070),
                                  size: 20.0,
                                ),
                                // padding: EdgeInsets.all(0.0),
                                shape: CircleBorder(),
                                color: Color(0xffECEBE9),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            HostelListButton(
                              onPressed: () {
                                if (_panelController.isPanelClosed) {
                                  _panelController.open();
                                } else {
                                  _panelController.close();
                                }
                              },
                            ),
                            MenuPanelButton(
                              onPressed: () {
                                if (_panelController3.isPanelClosed) {
                                  _panelController3.open();
                                } else {
                                  _panelController3.close();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                body: Stack(children: <Widget>[
                  (applicationBloc.currentLocation == null)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GoogleMap(
                          onMapCreated: _onMapCreated,
                          zoomGesturesEnabled: true,
                          mapType: MapType.normal,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          scrollGesturesEnabled: true,
                          compassEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  applicationBloc.currentLocation.latitude,
                                  applicationBloc.currentLocation.longitude),
                              zoom: 14),
                          //getUserLocation(),
                          // CameraPosition(target: _initialCameraPosition, zoom: 3),
                          markers: Set<Marker>.of(markers.values),
                          onCameraIdle: () async {
                            setState(() {
                              checkMarkers(markers, _controller);
                              listHostel(
                                  markers, _controller, listOfHostelDetails);
                            });
                          },
                        ),
                  Positioned(
                      bottom: 30,
                      right: 20,
                      left: 20,
                      child: Visibility(
                        visible: _searchBarVisible,
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.only(bottom: 0, top: 0),
                          decoration: BoxDecoration(
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
                            color: Colors.white,
                            border: Border.all(
                                color: Color(0xffE9E7E3), width: 1.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 0, left: 2, right: 2),
                                splashColor: Colors.grey,
                                icon: Icon(
                                  Icons.search,
                                  color: Color(0xff9F9F9F),
                                  size: 20,
                                ),
                                onPressed: () {
                                  // searchAndNavigate(
                                  //     searchAddress, _controller2);
                                },
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    print("Search button pressed");
                                    applicationBloc
                                        .clearSelectedLocation(); //maybe delete - using this as onTap call for search bar
                                    // searchFocusNode.requestFocus();
                                    if (_panelController4.isPanelClosed) {
                                      _panelController4.open();
                                    } else {
                                      _panelController4.close();
                                    }
                                  },
                                  child: searchBarText(searchAddress),
                                  style: TextButton.styleFrom(
                                    primary: Color(0xff9F9F9F),
                                    textStyle: TextStyle(
                                        // color: Color(0xff9F9F9F),
                                        fontFamily: "SF-Pro-Regular",
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                24),
                                    padding:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  ),
                                ),

                                // TextField(
                                //   keyboardAppearance: Brightness.light,
                                //   controller: _searchController,
                                //   textInputAction: TextInputAction.search,
                                //   cursorColor: Color(0xff9F9F9F),
                                //   // keyboardType: TextInputType.text,
                                //   // textInputAction: TextInputAction.go,
                                //   decoration: InputDecoration(
                                //     border: InputBorder.none,
                                //     focusedBorder: InputBorder.none,
                                //     contentPadding: EdgeInsets.only(
                                //         top: 10,
                                //         bottom: 8,
                                //         left: 10,
                                //         right: 10),
                                //     // EdgeInsets.symmetric(horizontal: 1),
                                //     hintText: "Search for a hostel or address",
                                //     hintStyle: TextStyle(
                                //         color: Color(0xff9F9F9F),
                                //         fontFamily: "SF-Pro-Regular",
                                //         fontSize:
                                //             MediaQuery.of(context).size.width /
                                //                 26),
                                //   ),
                                //   onSubmitted: (val) {
                                //     //   setState(() {
                                //     //     searchAddress = val;
                                //     //   });
                                //     searchAndNavigate(
                                //         searchAddress, _controller2);
                                //   },
                                //   onChanged: (val) {
                                //     setState(() {
                                //       searchAddress = val;
                                //     });
                                //   },
                                // ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: IconButton(
                                    padding: EdgeInsets.only(bottom: 1, top: 4),
                                    icon: Icon(Icons.near_me),
                                    color: Color(0xff0093B1),
                                    onPressed: () async {
                                      print("location button pressed");
                                      applicationBloc
                                          .updateCurrentLocation(_controller2);
                                      // await getUserLocation();
                                    },
                                  )),
                            ],
                          ),
                        ),
                      )),
                ]),
              ),
            ),
            SlidingUpPanel(
              onPanelClosed: () {
                searchFocusNode.unfocus();
              },
              onPanelOpened: () {
                searchFocusNode.requestFocus();
              },
              backdropEnabled: true,
              panelBuilder: (ScrollController sc) =>
                  _searchList(sc, applicationBloc),
              controller: _panelController4,
              maxHeight: MediaQuery.of(context).size.height - 60,
              minHeight: 0,
              border: Border.all(color: Color(0xffE9E7E3), width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              header: Padding(
                padding: const EdgeInsets.only(right: 0, left: 0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          children: <Widget>[
                            const Spacer(),
                            Expanded(
                                child: Transform.translate(
                              offset: Offset(0.0, -10.0),
                              child: Center(
                                  child: Icon(
                                Icons.horizontal_rule_rounded,
                                color: Color(0xffC2C1C1),
                                size: 50,
                              )),
                            )),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ButtonTheme(
                                  padding: EdgeInsets.only(right: 0),
                                  child: FlatButton(
                                    height: 25,
                                    minWidth: 25,
                                    onPressed: () {
                                      print("panel controller 4 close button");
                                      _panelController4.close();
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Color(0xff707070),
                                      size: 20.0,
                                    ),
                                    // padding: EdgeInsets.all(0.0),
                                    shape: CircleBorder(),
                                    color: Color(0xffECEBE9),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 14, top: 50),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffE9E7E3), width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: IconButton(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 2, right: 2),
                                  splashColor: Colors.grey,
                                  icon: Icon(
                                    Icons.search,
                                    color: Color(0xff9F9F9F),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    searchAndNavigate(
                                        searchAddress, _controller2);
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: searchFocusNode,
                                  keyboardAppearance: Brightness.light,
                                  controller: _searchController,
                                  textInputAction: TextInputAction.search,
                                  cursorColor: Color(0xff9F9F9F),
                                  // keyboardType: TextInputType.text,
                                  // textInputAction: TextInputAction.go,
                                  style: TextStyle(
                                      color: Color(0xff9F9F9F),
                                      fontFamily: "SF-Pro-Regular",
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              26),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: 0, bottom: 10, left: 2, right: 4),
                                    // EdgeInsets.symmetric(horizontal: 1),
                                    hintText: "Search for a hostel or address",
                                    hintStyle: TextStyle(
                                        color: Color(0xff9F9F9F),
                                        fontFamily: "SF-Pro-Regular",
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                26),
                                  ),
                                  onSubmitted: (val) {
                                    //   setState(() {
                                    //     searchAddress = val;
                                    //   });
                                    _panelController4.close();
                                    searchAndNavigate(
                                        searchAddress, _controller2);
                                    applicationBloc.clearSelectedLocation();
                                  },
                                  onChanged: (val) {
                                    applicationBloc.searchPlaces(val);
                                    setState(() {
                                      searchAddress = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SlidingUpPanel(
              onPanelClosed: () {
                applicationBloc.setBookingPanelPage(false);
                setState(() {
                  _searchBarVisible = true;
                });
              },
              onPanelOpened: () {
                applicationBloc.setBookingPanelPage(true);
              },
              backdropEnabled: true,
              controller: panelController2,
              panel: hostelPanelPage(applicationBloc),
              maxHeight: MediaQuery.of(context).size.height - 60,
              minHeight: 0,
              border: Border.all(color: Color(0xffE9E7E3), width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              header: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment(0.0, 3.0),
                          end: Alignment(0.0, 0.2),
                          colors: [
                            Color(0x1AFFFFFF),
                            Color(0x4DFFFFFF),
                            Colors.white
                          ]),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                      children: <Widget>[
                        const Spacer(),
                        Expanded(
                            child: Transform.translate(
                          offset: Offset(0.0, -10.0),
                          child: Center(
                              child: Icon(
                            Icons.horizontal_rule_rounded,
                            color: Color(0xffC2C1C1),
                            size: 50,
                          )),
                        )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              child: FlatButton(
                                height: 25,
                                minWidth: 25,
                                onPressed: () {
                                  panelController2.close();
                                  // applicationBloc.setBookingPanelPage(false);
                                  infoPageVisible = false;
                                  bookingPageVisible = false;
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xff707070),
                                  size: 20.0,
                                ),
                                padding: EdgeInsets.all(0.0),
                                shape: CircleBorder(),
                                color: Color(0xffECEBE9),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SlidingUpPanel(
              backdropEnabled: true,
              controller: _panelController3,
              panel: MenuPanel(
                userRepository: userRepository,
              ),
              maxHeight: MediaQuery.of(context).size.height / 3.2,
              minHeight: 0,
              border: Border.all(color: Color(0xffE9E7E3), width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              header: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Transform.translate(
                          offset: Offset(0.0, -10.0),
                          child: Center(
                              child: Icon(
                            Icons.horizontal_rule_rounded,
                            color: Color(0xffC2C1C1),
                            size: 50,
                          )),
                        )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              child: FlatButton(
                                height: 25,
                                minWidth: 25,
                                onPressed: () {
                                  _panelController3.close();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xff707070),
                                  size: 20.0,
                                ),
                                padding: EdgeInsets.all(0.0),
                                shape: CircleBorder(),
                                color: Color(0xffECEBE9),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget searchBarText(String searchResult) {
    if (searchResult?.isEmpty ?? true) {
      return Text("Search for a hostel or address");
    } else {
      return Text(searchResult);
    }
  }

  Widget _searchList(ScrollController sc, applicationBloc) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: ListView(
        children: <Widget>[
          if (applicationBloc.searchResults != null &&
              applicationBloc.searchResults.length != 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: applicationBloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 2, bottom: 2),
                            child: ListTile(
                              title: Text(
                                applicationBloc
                                    .searchResults[index].description,
                                style: TextStyle(
                                  color: Color(0xff9F9F9F),
                                  fontSize: 16,
                                  fontFamily: "SF-Pro-Regular",
                                ),
                              ),
                              onTap: () {
                                _panelController4.close();
                                applicationBloc.setSelectedLocation(
                                    applicationBloc
                                        .searchResults[index].placeId);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 0, left: 20, right: 20),
                            child: Divider(),
                          ),
                        ],
                      );
                    }),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          // future: checkMarkers(),
          future: listHostel(markers, _controller, listOfHostelDetails),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else if (snapshot.data.toString() == "[]") {
              return Container(
                  child: Center(
                      child: Text("No Hostels on the Map",
                          style: TextStyle(
                            color: Color(0xff9F9F9F),
                            fontSize: 16,
                            fontFamily: "SF-Pro-Regular",
                          ))));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 40),
                        child: ListTile(
                          enabled: true,
                          title: Text(item.hostel.hostelName,
                              style: TextStyle(
                                color: Color(0xff9F9F9F),
                                fontSize: 16,
                                fontFamily: "SF-Pro-Regular",
                              )),
                          //SET A DEFAULT FOR CURRENCY IF NULL OR IF STATMENT TO CHANGE
                          trailing:
                              Text(toCurrencySymbol(item.currency) + item.price,
                                  style: TextStyle(
                                    color: Color(0xff9F9F9F),
                                    fontSize: 16,
                                    fontFamily: "SF-Pro-Regular",
                                  )),
                          onTap: () async {
                            // ------------------ uncomment when ready ----------
                            // HostelDetail hostelData = item;
                            // var hostelId = (hostelData.hostel.id).toString();
                            // var hostelCost =
                            //     ((hostelData.price).toString()).substring(0, 2);
                            // var hostelCurrency =
                            //     toCurrencySymbol(hostelData.currency);
                            // var markerId = MarkerId(hostelId);

                            // LatLng markerLocation = LatLng(
                            //     (double.parse(hostelData.hostel.latitude)),
                            //     (double.parse(hostelData.hostel.longitude)));
                            // BitmapDescriptor icon = await getMarkerIcon(
                            //     "assets/images/markerIcon_whiteBorder2.png",
                            //     Size(80.0, 80.0),
                            //     hostelCost,
                            //     hostelCurrency);
                            // print(
                            //     "Open up popup for ${item.hostel.hostelName}");

                            // _openPopup(context, hostelData, icon, markerId,
                            //     markerLocation);
                            // // geoLocation = await locateUser();
                            // _panelController.close();
                            // setState(() {
                            //   //   _center = LatLng(
                            //   //       geoLocation.latitude, geoLocation.longitude);
                            //   //   _centerPanel = LatLng(
                            //   //       geoLocation.latitude, geoLocation.longitude);
                            // });
                            // ------------------ uncomment when ready ----------
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, left: 20, right: 20),
                        child: Divider(),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // This is called multiple times
  hostelPanelPage(applicationBloc) {
    bool infoPanel = applicationBloc.infoPanelVisible;
    HostelDetail hostelSelected;
    Marker markerSelected;
    Polyline polylineSelected;

    if (infoPanel == true) {
      hostelSelected = applicationBloc.hostelInfo;
      markerSelected = applicationBloc.selectedMarker;
      polylineSelected = applicationBloc.selectedLine;
      return HostelInfoPanel(
        hostelInfo: hostelSelected,
        marker: markerSelected,
        directionLine: polylineSelected,
        panelController: panelController2,
        userRepository: userRepository,
      );
    } else {
      // selectedMarkers.clear();
      return Container();
    }
  }

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
}
