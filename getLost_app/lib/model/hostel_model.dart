// import 'dart:ffi';

// NOTE: maybe add 'user' field to hostel model to give reference to the
// hostels user username instead of just hostel_name
class Hostel {
  int id;
  int user;
  String hostelName;
  String email;
  String phone;
  String fax;
  String website;
  String address;
  String cityState;
  String zipCode;
  String country;
  String latitude;
  String longitude;
  String stripeId;

  Hostel(
      {this.id,
      this.user,
      this.hostelName,
      this.email,
      this.phone,
      this.fax,
      this.website,
      this.address,
      this.cityState,
      this.zipCode,
      this.country,
      this.latitude,
      this.longitude,
      this.stripeId});

  @override
  toString() =>
      'Hostel: ID: $id, USER: $user, HOSTEL NAME: $hostelName, EMAIL: $email, PHONE: $phone, FAX: $fax, WEBSITE: $website, ADDRESS: $address, CITY/STATE: $cityState, ZIPCODE: $zipCode, COUNTRY: $country, LONG: $longitude, LAT: $latitude, stripe_id: $stripeId';

  factory Hostel.fromDatabaseJson(Map<String, dynamic> data) => Hostel(
        id: data['id'],
        user: data['user'],
        hostelName: data['hostel_name'],
        email: data['email'],
        phone: data['phone'],
        fax: data['fax'],
        website: data['website'],
        address: data['address'],
        cityState: data['city_state'],
        zipCode: data['zip_code'],
        country: data['country'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        stripeId: data['stripe_id'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "user": this.user,
        "hostel_name": this.hostelName,
        "email": this.email,
        "phone": this.phone,
        "fax": this.fax,
        "website": this.website,
        "address": this.address,
        "city_state": this.cityState,
        "zip_code": this.zipCode,
        "country": this.country,
        "latitude": this.latitude,
        "longitude": this.longitude
      };
}

class HostelDetail {
  int id;
  Hostel hostel;
  int avaliability;
  String price;
  String currency;
  String vat;

  HostelDetail({
    this.id,
    this.hostel,
    this.avaliability,
    this.price,
    this.currency,
    this.vat,
  });

  @override
  toString() =>
      "ID: $id, Hostel Info: $hostel, Avaliability: $avaliability, price: $price, currency: $currency, VAT: $vat";

  factory HostelDetail.fromDatabaseJson(Map<String, dynamic> data) =>
      HostelDetail(
        id: data['id'],
        avaliability: data['avaliability'],
        price: data['price'],
        currency: data['currency'],
        vat: data['vat'],
        hostel: Hostel.fromDatabaseJson(data['hostel']),
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "avaliability": this.avaliability,
        "price": this.price,
        "currency": this.currency,
        "vat": this.vat,
        "hostel": this.hostel.toDatabaseJson(),
      };
}
