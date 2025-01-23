[View SDK Wiki](https://github.com/edfapay/edfa-pg-ios-sdk-pod/wiki) | [Report new issue](https://github.com/edfapay/edfa-pg-ios-sdk-pod/issues/new)

# EdfaPg iOS SDK

EdfaPg is a payment gateway. Thanks to our 15+ years of experience in the payment industry, we’ve developed a state-of-the-art white-label payment system that ensures smooth and uninterrupted payment flow for merchants across industries.

<p align="center">
  <a href="https://edfapay.com">
      <img src="/media/header.png" alt="EdfaPg" width="400px"/>
  </a>
</p>

EdfaPg iOS SDK was developed and designed with one purpose: to help the iOS developers easily integrate the EdfaPg API Payment Platform for a specific merchant. 

The main aspects of the EdfaPg iOS SDK:

- [Swift](https://developer.apple.com/swift/) is the main language 
- Minimum iOS 11
- Sample Application

To get used to the SDK, download a [sample app](https://github.com/edfapay/edfa-pg-ios-sdk-sample ).

## Setup

Add to the `Podfile`:

```
pod 'EdfaPgSdk'
```

Always download latest version by run `pod update` or `pod install --repo-update`


## Usage
> [!IMPORTANT]
> ### Initialize SDK
>
> You should initialise Edfapay SDK. We recommend to do it in AppDelegate.swift file:
> ```swift
>   let edfaPgCredential = EdfaPgCredential(
>            clientKey: MERCHANT_KEY,
>            clientPass: MERCHANT_PASSWORD,
>            paymentUrl: PAYMENT_URL
>        )       
>        EdfaPgSdk.config(edfaPgCredential)
> ```

> [!TIP]
> ### Get Ready for Payment
> > **Create `EdfaPgSaleOrder` Model**
> > ```swift
> >     let order = EdfaPgSaleOrder(
> >        id: UUID().uuidString,
> >        description: "Test Order",
> >        currency: "SAR",
> >        amount: 1.00//Random().nextInt(9)/10, // will not exceed 0.9
> >    );
> > ```
>
> > **Create `EdfaPgPayer` Model**
> > ```swift
> >    let payer = EdfaPgPayer(
> >        firstName: "First Name",
> >        lastName: "Last Name",
> >        address: "EdfaPay Payment Gateway",
> >        country: "SA",
> >        city: "Riyadh",
> >        zip: "123768",
> >        email: "support@edapay.com",
> >        phone: "+966500409598",
> >        ip: "66.249.64.248",
> >        options: EdfaPgPayerOption( // Options
> >            middleName: "Middle Name",
> >            birthdate: DateTime.parse("1987-03-30"),
> >            address2: "Usman Bin Affan",
> >            state: "Al Izdihar"
> >        )
> >    );
> > ```
> 
> > **Payment with SDK Card UI**
> > ```swift
> >    EdfaCardPay()
> >         .set(order: order)
> >         .set(payer: payer)
> >         .set(designType: .one)
> >         .set(language: .ar)
> >         .on(transactionFailure: { result, err in
> >                 debugPrint(result ?? "No Result")
> >                 debugPrint(err ?? "No Error Summary")
> >             })
> >             .on(transactionSuccess: { res, data in
> >                 debugPrint(res ?? "Missing Result")
> >                 debugPrint(data ?? "Missing Data")
> >             }).initialize(
> >                 target: self,
> >                 onError: { err in
> >                     debugPrint(err)
> >                 },
> >                 onPresent: {
> >                     debugPrint("onPresent :)")
> >                 }
> >             )
> > ```
>
> > **Pay With ApplePay**
> > ```swift
> >   EdfaApplePay()
> >             .set(order: order)
> >             .set(payer: payer)
> >             .set(applePayMerchantID: APPLEPAY_MERCHANT_ID)
> >             .enable(logs: true)
> >             .on(authentication: { auth in
> >                 debugPrint("onAuthentication: \(String(data: auth.token.paymentData, encoding: .utf8)!)")
> >             }).on(transactionFailure: { res in
> >                 debugPrint(res)
> >             }).on(transactionSuccess: { res in
> >                 debugPrint(res ?? "onSuccess \(res)")
> >             }).initialize(
> >                 target: self,
> >                 onError: { errors in
> >                     debugPrint("onError: \(errors)")
> >                 },
> >                 onPresent: {
> >                     debugPrint("onPresent: (-:")
> >                 }
> >            )
> > ```
> >
> > Make sure Apple Pay merchant id is selected
> > <img width="740" alt="Screenshot 2025-01-22 at 1 12 21 PM" src="https://github.com/user-attachments/assets/500b9b1b-2fa6-4da2-9db5-7a1a7baf13ff" />
> >Refer:https://developer.apple.com/documentation/xcode/configuring-apple-pay-support
>
> >  **Pay With Card details**
> > ```swift
> >     let card = EdfaPgCard(
> >            number: "5123445000000008",
> >            expireMonth: Int(01),
> >             expireYear: Int(2039),
> >             cvv: "100"
> >        )
> >   
> > 
> >        EdfaPayWithCardDetails(viewController: self)
> >              .set(order: order)
> >              .set(payer: payer)
> >              .set(card: card)
> >              .onTransactionSuccess { response, result in
> >                  print("Transaction Success: \(result)")
> >              }
> >              .onTransactionFailure { response, error in
> >                  print("Transaction Failed: \(error)")
> >              }
> >              .initialize(onError:  { err in
> >                  debugPrint(err)
> >             })
> > ```
>
## Getting help

To report a specific issue or feature request, open a [new issue](https://github.com/edfapay/edfa-pg-ios-sdk-pod/issues/new).

Or write a direct letter to the [support@edfapay.com](mailto:support@edfapay.com).

## License

MIT License. See the [LICENSE](https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/LICENSE) file for more details.

## Contacts

Website: https://edfapay.com  
Phone: [+966920033633](tel:+966920033633)  
Email: [support@edfapay.com](mailto:support@edfapay.com)  
Address: EdfaPg, Olaya Street, Riyadh, Saudi Arabia

© 2023 - 2024 EdfaPg. All rights reserved.
