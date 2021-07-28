import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:getLost_app/alert_dialogs/cupertino_error.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_payment/stripe_payment.dart' as stripe;

class CreditCardPage extends StatefulWidget {
  final String stripeId;
  CreditCardPage({Key key, @required this.stripeId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CreditCardPageState(stripeId: stripeId);
  }
}

class CreditCardPageState extends State<CreditCardPage> {
  final String stripeId;
  CreditCardPageState({this.stripeId});

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<dynamic> cardInfoList = [];

  CreditCard card = CreditCard();
  bool success;

  createCardObject(List listCard) {
    String cardNum = listCard[0].replaceAll(' ', '');
    print(cardNum);
    List<String> splitExpDate = listCard[1].split('/');
    int expMonth = int.parse(splitExpDate[0]);
    int expYear = int.parse(splitExpDate[1]);
    card = CreditCard(
        number: cardNum,
        expMonth: expMonth,
        expYear: expYear,
        name: listCard[2],
        cvc: listCard[3]);
    print(card.toJson());
    return card;
  }

  validationMessage(bool success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: success == true
          ? Text("Card Successfully Created")
          : Text("Invalid Card Information"),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {},
      ),
    ));
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: success == true
    //       ? Text("Card Successfully Created")
    //       : Text("Invalid Card Information"),
    //   duration: new Duration(milliseconds: success == true ? 1200 : 3000),
    // ));
  }

  createCardPressed(CreditCard card) async {
    StripePayment.createTokenWithCard(
      card,
    ).then((token) async {
      Cards newCard =
          await StripeService.createNewCard(stripeId, token.tokenId);
    });
  }

  @override
  void initState() {
    super.initState();

    // Future<String> ephKey = getEphemeralKey();
    // getEphemeralKey();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51H0CQsHCy8Q2hv8oOWqUqzmCH9x80R555acMCP1QPVmbcLrF47nX2pwBgqUxsOsFjUUoyp0MYvLBCSUMbhBHqISx002ei3qvVk',
        merchantId: 'tomasmbriseno@gmail.com',
        androidPayMode: 'test',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal[50],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(color: Color(0xff9F9F9F)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Add New Card",
          style: TextStyle(
            color: Color(0xff9F9F9F),
            fontSize: 24,
            fontFamily: "SF-Pro-Bold",
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardBgColor: Color(0xff0093B1),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumberDecoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        // labelText: 'Number',
                        hintText: 'Card Number',
                        hintStyle: TextStyle(
                            color: Color(0xff9F9F9F),
                            fontFamily: "SF-Pro-Medium",
                            fontSize: 16),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff0093B1))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffE4E4E4))),
                      ),
                      expiryDateDecoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        // labelText: 'Expired Date',
                        hintText: 'Exp Date',
                        hintStyle: TextStyle(
                            color: Color(0xff9F9F9F),
                            fontFamily: "SF-Pro-Medium",
                            fontSize: 16),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff0093B1))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffE4E4E4))),
                      ),
                      cvvCodeDecoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        // labelText: 'CVV',
                        hintText: 'CVV',
                        hintStyle: TextStyle(
                            color: Color(0xff9F9F9F),
                            fontFamily: "SF-Pro-Medium",
                            fontSize: 16),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff0093B1))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffE4E4E4))),
                      ),
                      cardHolderDecoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        // labelText: 'Card Holder Name',
                        hintText: "Card Holder Name",
                        hintStyle: TextStyle(
                            color: Color(0xff9F9F9F),
                            fontFamily: "SF-Pro-Medium",
                            fontSize: 16),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff0093B1))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xffE4E4E4))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      minWidth: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height / 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(0xff0093B1),
                      textColor: Colors.white,
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          print('valid!');
                          card = createCardObject(cardInfoList);

                          try {
                            stripe.Token response =
                                await StripePayment.createTokenWithCard(
                              card,
                            );
                            print("the response is: ${response.toJson()}");
                            await StripeService.createNewCard(
                                stripeId, response.tokenId);
                            Navigator.of(context).pop(cardInfoList);
                          } on PlatformException catch (err) {
                            // Handle err
                            print("The error is 1: ${err.message}");
                            openDialog("Card Not Valid", "${err.message}",
                                "Try Again", context);
                          } catch (err) {
                            print("The error is 3: ${err.message}");
                            // other types of Exceptions
                            openDialog("Card Not Valid", "${err.message}",
                                "Try Again", context);
                          }
                        } else {
                          print('invalid!');
                        }

                        // if (formKey.currentState.validate()) {
                        //   print('valid!');
                        // } else {
                        //   print('invalid!');
                        //   success = false;
                        // }

                        // // print(cardInfoList);
                        // card = createCardObject(cardInfoList);
                        // // StripeService.createTokenWithCard(card);
                        // // success = true;

                        // // its not working here because the stripepayment method is an await so
                        // // the success bool is null and wont work since the validatemessage and timer
                        // // both run before the await is completed
                        // StripePayment.createTokenWithCard(
                        //   card,
                        // ).then((token) async {
                        //   // print(token.tokenId);
                        //   // print(stripeId);
                        //   Cards newCard = await StripeService.createNewCard(
                        //       stripeId, token.tokenId);
                        //   // print("the other response: $newCard");
                        //   if (newCard == null) {
                        //     print("new card is null");
                        //     success = false;
                        //   } else {
                        //     print("new card is not null");
                        //     success = true;
                        //   }
                        //   validationMessage(success);
                        //   if (success == true) {
                        //     Timer(Duration(seconds: 1), () {
                        //       Navigator.of(context).pop(cardInfoList);
                        //     });
                        //   }
                        // });
                        // // bool answers = createCardPressed(card);
                        // // print("The successness of the thingy: $success");
                      },
                      child: Text(
                        "Validate",
                        style: TextStyle(
                          fontSize: 26.0,
                          // color: Colors.black,
                          fontFamily: "SF-Pro-Medium",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<AlertDialog> _showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1b447b),
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop(cardInfoList);
                }),
          ],
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      cardInfoList = [
        cardNumber,
        expiryDate,
        cardHolderName,
        cvvCode,
        isCvvFocused
      ];
    });
  }
}
