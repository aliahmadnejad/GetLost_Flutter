import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:getLost_app/api_connection/api_connection.dart';
import 'package:getLost_app/dao/user_dao.dart';
import 'package:getLost_app/home/functions/google_map_functions.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:getLost_app/model/hostel_model.dart';
import 'package:getLost_app/model/user_model.dart';
import 'package:http/http.dart' as http;

final _base = "https://getlost-245519.wl.r.appspot.com";
final _homeServer = "http://127.0.0.1:8000";
List<HostelDetail> listOfHostelDetails;
// List<HostelDetail> hostel;
List<dynamic> hostelDatabaseItems;

getHostelData() async {
  final String adminToken = await getAdminToken();
  http.Response response =
      await http.get("$_base/api/hostelroomdetail/", headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $adminToken'
  });
  hostelDatabaseItems = json.decode(response.body);
  listOfHostelDetails = hostelDatabaseItems
      .map((data) => HostelDetail.fromDatabaseJson(data))
      .toList();
  return listOfHostelDetails;
}

postReservation(Reservation reservation) async {
  final String adminToken = await getAdminToken();
  final http.Response response = await http.post(
    "$_base/api/reservations/create/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $adminToken'
    },
    body: jsonEncode(reservation.toDatabaseJson()),
  );
  // if (response.statusCode == 201) {
  //   print(response);
  //   print("Error");
  // } else {
  //   print(json.decode(response.body).toString());
  //   throw Exception(json.decode(response.body));
  // }
}

getCurrentHostelData(HostelDetail hostelInfo) async {
  final String adminToken = await getAdminToken();
  http.Response response = await http.get(
      "$_base/api/hostelroomdetail/${hostelInfo.id}/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $adminToken'
      });

  Map<String, dynamic> map = json.decode(response.body);
  // print(map.toString());
  HostelDetail hostel = HostelDetail.fromDatabaseJson(map);
  // print(hostel.toString());
  return hostel;
}
