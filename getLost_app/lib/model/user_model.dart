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
  bool isCheckedIn;

  Reservation(
      {this.hostelId, this.travelerId, this.isConfirmed, this.isCheckedIn});

  factory Reservation.fromDatabaseJson(Map<String, dynamic> data) =>
      Reservation(
        hostelId: data["hostel"],
        travelerId: data["customer"],
        isConfirmed: data['is_confirmed'],
        isCheckedIn: data['is_checked_in'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "hostel": this.hostelId,
        "customer": this.travelerId,
        "is_confirmed": this.isConfirmed,
        "is_checked_in": this.isCheckedIn,
      };
}
