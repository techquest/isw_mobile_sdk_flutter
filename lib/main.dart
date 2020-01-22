import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:isw_mobile_sdk/isw_mobile_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _amountString = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
        String  merchantId = "your-merchant-id",
          merchantCode = "your-merchant-code",
          merchantSecret = "your-merchant-secret",
          currencyCode = "currency-code";

      var config = new IswSdkConfig(
        merchantId, 
        merchantSecret, 
        merchantCode, 
        currencyCode
      );

      // initialize the sdk
      await IswMobileSdk.initialize(config);
      // intialize with environment, default is Environment.TEST
      // IswMobileSdk.initialize(config, Environment.SANDBOX);

    } on PlatformException {}
  }

  Future<void> pay(BuildContext context) async {
    // save form
    this._formKey.currentState.save();
    
    String customerId = "<customer-id>",
        customerName = "<customer-name>",
        customerEmail = "<customer.email@domain.com>",
        customerMobile = "<customer-phone>",
        // generate a unique random
        // reference for each transaction
        reference = "<your-unique-ref>";

    int amount;
    // initialize amount
    if (this._amountString.length == 0)
      amount = 2500 * 100;
    else
      amount = int.parse(this._amountString) * 100;

    // create payment info
    IswPaymentInfo iswPaymentInfo = new IswPaymentInfo(customerId, customerName,
        customerEmail, customerMobile, reference, amount);

    print(iswPaymentInfo);

    // trigger payment
    var result = await IswMobileSdk.pay(iswPaymentInfo);

    var message;
    if (result.hasValue) {
      message = "You completed txn using: " + result.value.channel.toString();
    } else {
      message = "You cancelled the transaction pls try again";
    }
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Charity Fortune'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: new Form(
              key: this._formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onSaved: (String val) {
                      this._amountString = val;
                    },
                  ),
                  Builder(
                    builder: (ctx) => new Container(
                      width: MediaQuery.of(ctx).size.width,
                      child: RaisedButton(
                        child: Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => pay(ctx),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
