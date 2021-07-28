import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/api_connection/hostel_api_connection.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/home/services/geolocator_service.dart';
import 'package:getLost_app/home/services/marker_service.dart';
import 'package:getLost_app/home/services/places_service.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/geometry.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/location.dart';
import 'package:getLost_app/model/place.dart';
import 'package:getLost_app/model/place_search.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = BehaviorSubject<Place>();
  StreamController<LatLngBounds> bounds = BehaviorSubject<LatLngBounds>();
  Place selectedLocationStatic;
  String placeType;
  List<Place> placeResults;
  List<Marker> markers = List<Marker>();
  bool infoPanelVisible = false;
  bool bookingPanelVisible = false;
  HostelDetail hostelInfo;
  Marker selectedMarker;
  Polyline selectedLine;
  bool panelMapVisible;
  TravelerSignup travelerInfo;
  TravelerStripeInfo stripeCustomer;
  List<Cards> stripeCustomerCards = [];
  Cards stripeCustomerDefaultCard;
  bool settingMenuVisible = true;
  bool settingsAccountVisible = false;
  bool settingsContactVisible = false;
  bool settingsPaymentVisible = false;
  List<HostelDetail> listOfHostels;

  ApplicationBloc() {
    setCurrentLocation();
    // getHostelsInfo();
  }

  setSettingsPage(bool isMenuVisible, bool isAccountVisible,
      bool isContactVisible, bool isPaymentVisible) async {
    settingMenuVisible = isMenuVisible;
    settingsAccountVisible = isAccountVisible;
    settingsContactVisible = isContactVisible;
    settingsPaymentVisible = isPaymentVisible;
    notifyListeners();
  }

  setSettingsPage2(String settingsPage) async {
    if (settingsPage == "menu") {
      settingMenuVisible = true;
      settingsAccountVisible = false;
      settingsContactVisible = false;
      settingsPaymentVisible = false;
    } else if (settingsPage == "account") {
      settingMenuVisible = false;
      settingsAccountVisible = true;
      settingsContactVisible = false;
      settingsPaymentVisible = false;
    } else if (settingsPage == "contact") {
      settingMenuVisible = false;
      settingsAccountVisible = false;
      settingsContactVisible = true;
      settingsPaymentVisible = false;
    } else if (settingsPage == "payment") {
      settingMenuVisible = false;
      settingsAccountVisible = false;
      settingsContactVisible = false;
      settingsPaymentVisible = true;
    }

    notifyListeners();
  }

  getTravelerInfo() async {
    travelerInfo = await getTraveler();
    notifyListeners();
    return travelerInfo;
  }

  setTravelerInfo(TravelerSignup traveler) {
    // maybe also use api call to get information directly and add
    // to ApplicationBloc() function on top
    travelerInfo = traveler;
    notifyListeners();
  }

  // setStripeInfo(TravelerSignup traveler) async {
  //   stripeCustomer = await StripeService.getStripeCustomer(traveler.stripeId);
  //   String defaultCardId = stripeCustomer.defaultSource;
  //   for (Cards item in stripeCustomer.sources.data) {
  //     stripeCustomerCards.add(item);
  //   }
  //   for (Cards card in stripeCustomerCards) {
  //     if (card.id == defaultCardId) {
  //       stripeCustomerDefaultCard = card;
  //     }
  //   }
  //   // setTravelerInfo(traveler);
  //   notifyListeners();
  // }

  setStripeInfo(TravelerSignup traveler) async {
    TravelerStripeInfo customer =
        await StripeService.getStripeCustomer(traveler.stripeId);
    String defaultCardId = customer.defaultSource;
    Cards defaultCard;
    List<Cards> cards = [];
    for (Cards item in customer.sources.data) {
      cards.add(item);
    }
    for (Cards card in cards) {
      if (card.id == defaultCardId) {
        defaultCard = card;
      }
    }

    stripeCustomer = customer;
    stripeCustomerCards = cards;
    stripeCustomerDefaultCard = defaultCard;

    // setTravelerInfo(traveler);
    notifyListeners();
  }

  setMapVisibility(bool visible) async {
    panelMapVisible = visible;
    notifyListeners();
  }

  setHostelsInfo(List<HostelDetail> hostelList) async {
    listOfHostels = hostelList;
    notifyListeners();
  }

  getSelectedHostelInfo(HostelDetail hostel) async {
    hostelInfo = await getCurrentHostelData(hostel);
    // print("From ApplicationBloc ${hostelInfo.avaliability}");
    notifyListeners();
    // return listOfHostels;
  }

  setHostelSelected(
      HostelDetail selectedHostel, Marker marker, Polyline polyLine) async {
    hostelInfo = selectedHostel;
    selectedMarker = marker;
    selectedLine = polyLine;
    print("${selectedHostel.hostel.hostelName}");
    notifyListeners();
  }

  setBookingPanelPage(bool isInfoVisible, bool isBookingVisible) async {
    infoPanelVisible = isInfoVisible;
    bookingPanelVisible = isBookingVisible;

    notifyListeners();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  updateCurrentLocation(GoogleMapController controller) async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 16),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    for (PlaceSearch places in searchResults) {
      print("the stuff ${places.description}");
    }

    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);
      markers = [];
      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0], false);
        markers.add(newMarker);
      }

      var locationMarker =
          markerService.createMarkerFromPlace(selectedLocationStatic, true);
      markers.add(locationMarker);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds);

      notifyListeners();
    }
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
