import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_payment/stripe_payment.dart' as Token;

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = "https://api.stripe.com/v1";
  static String customerApiUrl = '${StripeService.apiBase}/customers';
  static String customerPaymentMethodsApiUrl =
      '${StripeService.apiBase}/payment_methods';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51H0CQsHCy8Q2hv8oGTfA16tkNPaKKLck0IPQTuVKK5In3ii5KK4x4110gH8eXa3UVBJdXXWWy5SCN8E1dDuo880p00MhYjL0r2';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51H0CQsHCy8Q2hv8oOWqUqzmCH9x80R555acMCP1QPVmbcLrF47nX2pwBgqUxsOsFjUUoyp0MYvLBCSUMbhBHqISx002ei3qvVk',
        merchantId: 'tomasmbriseno@gmail.com',
        androidPayMode: 'test',
      ),
    );
  }

  static StripeTransactionResponse payWithExistingCard(
      {String amount, String currency}) {
    return StripeTransactionResponse(
        message: "Transaction Successful", success: true);
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      print(jsonEncode(paymentMethod));
      return StripeTransactionResponse(
          message: "Transaction Successful", success: true);
    } catch (err) {
      return StripeTransactionResponse(
          message: "Transaction failed: ${err.toString()}", success: true);
    }
  }

  static Future<TravelerStripeInfo> getStripeCustomer(String stripeId) async {
    try {
      var response = await http.get("${StripeService.customerApiUrl}/$stripeId",
          headers: <String, String>{
            'Authorization': 'Bearer ${StripeService.secret}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      TravelerStripeInfo travelerStripe = stripeModelFromJson(response.body);
      // debugPrint(travelerStripe.toString());
      // String currency = travelerStripe.currency;
      // String defaultCardId = travelerStripe.defaultSource;
      // List<Cards> cards = [];
      // var index = 1;
      // for (Cards item in travelerStripe.sources.data) {
      //   print("Card number $index is: ${item.toString()}");
      //   cards.add(item);
      //   index++;
      // }
      // print(cards);
      // for (Cards card in cards) {
      //   print(card.last4);
      // }
      return travelerStripe;
      // Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      // debugPrint(stripeResponse.toString());
      // List<dynamic> sources = stripeResponse['sources']['data'];
      // String defaultCard = stripeResponse['default_source'];
      // // print("the default card is: $defaultCard");
      // // print(sources.toString());
      // var index = 1;
      // for (var item in sources) {
      //   print("Card number $index is: ${item['id']}");
      //   index++;
      // }
      // return jsonDecode(response.body);
    } catch (err) {
      print('error when finding user stripe: ${err.toString()}');
      return (err);
    }
  }

  static Future<Cards> createNewCard(String stripeId, cardToken) async {
    try {
      final body = {
        'source': '$cardToken',
      };
      var response =
          await http.post("${StripeService.customerApiUrl}/$stripeId/sources",
              headers: <String, String>{
                'Authorization': 'Bearer ${StripeService.secret}',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body);
      Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      Cards card;
      String responseFirst = stripeResponse.entries.first.key;
      print("The first value is: $responseFirst");
      // if (error == "card_declined") {
      if (responseFirst == "error") {
        print("Its wrong");
        //   //   throw ("Token Error - card declined");
      } else {
        print("its right");
        // print("first error: $stripeResponse");
        card = stripeCardFromJson(response.body);
        // print("second error: $card.toString()");
      }
      // print("first error: $stripeResponse");
      // card = stripeCardFromJson(response.body);
      // print("second error: $card.toString()");
      return card;
    } catch (err) {
      print('error when finding user stripe: ${err.toString()}');
      return (err);
    }
  }

  static deleteCard(String stripeId, String cardId) async {
    try {
      var response = await http.delete(
          "${StripeService.customerApiUrl}/$stripeId/sources/$cardId",
          headers: <String, String>{
            'Authorization': 'Bearer ${StripeService.secret}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      print(stripeResponse);
      return stripeResponse;
    } catch (err) {
      print(err.toString());
    }
  }

  static changeDefaultCard(String stripeId, String cardId) async {
    try {
      final body = {"default_source": "$cardId"};
      var response =
          await http.post("${StripeService.customerApiUrl}/$stripeId",
              headers: <String, String>{
                'Authorization': 'Bearer ${StripeService.secret}',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body);
      Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      // print(stripeResponse);
      return stripeResponse;
    } catch (err) {
      print(err.toString());
    }
  }

  static Future<Map<String, dynamic>> getStripeCustomerCards(
      String stripeId) async {
    try {
      final body = {
        'customer': '$stripeId',
        'type': 'card',
      };
      final headers = <String, String>{
        'Authorization': 'Bearer ${StripeService.secret}',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      final response = await http.get(
        "${StripeService.customerPaymentMethodsApiUrl}?customer=$stripeId&type=card",
        headers: headers,
      );
      Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      // print("The customers payment methods: $stripeResponse");
      List<dynamic> data = stripeResponse['data'];
      // print(data[0]);
      for (var item in data) {
        // print(item);
        String cardId = item['id'];
        print(cardId);
        var cardInfo = await getStripeCardInformation(stripeId, cardId);
      }
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  static Future<Map<String, dynamic>> getStripeCardInformation(
      String stripeId, String cardId) async {
    try {
      var response = await http.get(
          "${StripeService.customerApiUrl}/$stripeId/sources/$cardId",
          headers: <String, String>{
            'Authorization': 'Bearer ${StripeService.secret}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      Map<String, dynamic> stripeResponse = jsonDecode(response.body);
      print(stripeResponse);
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  // static Future<StripeTransactionResponse>
  static Future<String> chargeCard(
      {String amount,
      String currency,
      Cards card,
      String hostelId,
      String travelerId}) async {
    try {
      String newAmount = amount.replaceAll(".", "");
      // var paymentMethod = await StripePayment.createPaymentMethod(
      //     PaymentMethodRequest(card: card));
      var paymentIntent = await StripeService.createPaymentIntent(
          newAmount, currency, hostelId, travelerId);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: card.id));
      if (response.status == 'succeeded') {
        return ("IT WORKED");
        // return new StripeTransactionResponse(
        //     message: 'Transaction successful', success: true);
      } else {
        return ("IT did not work... sad");
        // return new StripeTransactionResponse(
        //     message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      // return new StripeTransactionResponse(
      //     message: 'Transaction failed: ${err.toString()}', success: false);
      return ("Transaction failed: ${err.toString()}");
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    // return new StripeTransactionResponse(message: message, success: false);
    return message;
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency, String hostelId, String travelerId) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
        "on_behalf_of": hostelId,
        "customer": travelerId
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
