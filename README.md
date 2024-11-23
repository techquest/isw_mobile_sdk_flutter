# isw_mobile_sdk

This library aids in processing payment through the following channels
- [x] Card
- [x] Verve Wallet
- [x] QR Code
- [X] USSD


## Getting started

There are three steps you would have to complete to set up the SDK and perform transaction
 - Install the SDK as a dependency
 - Configure the SDK with Merchant Information
 - Initiate payment with customer details


### Installation
To install the sdk add the following to your dependencies map in pubspec.yaml 

```ruby

dependencies:
  #.... others

  # add the dependency for sdk
  isw_mobile_sdk: '<latest-version>'

```


### Configuration
You would also need to configure the project with your merchant credentials.

```dart
import 'dart:async';
import 'package:isw_mobile_sdk/isw_mobile_sdk.dart';


class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initSdk();
  }

    // messages to SDK are asynchronous, so we initialize in an async method.
  Future<void> initSdk() async {

    // messages may fail, so we use a try/catch PlatformException.
    try {
        String  merchantId = "your-merchant-id",
        merchantCode = "your-merchant-code",
        merchantSecret = "your-merchant-secret",
        currencyCode = "currency-code"; // e.g  566 for NGN

        var config = new IswSdkConfig (
            merchantId, 
            merchantKey, 
            merchantCode, 
            currencyCode
        );

        // initialize the sdk
        await IswMobileSdk.initialize(config);
        // intialize with environment, default is Environment.TEST
        // IswMobileSdk.initialize(config, Environment.SANDBOX);

    } on PlatformException {}
  }
}

```

Once the SDK has been initialized, you can then perform transactions.



#### Performing Transactions
You can perform a transaction, once the SDK is configured, by providing the payment info and payment callbacks, like so:


```dart

  Future<void> pay(int amount) async {

    var customerId = "<customer-id>",
        customerName = "<customer-name>",
        customerEmail = "<customer.email@domain.com>",
        customerMobile = "<customer-phone>",
        // generate a unique random
        // reference for each transaction
        reference = "<your-unique-ref>";

    
    // initialize amount
    // amount expressed in lowest
    // denomination (e.g. kobo): "N500.00" -> 50000
    int amountInKobo = amount * 100

    // create payment info
    var iswPaymentInfo = new IswPaymentInfo(
        customerId, 
        customerName,
        customerEmail, 
        customerMobile, 
        reference, 
        amountInKobo
    );


    // trigger payment
    var result = await IswMobileSdk.pay(iswPaymentInfo);

    // process result
    handleResult(result)
  }
```


#### Handling Result
To handle result all you need to do is process the result in the callback methods: whenever the user cancels, the `value` would be `null` and `hasValue` would be `false`. When the transaction is complete, `hasValue` would be true and `value` would have an instance of `IswPaymentResult`: an object with the below fields.

| Field                 | Type          | meaning  |   
|-----------------------|---------------|----------|
| responseCode          | String        | txn response code  |
| responseDescription   | String        | txn response code description |
| isSuccessful          | boolean       | flag indicates if txn is successful  |
| transactionReference  | String        | reference for txn  |
| amount                | Number           | txn amount  |
| channel               | String| channel used to make payment: one of `CARD`, `WALLET`, `QR`, `USSD`  |


```dart

void handleResult(Optional<IswPaymentResult> result) {

    if (result.hasValue) {
        // process result
        showPaymentSuccess(result.value);
    } else { 
        showPaymentError()
    }
    
}

````

And that is it, you can start processing payment in your flutter app.

## Note
The Android Platform might have build exceptions, showing dexing issues, and you would need to enable [Multidexing](https://developer.android.com/studio/build/multidex) to build successfully. You can take a look at the `Application` class in the android project, for reference.

## Proguard Rules
Check here for the proguard rules for when you want to build a release version. 
https://github.com/techquest/isw-mobile-payment-sdk-android?tab=readme-ov-file#proguard

