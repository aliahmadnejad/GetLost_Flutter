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

class GuestApplicationBloc with ChangeNotifier {
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
  HostelDetail hostelInfo;
  Marker selectedMarker;
  Polyline selectedLine;
  bool panelMapVisible;
  bool settingMenuVisible = true;
  bool settingsAccountVisible = false;
  bool settingsContactVisible = false;
  bool settingsPaymentVisible = false;
  List<HostelDetail> listOfHostels;

  GuestApplicationBloc() {
    setCurrentLocation();
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

  setBookingPanelPage(bool isInfoVisible) async {
    infoPanelVisible = isInfoVisible;

    notifyListeners();
  }

  setHostelSelected(
      HostelDetail selectedHostel, Marker marker, Polyline polyLine) async {
    hostelInfo = selectedHostel;
    selectedMarker = marker;
    selectedLine = polyLine;
    print("${selectedHostel.hostel.hostelName}");
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
