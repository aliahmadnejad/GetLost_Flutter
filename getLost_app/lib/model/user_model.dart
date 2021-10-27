class User {
  int id;
  String username;
  String token;

  User({this.id, this.username, this.token});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        token: data['token'],
      );

  Map<String, dynamic> toDatabaseJson() =>
      {"id": this.id, "username": this.username, "token": this.token};
}

class Reservation {
  int hostelId;
  int travelerId;
  bool isConfirmed;
  // bool isCheckedIn;
  bool isCheckedOut;

  Reservation(
      {this.hostelId, this.travelerId, this.isConfirmed, this.isCheckedOut});

  factory Reservation.fromDatabaseJson(Map<String, dynamic> data) =>
      Reservation(
        hostelId: data["hostel"],
        travelerId: data["customer"],
        isConfirmed: data['is_confirmed'],
        isCheckedOut: data['is_checked_out'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "hostel": this.hostelId,
        "customer": this.travelerId,
        "is_confirmed": this.isConfirmed,
        "is_checked_out": this.isCheckedOut,
      };
}
