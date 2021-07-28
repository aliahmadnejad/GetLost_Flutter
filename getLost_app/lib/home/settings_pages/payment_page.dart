import 'package:flutter/material.dart';
import 'package:getLost_app/alert_dialogs/cupertino_error.dart';
import 'package:getLost_app/api_connection/stripe_connection.dart';
import 'package:getLost_app/home/settings_pages/new_card_page.dart';
import 'package:getLost_app/model/api_model.dart';
import 'package:provider/provider.dart';
import 'package:getLost_app/home/bloc/home_page_bloc.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentPageState();
  }
}

class PaymentPageState extends State<PaymentPage> {
  PaymentPageState();

  // TravelerStripeInfo stripeCustomer;
  // List<Cards> stripeCustomerCards;
  // Cards stripeCustomerDefaultCard;
  String cardIconPath = '';

  String getCardIcon(String cardType) {
    switch (cardType) {
      case 'American Express':
        cardIconPath = "assets/images/card_types/american_express.png";
        break;
      case 'Diners Club':
        cardIconPath = "assets/images/card_types/diners_club.png";
        break;
      case 'Discover':
        cardIconPath = "assets/images/card_types/discover.png";
        break;
      case 'JCB':
        cardIconPath = "assets/images/card_types/jcb.png";
        break;
      case 'MasterCard':
        cardIconPath = "assets/images/card_types/mastercard2.png";
        break;
      case 'UnionPay':
        cardIconPath = "assets/images/card_types/credit_card.png";
        break;
      case 'Visa':
        cardIconPath = "assets/images/card_types/visa_electron.png";
        break;
      case 'Unknown':
        cardIconPath = "assets/images/card_types/credit_card.png";
        break;
    }
    return cardIconPath;
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Padding(
        padding: const EdgeInsets.only(top: 60, left: 0, right: 0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
              child: Text(
                "Payment Methods",
                style: TextStyle(
                  color: Color(0xff9F9F9F),
                  fontSize: 24,
                  fontFamily: "SF-Pro-Bold",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FlatButton(
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: Color(0xff9F9F9F)),
                    Text(
                      "  Add New Card",
                      style: TextStyle(
                        color: Color(0xff9F9F9F),
                        fontSize: 16,
                        fontFamily: "SF-Pro-Medium",
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  print(applicationBloc.travelerInfo.stripeId);
                  final result =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreditCardPage(
                        stripeId: applicationBloc.travelerInfo.stripeId),
                  ));
                  if (result != null) {
                    print(result);
                    print(result.toString());
                    // await getTravelerStripeInformation();
                    applicationBloc.setStripeInfo(applicationBloc.travelerInfo);
                  }
                  print(applicationBloc.stripeCustomer.email);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 5, bottom: 5),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 20.0),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "Existing Cards:",
                  style: TextStyle(
                    color: Color(0xff9F9F9F),
                    fontSize: 20,
                    fontFamily: "SF-Pro-Bold",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                padding: const EdgeInsets.all(0),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: applicationBloc.stripeCustomerCards.length,
                    itemBuilder: (BuildContext context, int index) {
                      Cards card = applicationBloc.stripeCustomerCards[index];
                      String indexCardId = card.id;
                      String path = getCardIcon(card.brand);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: ListTile(
                              // minVerticalPadding: 0.0,
                              // dense: true,
                              enabled: true,
                              leading: Container(
                                // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                // padding: EdgeInsets.only(
                                //     left: MediaQuery.of(context).size.width / 10,
                                //     right: MediaQuery.of(context).size.width / 10),
                                child: IconButton(
                                  iconSize: 40,
                                  color: Color(0xff9F9F9F),
                                  icon: ImageIcon(
                                    AssetImage(path),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              // Text("${card.brand}"),
                              title: Text("**** **** **** ${card.last4}",
                                  style: TextStyle(
                                    color: Color(0xff9F9F9F),
                                    fontSize: 18,
                                    fontFamily: "SF-Pro-SB",
                                  )),
                              subtitle: Text("${card.expMonth}/${card.expYear}",
                                  style: TextStyle(
                                    color: Color(0xff9F9F9F),
                                    fontSize: 14,
                                    fontFamily: "SF-Pro-Regular",
                                  )),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  card !=
                                          applicationBloc
                                              .stripeCustomerDefaultCard
                                      ? IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          icon: Icon(
                                            Icons.check,
                                            size: 20.0,
                                            color: Color(0xff9F9F9F),
                                          ),
                                          onPressed: () async {
                                            // print("Set as Default $indexCardId");
                                            await StripeService
                                                .changeDefaultCard(
                                                    applicationBloc
                                                        .travelerInfo.stripeId,
                                                    indexCardId);
                                            applicationBloc.setStripeInfo(
                                                applicationBloc.travelerInfo);
                                            // await getTravelerStripeInformation();
                                          },
                                        )
                                      : Text("Default",
                                          style: TextStyle(
                                            color: Color(0xff9F9F9F),
                                            fontSize: 14,
                                            fontFamily: "SF-Pro-SB",
                                          )),
                                  IconButton(
                                    padding: const EdgeInsets.all(0.0),
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20.0,
                                      color: Color(0xff9F9F9F),
                                    ),
                                    onPressed: () async {
                                      if (index > 0) {
                                        print("Delete $indexCardId");
                                        await StripeService.deleteCard(
                                            applicationBloc
                                                .travelerInfo.stripeId,
                                            indexCardId);
                                        // await getTravelerStripeInformation();
                                        applicationBloc.setStripeInfo(
                                            applicationBloc.travelerInfo);
                                      } else {
                                        print("it is the last card");
                                        openDialog(
                                            "Last Card",
                                            "Add new card to remove",
                                            "Ok",
                                            context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Divider(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}
