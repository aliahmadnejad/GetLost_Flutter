import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:getLost_app/dao/user_dao.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/user_model.dart';
// import 'package:getLost_app/dao/user_dao.dart';
import 'package:http/http.dart' as http;

// final _base = "http://127.0.0.1:8000";
final _base = "https://getlost-245519.wl.r.appspot.com";
final _tokenEndpoint = "/api/api-token-auth/";
final _signUpEndpoint = "/api/travelerprofile/register/";
final _hostelDataEndpoint = "/api/hostelprofile/";
final _hostelRoomDetailDataEndpoint = "/api/hostelroomdetail/";
final _tokenURL = _base + _tokenEndpoint;
final _signUpURL = _base + _signUpEndpoint;
final _hostelDataURL = _base + _hostelDataEndpoint;
final _hostelRoomDetailDataURL = _base + _hostelRoomDetailDataEndpoint;

final _adminUsername = 'alinejad';
final _adminPassword = 'password';

Future<Token> getToken(UserLogin userLogin) async {
  // print(_tokenURL);
  final http.Response response = await http.post(
    _tokenURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  if (response.statusCode == 200) {
    return Token.fromJson(json.decode(response.body));
  } else {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}

Future<String> getAdminToken() async {
  final UserLogin admin =
      UserLogin(username: _adminUsername, password: _adminPassword);
  final Token token = await getToken(admin);
  // print(token.token.toString());
  return token.token.toString();
}

Future<UserLogin> registerUser(TravelerSignup travelerSignup) async {
  final String adminToken = await getAdminToken();
  final http.Response response = await http.post(
    _signUpURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $adminToken'
    },
    body: jsonEncode(travelerSignup.toDatabaseJson()),
  );
  if (response.statusCode == 201) {
    final UserLogin user = UserLogin(
        username: travelerSignup.user.username,
        password: travelerSignup.user.password);
    return user;
  } else {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}

final userDao = UserDao();
List<dynamic> databaseItems;
List<TravelerSignup> listOfTravelerDetails;
getTraveler() async {
  User user = await userDao.getUserById(0);
  final String adminToken = await getAdminToken();
  http.Response response =
      await http.get("$_base/api/travelerprofile/", headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $adminToken'
  });
  databaseItems = json.decode(response.body);
  listOfTravelerDetails = databaseItems
      .map((data) => TravelerSignup.fromDatabaseJson(data))
      .toList();
  // print(listOfTravelerDetails);
  TravelerSignup currentTraveler;
  for (TravelerSignup traveler in listOfTravelerDetails) {
    // print(traveler.user.username);
    if ((traveler.user.username).toString() == user.username) {
      // print(traveler.id);
      // print(traveler.firstName);
      // print(traveler.middleName);
      // print(traveler.lastName);
      currentTraveler = traveler;
    }
  }
  return currentTraveler;
}

changeTravelerNames(
    TravelerSignup traveler, TravelerSignup newNames, String token) async {
  // print("1 the travelers token is ------ $token");
  // print("1 the travelers username is ------ $name");
  final String adminToken = await getAdminToken();
  final http.Response response = await http.patch(
    "$_base/api/travelerprofile/${traveler.id}/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    },
    body: jsonEncode(newNames.toDatabaseJsonNames()),
  );
}

changeTravelerContacts(
    TravelerSignup traveler, TravelerSignup newContacts, String token) async {
  final http.Response response = await http.patch(
    "$_base/api/travelerprofile/${traveler.id}/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    },
    body: jsonEncode(newContacts.toDatabaseJsonContact()),
  );
}

changeTravelerEmergencyContacts(TravelerSignup traveler,
    TravelerSignup newEmergencyContacts, String token) async {
  final http.Response response = await http.patch(
    "$_base/api/travelerprofile/${traveler.id}/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    },
    body: jsonEncode(newEmergencyContacts.toDatabaseJsonEmergencyContact()),
  );
}

changeTravelerCountry(TravelerSignup traveler,
    TravelerSignup newTravelerCountry, String token) async {
  final http.Response response = await http.patch(
    "$_base/api/travelerprofile/${traveler.id}/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    },
    body: jsonEncode(newTravelerCountry.toDatabaseJsonCountry()),
  );
}

changeTravelerPassword(
    TravelerSignup traveler, Password newPasswords, String token) async {
  final http.Response response = await http.put(
    "$_base/api/change_password/${traveler.user.id}/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token'
    },
    body: jsonEncode(newPasswords.toDatabaseJson()),
  );
}
