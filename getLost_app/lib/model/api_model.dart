// import 'package:getLost_app/model/user_model.dart';

import 'dart:convert';

import 'package:getLost_app/model/user_model.dart';

class UserLogin {
  String username;
  String password;

  UserLogin({this.username, this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": this.username, "password": this.password};
}

// class UserDetails {
//   String username;
//   String password;
//   String email;
//   // String accountType;

//   UserDetails({this.username, this.password, this.email});

//   Map<String, dynamic> toDatabaseJson() => {
//         "username": this.username,
//         "password": this.password,
//         "email": this.email,
//         // "account_type": "2"
//       };
// }

class UserSignup {
  // UserDetails user;
  int id;
  String username;
  String password;
  String email;
  // String accountType;

  UserSignup({
    this.id,
    this.username,
    this.password,
    this.email,
    // this.accountType,
    // this.user,
  });
  factory UserSignup.fromDatabaseJson(Map<String, dynamic> data) => UserSignup(
        id: data['id'],
        username: data['username'],
        email: data['email'],
        password: data["password"],
      );
  Map<String, dynamic> toDatabaseJson() => {
        "username": this.username,
        "email": this.email,
        "password": this.password,
        "account_type": "3",
      };
}

class StripeAddress {
  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

  StripeAddress(
      {this.city,
      this.country,
      this.line1,
      this.line2,
      this.postalCode,
      this.state});

  factory StripeAddress.fromDatabaseJson(Map<String, dynamic> data) =>
      StripeAddress(
          city: data['city'],
          country: data['country'],
          line1: data['line1'],
          line2: data['line2'],
          postalCode: data['postal_code'],
          state: data['state']);
  Map<String, dynamic> toDatabaseJson() => {
        "city": this.city,
        "country": this.country,
        "line1": this.line1,
        "line2": this.line2,
        "postal_code": this.postalCode,
        "state": this.state
      };

  String toString() => ''' { "city": $city,
        "country": $country,
        "line1": $line1,
        "line2": $line2,
        "postal_code": $postalCode,
        "state": $state
      } ''';
}

class StripeInvoiceSettings {
  // CustomeFields customeFields; Array of hashes -- String name; String value;
  String defaultPaymentMethod;
  String footer;

  StripeInvoiceSettings({this.defaultPaymentMethod, this.footer});

  factory StripeInvoiceSettings.fromDatabaseJson(Map<String, dynamic> data) =>
      StripeInvoiceSettings(
          defaultPaymentMethod: data["default_payment_method"],
          footer: data['footer']);

  Map<String, dynamic> toDatabaseJson() => {
        "default_payment_method": this.defaultPaymentMethod,
        "footer": this.footer
      };

  String toString() => ''' { 
        "default_payment_method": $defaultPaymentMethod,
        "footer": $footer,
    } ''';
}

class StripeShipping {
  StripeShipping({
    this.address,
    this.name,
    this.phone,
  });

  StripeAddress address;
  String name;
  String phone;

  factory StripeShipping.fromDatabaseJson(Map<String, dynamic> json) =>
      StripeShipping(
        address: StripeAddress.fromDatabaseJson(json["address"]),
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "address": this.address != null ? this.address.toDatabaseJson() : null,
        "name": this.name,
        "phone": this.phone,
      };

  String toString() => ''' { 
        "address": ${address.toString()},
        "name": $name,
        "phone": $phone
    } ''';
}

class StripeSources {
  StripeSources({
    this.object,
    this.data,
  });

  String object;
  List<Cards> data;

  factory StripeSources.fromDatabaseJson(Map<String, dynamic> json) =>
      StripeSources(
        object: json["object"],
        data: List<Cards>.from(
            json["data"].map((x) => Cards.fromDatabaseJson(x))),
      );

  Map<String, dynamic> toDatabaseJson() => {
        "object": this.object,
        "data": this.data != null
            ? List<dynamic>.from(this.data.map((x) => x.toDatabaseJson()))
            : null,
      };

  String toString() => ''' { 
        "object": $object,
        "data": ${data.toString()}
    } ''';
}

class Cards {
  Cards({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.customer,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    // this.metadata,
    this.name,
    this.tokenizationMethod,
  });

  String id;
  String object;
  String addressCity;
  String addressCountry;
  String addressLine1;
  String addressLine1Check;
  String addressLine2;
  String addressState;
  String addressZip;
  String addressZipCheck;
  String brand;
  String country;
  String customer;
  String cvcCheck;
  String dynamicLast4;
  int expMonth;
  int expYear;
  String fingerprint;
  String funding;
  String last4;
  // Map<String, String> metadata;
  String name;
  String tokenizationMethod;

  factory Cards.fromDatabaseJson(Map<String, dynamic> json) => Cards(
        id: json["id"],
        object: json["object"],
        addressCity: json["address_city"],
        addressCountry: json["address_country"],
        addressLine1: json["address_line1"],
        addressLine1Check: json["address_line1_check"],
        addressLine2: json["address_line2"],
        addressState: json["address_state"],
        addressZip: json["address_zip"],
        addressZipCheck: json["address_zip_check"],
        brand: json["brand"],
        country: json["country"],
        customer: json["customer"],
        cvcCheck: json["cvc_check"],
        dynamicLast4: json["dynamic_last4"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        last4: json["last4"],
        // metadata: json["metadata"],
        name: json["name"],
        tokenizationMethod: json["tokenization_method"],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "object": this.object,
        "address_city": this.addressCity,
        "address_country": this.addressCountry,
        "address_line1": this.addressLine1,
        "address_line1_check": this.addressLine1Check,
        "address_line2": this.addressLine2,
        "address_state": this.addressState,
        "address_zip": this.addressZip,
        "address_zip_check": this.addressZipCheck,
        "brand": this.brand,
        "country": this.country,
        "customer": this.customer,
        "cvc_check": this.cvcCheck,
        "dynamic_last4": this.dynamicLast4,
        "exp_month": this.expMonth,
        "exp_year": this.expYear,
        "fingerprint": this.fingerprint,
        "funding": this.funding,
        "last4": this.last4,
        // "metadata": this.metadata,
        "name": this.name,
        "tokenization_method": this.tokenizationMethod,
      };

  String toString() => ''' 
        { 
          "id": $id,
          "object": $object,
          "address_city": $addressCity,
          "address_country": $addressCountry,
          "address_line1": $addressLine1,
          "address_line1_check": $addressLine1Check,
          "address_line2": $addressLine2,
          "address_state": $addressState,
          "address_zip": $addressZip,
          "address_zip_check": $addressZipCheck,
          "brand": $brand,
          "country": $country,
          "customer": $customer,
          "cvc_check": $cvcCheck,
          "dynamic_last4": $dynamicLast4,
          "exp_month": $expMonth,
          "exp_year": $expYear,
          "fingerprint": $fingerprint,
          "funding": $funding,
          "last4": $last4,
          "name": $name,
          "tokenization_method": $tokenizationMethod,
        } ''';
}

TravelerStripeInfo stripeModelFromJson(String str) =>
    TravelerStripeInfo.fromDatabaseJson(jsonDecode(str));

Cards stripeCardFromJson(String str) => Cards.fromDatabaseJson(jsonDecode(str));

class TravelerStripeInfo {
  String id;
  String object;
  StripeAddress address;
  int balance;
  dynamic created;
  String currency;
  String defaultSource;
  bool delinquent;
  String description;
  // Discount discount; ---- discount class filed
  String email;
  String invoicePrefix;
  StripeInvoiceSettings invoiceSettings;
  // Map<String, String> metadata;
  bool livemode;
  String name;
  int nextInvoiceSequence;
  String phone;
  List<String> preferredLocales;
  StripeShipping shipping;
  StripeSources sources;
  String taxExempt;

  TravelerStripeInfo({
    this.id,
    this.object,
    this.address,
    this.balance,
    this.created,
    this.currency,
    this.defaultSource,
    this.delinquent,
    this.description,
    // this.discount,
    this.email,
    this.invoicePrefix,
    this.invoiceSettings,
    this.livemode,
    // this.metadata,
    this.name,
    this.nextInvoiceSequence,
    this.phone,
    this.preferredLocales,
    this.shipping,
    this.sources,
    this.taxExempt,
  });

  factory TravelerStripeInfo.fromDatabaseJson(Map<String, dynamic> json) =>
      TravelerStripeInfo(
        id: json["id"],
        object: json["object"],
        address: json["address"] != null
            ? StripeAddress.fromDatabaseJson(json["address"])
            : null,
        balance: json["balance"],
        created: json["created"],
        currency: json["currency"],
        defaultSource: json["default_source"],
        delinquent: json["delinquent"],
        description: json["description"],
        // discount: json["discount"],
        email: json["email"],
        invoicePrefix: json["invoice_prefix"],
        invoiceSettings:
            StripeInvoiceSettings.fromDatabaseJson(json["invoice_settings"]),
        livemode: json["livemode"],
        // metadata: json["metadata"],
        name: json["name"],
        nextInvoiceSequence: json["next_invoice_sequence"],
        phone: json["phone"],
        preferredLocales: json["preferred_locales"] != null
            ? List<String>.from(json["preferred_locales"].map((x) => x))
            : List<String>(),
        shipping: json["shipping"] != null
            ? StripeShipping.fromDatabaseJson(json["shipping"])
            : null,
        sources: json["sources"] != null
            ? StripeSources.fromDatabaseJson(json["sources"])
            : null,
        taxExempt: json["tax_exempt"],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "object": this.object,
        "address": this.address != null ? this.address.toDatabaseJson() : null,
        "balance": this.balance,
        "created": this.created,
        "currency": this.currency,
        "default_source": this.defaultSource,
        "delinquent": this.delinquent,
        "description": this.description,
        // "discount": this.discount,
        "email": this.email,
        "invoice_prefix": this.invoicePrefix,
        "invoice_settings": this.invoiceSettings != null
            ? this.invoiceSettings.toDatabaseJson()
            : null,
        "livemode": this.livemode,
        // "metadata": this.metadata,
        "name": this.name,
        "next_invoice_sequence": this.nextInvoiceSequence,
        "phone": this.phone,
        "preferred_locales": this.preferredLocales != null
            ? List<dynamic>.from(this.preferredLocales.map((x) => x))
            : null,
        "shipping":
            this.shipping != null ? this.shipping.toDatabaseJson() : null,
        "sources": this.sources != null ? this.sources.toDatabaseJson() : null,
        "tax_exempt": this.taxExempt,
      };

  String toString() => ''' Traveler Stripe Account Information: 
  {
    "id": $id,
    "object": $object,
    "address": ${address.toString()},
    "balance": $balance,
    "created": $created,
    "currency": $currency,
    "default_source": $defaultSource,
    "delinquent": $delinquent,
    "description": $description,
    "email": $email,
    "invoice_prefix": $invoicePrefix,
    "invoice_settings": ${invoiceSettings.toString()},
    "livemode": $livemode,
    "name": $name,
    "next_invoice_sequence": $nextInvoiceSequence,
    "phone": $phone,
    "preferred_locales": $preferredLocales,
    "shipping": ${shipping.toString()},
    "sources": ${sources.toString()},
    "tax_exempt": $taxExempt,
  }  
  ''';
}

class TravelerSignup {
  int id;
  UserSignup user;
  String firstName;
  String middleName;
  String lastName;
  String country;
  String phone;
  String emergencyName;
  String emergencyRelation;
  String emergencyEmail;
  String emergencyPhone;
  String stripeId;
  // EphemeralKey ephemeralKey;

  TravelerSignup({
    this.id,
    this.user,
    this.firstName,
    this.middleName,
    this.lastName,
    this.country,
    this.phone,
    this.emergencyName,
    this.emergencyRelation,
    this.emergencyEmail,
    this.emergencyPhone,
    this.stripeId,
    // this.ephemeralKey,
  });

  Map<String, dynamic> toDatabaseJson() => {
        "user": this.user.toDatabaseJson(),
        "first_name": this.firstName,
        "middle_name": this.middleName,
        "last_name": this.lastName,
        // "phone": this.phone,
        // "emergency_contact_name": this.emergencyName,
        // "emergency_contact_phone": this.emergencyPhone,
      };
  // Map<String, dynamic> toDatabaseJsonNames() => {
  //       "first_name": this.firstName,
  //       "middle_name": this.middleName,
  //       "last_name": this.lastName,
  //     };
  Map<String, dynamic> toDatabaseJsonNames() {
    Map<String, dynamic> names = {};
    if (this.firstName.isNotEmpty) {
      print("first name is not empty");
      names["first_name"] = this.firstName;
    }
    if (this.middleName.isNotEmpty) {
      print("middle name is  not empty");
      names["middle_name"] = this.middleName;
    }
    if (this.lastName.isNotEmpty) {
      print("last name is not empty");
      names["last_name"] = this.lastName;
    }
    return names;
  }

  Map<String, dynamic> toDatabaseJsonContact() {
    Map<String, dynamic> contacts = {};
    Map<String, dynamic> email = {};
    if (this.user.email.isNotEmpty) {
      email["email"] = this.user.email;
      contacts["user"] = email;
    }
    if (this.phone.isNotEmpty) {
      contacts["phone"] = this.phone;
    }
    print("The contacts are  $contacts");
    return contacts;
  }

  Map<String, dynamic> toDatabaseJsonEmergencyContact() {
    Map<String, dynamic> emergencyContacts = {};
    if (this.emergencyName.isNotEmpty) {
      emergencyContacts["emergency_contact_name"] = this.emergencyName;
    }
    if (this.emergencyRelation.isNotEmpty) {
      emergencyContacts["emergency_contact_relation"] = this.emergencyRelation;
    }
    if (this.emergencyEmail.isNotEmpty) {
      emergencyContacts["emergency_contact_email"] = this.emergencyEmail;
    }
    if (this.emergencyPhone.isNotEmpty) {
      emergencyContacts["emergency_contact_phone"] = this.emergencyPhone;
    }
    print("The contacts are  $emergencyContacts");
    return emergencyContacts;
  }

  Map<String, dynamic> toDatabaseJsonCountry() {
    Map<String, dynamic> country = {};
    if (this.country.isNotEmpty) {
      country["country"] = this.country;
    }
    print("The contacts are  $country");
    return country;
  }

  factory TravelerSignup.fromDatabaseJson(Map<String, dynamic> data) =>
      TravelerSignup(
        id: data['id'],
        user: UserSignup.fromDatabaseJson(data['user']),
        firstName: data['first_name'],
        middleName: data['middle_name'],
        lastName: data["last_name"],
        country: data['country'],
        phone: data['phone'],
        emergencyName: data['emergency_contact_name'],
        emergencyRelation: data['emergency_contact_relation'],
        emergencyEmail: data['emergency_contact_email'],
        emergencyPhone: data['emergency_contact_phone'],
        stripeId: data['stripe_id'],
        // ephemeralKey: EphemeralKey.fromDatabaseJson(data['ephemeral_key'])
      );

  @override
  String toString() => '''Traveler Information  { 
                        displayName: ${user.username}, 
                        travelerID: $id,
                        firstName: $firstName,
                        middleName: $middleName,
                        LastName: $lastName,
                        country: $country,
                        user ID: ${user.id},
                        username: ${user.username},
                        email: ${user.email},
                        phone: $phone,
                        emergency_contact_name: $emergencyName,
                        emergency_contact_relation: $emergencyRelation,
                        emergency_contact_phone: $emergencyPhone,
                        emergency_contact_email: $emergencyEmail,
                        stripe_id: $stripeId,
                      }''';
}

class Password {
  String oldPassword;
  String newPassword;
  String newPassword2;

  Password({this.oldPassword, this.newPassword, this.newPassword2});

  Map<String, dynamic> toDatabaseJson() => {
        "old_password": this.oldPassword,
        "password": this.newPassword,
        "password2": this.newPassword2,
      };
}

class Token {
  String token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}

class Option {
  String label;
  String value;

  Option({this.label, this.value});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(label: json["label"], value: json["value"]["input"]["text"]);
  }
}

class Response {
  String responseText;
  List<Option> options;

  Response({this.responseText, this.options});
}

// class AssociatedObject {
//   String type;
//   String id;

//   AssociatedObject({this.type, this.id});

//   factory AssociatedObject.fromDatabaseJson(Map<String, dynamic> data) =>
//       AssociatedObject(id: data['id'], type: data['type']);

//   Map<String, dynamic> toDatabaseJson() => {"id": this.id, "type": this.type};

//   @override
//   String toString() => '''{
//     "id": $id,
//     "type": $type
//   }''';
// }

// class EphemeralKey {
//   String id;
//   String object;
//   List<AssociatedObject> associatedObjects;
//   int created;
//   int expires;
//   bool livemode;
//   String secret;

//   EphemeralKey(
//       {this.id,
//       this.object,
//       this.associatedObjects,
//       this.created,
//       this.expires,
//       this.livemode,
//       this.secret});

//   factory EphemeralKey.fromDatabaseJson(Map<String, dynamic> data) =>
//       EphemeralKey(
//           id: data['id'],
//           object: data['object'],
//           associatedObjects: data["associated_objects"] != null
//               ? List<AssociatedObject>.from(data["associated_objects"]
//                   .map((x) => AssociatedObject.fromDatabaseJson(x)))
//               : List<AssociatedObject>(),
//           created: data['created'],
//           expires: data['expires'],
//           livemode: data['livemode'],
//           secret: data['secret']);

//   Map<String, dynamic> toDatabaseJson() => {
//         "id": this.id,
//         "object": this.object,
//         "associated_objects": List<dynamic>.from(
//             associatedObjects.map((x) => x.toDatabaseJson())),
//         "created": this.created,
//         "expires": this.expires,
//         "livemode": this.livemode,
//         "secret": this.secret
//       };

//   @override
//   String toString() => '''{
//     "associated_objects" : ${associatedObjects.toString()},
//     "created": $created,
//     "expires": $expires,
//     "id": $id,
//     "livemode": $livemode,
//     "object": $object,
//     "secret": $secret
//   }''';
// }

// class StripeModel {
//   StripeModel({
//     this.ephemeralKey,
//   });

//   EphemeralKey ephemeralKey;

//   factory StripeModel.fromDatabaseJson(Map<String, dynamic> json) =>
//       StripeModel(
//         ephemeralKey: EphemeralKey.fromDatabaseJson(json["ephemeral_key"]),
//       );

//   Map<String, dynamic> toDatabaseJson() => {
//         "ephemeral_key": ephemeralKey.toDatabaseJson(),
//       };
// }

// class TravelerStripe {
//   int id;
//   int user;
//   String stripeId;
//   EphemeralKey ephemeralKey;

//   TravelerStripe({this.id, this.user, this.stripeId, this.ephemeralKey});

//   factory TravelerStripe.fromDatabaseJson(Map<String, dynamic> data) =>
//       TravelerStripe(
//           id: data['id'],
//           user: data['user'],
//           stripeId: data['stripeId'],
//           ephemeralKey: EphemeralKey.fromDatabaseJson(data['ephemeral_key']));

//   Map<String, dynamic> toDatabaseJson() => {
//         "id": this.id,
//         "user": this.user,
//         "stripe_id": this.stripeId,
//         "ephemeral_key": this.ephemeralKey.toDatabaseJson(),
//       };
// }
