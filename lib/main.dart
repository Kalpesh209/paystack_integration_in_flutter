import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack_integration/widgets/pay_button_widget.dart';

/*
Title:Entry Point of a Application
Purpose:Entry Point of a Application
Created By:Kalpesh Khandla
Created Date: 30 April 2021
*/

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaystackCardMethod(),
    );
  }
}

class PaystackCardMethod extends StatefulWidget {
  @override
  _PaystackCardMethodState createState() => _PaystackCardMethodState();
}

class _PaystackCardMethodState extends State<PaystackCardMethod> {
  String publicKeyTest = 'pk_test_fa5c1528fe08ce40bd082d85a3faaa6b9a5c150f';

  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    super.initState();
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  chargeCard() async {
    var charge = Charge()
      ..amount = 10000 * 100
      ..reference = _getReference()
      ..putCustomField('custom_id', '84687546')
      ..email = 'khandlakalpesh20@gmail.com';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      _showMessage('Payment was successful!!!');
    } else {
      _showMessage('Payment Failed!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Paystack Integration",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: EdgeInsets.all(15),
              child: PayButtonWidget(
                onCallBackTap: () => chargeCard(),
              ),
            ),
          )),
    );
  }
}
