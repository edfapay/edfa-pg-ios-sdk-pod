# EdfaPg iOS SDK - Apple Pay Integration Documentation

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Apple Pay Configuration](#apple-pay-configuration)
- [Integration Steps](#integration-steps)
- [API Flow](#api-flow)
- [Request Structure](#request-structure)
- [Response Structure](#response-structure)
- [Code Examples](#code-examples)
- [Payment Token Details](#payment-token-details)
- [Error Handling](#error-handling)
- [Testing](#testing)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

The EdfaPg iOS SDK provides seamless Apple Pay integration for processing secure payments through the Apple Pay framework. The SDK handles:

- Apple Pay authorization flow
- Payment token generation and encryption
- Server-to-server (S2S) sale processing
- 3D Secure authentication (if required)
- Transaction completion and callbacks

**Key Features:**
- Native Apple Pay UI with minimal code
- Automatic device capability detection
- Support for all payment networks (Visa, Mastercard, Amex, etc.)
- Customizable payment summary items
- Shipping address collection (optional)
- Transaction status callbacks
- Debug logging for troubleshooting

---

## Prerequisites

### 1. Apple Developer Account Requirements

You must have:
- Active Apple Developer account
- Apple Pay merchant identifier
- Payment Processing Certificate
- Merchant Identity Certificate

### 2. Xcode Configuration

- Xcode 13.0 or later
- iOS 11.0+ deployment target
- Apple Pay capability enabled in project

### 3. EdfaPg Account Setup

- EdfaPg merchant account
- Client Key (Merchant Key)
- Client Password
- Payment URL
- Apple Pay enabled on your merchant account

---

## Apple Pay Configuration

### Step 1: Create Apple Pay Merchant ID

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Select **Identifiers** → **Merchant IDs**
4. Click **+** to create new Merchant ID
5. Choose **Merchant IDs** type
6. Enter Description: "EdfaPay Payment Gateway"
7. Enter Identifier: `merchant.com.yourcompany.applepay`
8. Click **Continue** and **Register**

### Step 2: Configure Xcode Project

#### Enable Apple Pay Capability

1. Open your Xcode project
2. Select your target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **Apple Pay**
6. Select your Merchant ID from the list

![Apple Pay Configuration](https://github.com/user-attachments/assets/500b9b1b-2fa6-4da2-9db5-7a1a7baf13ff)

#### Update Info.plist

No additional Info.plist entries are required for Apple Pay, but ensure you have:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

### Step 3: Import Required Frameworks

```swift
import PassKit
import EdfaPgSdk
```

---

## Integration Steps

### Step 1: Initialize EdfaPg SDK

Initialize the SDK in your `AppDelegate.swift`:

```swift
import UIKit
import EdfaPgSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize EdfaPg SDK
        let credentials = EdfaPgCredential(
            clientKey: "YOUR_MERCHANT_KEY",
            clientPass: "YOUR_MERCHANT_PASSWORD",
            paymentUrl: "https://pay.expresspay.sa/payment/post"
        )
        EdfaPgSdk.config(credentials)
        
        return true
    }
}
```

### Step 2: Prepare Order and Payer Data

```swift
// Create order
let order = EdfaPgSaleOrder(
    id: UUID().uuidString,
    description: "Apple Pay Order",
    currency: "SAR",  // Currency code
    amount: 100.00,   // Amount in specified currency
    country: "SA"     // Country code
)

// Create payer information
let payer = EdfaPgPayer(
    firstName: "John",
    lastName: "Doe",
    address: "123 Main Street",
    country: "SA",
    city: "Riyadh",
    zip: "12345",
    email: "john.doe@example.com",
    phone: "+966500000000",
    ip: "192.168.1.1"  // Customer's IP address
)
```

### Step 3: Initialize Apple Pay

```swift
EdfaApplePay()
    .set(order: order)
    .set(payer: payer)
    .set(applePayMerchantID: "merchant.com.yourcompany.applepay")
    .enable(logs: true)  // Enable debug logging
    .on(authentication: { payment in
        // Called when user authorizes payment
        print("Payment authorized")
        if let paymentData = String(data: payment.token.paymentData, encoding: .utf8) {
            print("Payment data: \(paymentData)")
        }
    })
    .on(transactionSuccess: { response in
        // Called when transaction completes successfully
        print("Transaction successful!")
        print("Response: \(response ?? [:])")
    })
    .on(transactionFailure: { response in
        // Called when transaction fails
        print("Transaction failed!")
        print("Error: \(response)")
    })
    .initialize(
        target: self,
        onError: { errors in
            // Called if Apple Pay cannot be initialized
            print("Initialization error: \(errors)")
        },
        onPresent: {
            // Called when Apple Pay sheet is presented
            print("Apple Pay sheet presented")
        }
    )
```

---

## API Flow

### Complete Apple Pay Transaction Flow

```
┌─────────────────┐
│   Your App      │
└────────┬────────┘
         │
         │ 1. Initialize EdfaApplePay
         ▼
┌─────────────────┐
│  EdfaApplePay   │
│     Class       │
└────────┬────────┘
         │
         │ 2. Check Apple Pay availability
         │    PKPaymentAuthorizationViewController.canMakePayments()
         ▼
┌─────────────────┐
│   Apple Pay     │
│   Framework     │
└────────┬────────┘
         │
         │ 3. Present Apple Pay sheet
         │    User authorizes payment
         ▼
┌─────────────────┐
│  PKPayment      │
│    Object       │
└────────┬────────┘
         │
         │ 4. Extract payment token
         │    PKPaymentToken
         ▼
┌─────────────────┐
│ EdfaPgVirtual   │
│  SaleAdapter    │
└────────┬────────┘
         │
         │ 5. Send S2S request
         │    POST /applepay/orders/s2s/sale
         ▼
┌─────────────────┐
│  EdfaPg Server  │
└────────┬────────┘
         │
         │ 6. Process payment
         │    Decrypt token, authorize
         ▼
┌─────────────────┐
│    Response     │
│  SUCCESS/FAIL   │
└────────┬────────┘
         │
         │ 7. Return to app
         ▼
┌─────────────────┐
│   Callbacks     │
│   Triggered     │
└─────────────────┘
```

### Detailed Step-by-Step Flow

1. **Initialization Phase**
   - App calls `EdfaApplePay().initialize()`
   - SDK validates configuration (order, payer, merchant ID)
   - SDK checks Apple Pay device capability
   - Creates `PKPaymentRequest` object

2. **Payment Authorization Phase**
   - SDK presents `PKPaymentAuthorizationViewController`
   - User authenticates with Face ID/Touch ID
   - User confirms payment amount and details
   - Apple Pay generates encrypted payment token

3. **Token Extraction Phase**
   - SDK receives `PKPayment` object
   - Extracts `PKPaymentToken` with encrypted data
   - Extracts payment method details (network, type)
   - Calls `onAuthentication` callback (optional)

4. **Server Communication Phase**
   - SDK constructs multipart request
   - Includes payment token as JSON string
   - Calculates security hash
   - Sends POST to `/applepay/orders/s2s/sale`

5. **Processing Phase**
   - EdfaPg server receives request
   - Decrypts Apple Pay token
   - Processes payment through card network
   - Returns transaction result

6. **Completion Phase**
   - SDK receives response
   - Calls `onTransactionSuccess` or `onTransactionFailure`
   - Dismisses Apple Pay sheet
   - Updates transaction status in UI

---

## Request Structure

### HTTP Request Details

**Endpoint**: `{baseUrl}/applepay/orders/s2s/sale`

Where `baseUrl` is derived from payment URL:
- Input: `https://pay.expresspay.sa/payment/post`
- Base: `https://pay.expresspay.sa`
- Endpoint: `https://pay.expresspay.sa/applepay/orders/s2s/sale`

**Method**: POST

**Content-Type**: `multipart/form-data; boundary=boundary-edfapay-pg-formdata`

**Headers**:
```
X-User-Agent: ios
Accept: application/json
Content-Type: multipart/form-data; boundary=boundary-edfapay-pg-formdata
```

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "SALE" |
| `client_key` | String | Yes | Your EdfaPg merchant key |
| `order_id` | String | Yes | Unique order identifier (UUID recommended) |
| `order_amount` | String | Yes | Amount in format "XXX.XX" |
| `order_currency` | String | Yes | ISO currency code (e.g., "SAR", "USD") |
| `order_description` | String | Yes | Description of the order |
| `payer_first_name` | String | Yes | Customer's first name |
| `payer_last_name` | String | Yes | Customer's last name |
| `payer_middle_name` | String | No | Customer's middle name |
| `payer_birth_date` | String | No | Birth date (YYYY-MM-DD) |
| `payer_address` | String | Yes | Billing address |
| `payer_address2` | String | No | Additional address line |
| `payer_country` | String | Yes | Country code (e.g., "SA") |
| `payer_state` | String | No | State/region |
| `payer_city` | String | Yes | City name |
| `payer_zip` | String | Yes | ZIP/postal code |
| `payer_email` | String | Yes | Email address |
| `payer_phone` | String | Yes | Phone number |
| `payer_ip` | String | Yes | Customer's IP address |
| `brand` | String | Yes | Always "applepay" |
| `identifier` | String | Yes | Apple Pay transaction identifier |
| `return_url` | String | Yes | Callback URL after processing |
| `parameters` | String | Yes | JSON string with payment token data |
| `hash` | String | Yes | Security hash for request validation |

### Hash Calculation

The hash is calculated using the following formula:

```
md5(
  strtoupper(
    strrev(identifier) + 
    client_password + 
    order_number + 
    order_amount + 
    order_currency
  )
)
```

**Swift Implementation**:
```swift
let hash = EdfaPgHashUtil.hashApplePayVirtual(
    identifier: applePayTransactionIdentifier,
    number: order.id,
    amount: order.formatedAmountString(),  // "100.00"
    currency: order.currency                // "SAR"
)
```

**Example Calculation**:
```swift
// Given:
let identifier = "ABC123XYZ"
let clientPassword = "MySecret123"
let orderNumber = "order-12345"
let amount = "100.00"
let currency = "SAR"

// Step 1: Reverse identifier
let idRev = "ZYXABC321"

// Step 2: Concatenate
let str = "ZYXABC321MySecret123order-12345100.00SAR"

// Step 3: Uppercase
let upper = "ZYXABC321MYSECRET123ORDER-12345100.00SAR"

// Step 4: MD5 hash
let hash = md5(upper)  // "a1b2c3d4e5f6..."
```

### Payment Token (parameters field)

The `parameters` field contains a JSON string with the Apple Pay token:

```json
{
  "paymentData": {
    "version": "EC_v1",
    "data": "base64-encoded-encrypted-payment-data",
    "signature": "base64-encoded-signature",
    "header": {
      "ephemeralPublicKey": "base64-encoded-public-key",
      "publicKeyHash": "base64-encoded-hash",
      "transactionId": "unique-transaction-identifier"
    }
  },
  "paymentMethod": {
    "displayName": "Visa 1234",
    "network": "Visa",
    "type": "debit"
  },
  "transactionIdentifier": "unique-apple-pay-transaction-id"
}
```

### Sample Request

**Raw HTTP Request**:
```http
POST /applepay/orders/s2s/sale HTTP/1.1
Host: pay.expresspay.sa
X-User-Agent: ios
Accept: application/json
Content-Type: multipart/form-data; boundary=boundary-edfapay-pg-formdata

--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="action"

SALE
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="client_key"

58e9490c-000c-11ed-000-76632760000
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="order_id"

order-abc-123-xyz
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="order_amount"

100.00
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="order_currency"

SAR
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="order_description"

Apple Pay Payment
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_first_name"

John
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_last_name"

Doe
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_email"

john.doe@example.com
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_phone"

+966500000000
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_address"

123 Main Street
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_country"

SA
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_city"

Riyadh
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_zip"

12345
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="payer_ip"

192.168.1.1
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="brand"

applepay
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="identifier"

ABC123XYZ789
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="return_url"

https://yourapp.com/callback
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="parameters"

{"paymentData":{"version":"EC_v1","data":"..."},"paymentMethod":{"displayName":"Visa 1234","network":"Visa","type":"debit"},"transactionIdentifier":"ABC123XYZ789"}
--boundary-edfapay-pg-formdata
Content-Disposition: form-data; name="hash"

a1b2c3d4e5f6g7h8i9j0
--boundary-edfapay-pg-formdata--
```

---

## Response Structure

### Success Response

**HTTP Status**: 200 OK

**Response Object**: `EdfaPgSaleVirtualTransaction`

```json
{
  "action": "SALE",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-abc-123-xyz",
  "trans_id": "3f8c2a1e-9b7d-4c6e-a5f3-1234567890ab",
  "trans_date": "2024-01-15 14:30:45",
  "descriptor": "EdfaPay Merchant",
  "amount": "100.00",
  "currency": "SAR"
}
```

**Response Fields**:

| Field | Type | Description |
|-------|------|-------------|
| `action` | String | Always "SALE" |
| `result` | String | "SUCCESS" for successful transactions |
| `status` | String | Transaction status ("SETTLED", "PENDING", etc.) |
| `order_id` | String | Your original order identifier |
| `trans_id` | String | EdfaPg transaction ID (UUID) |
| `trans_date` | String | Transaction timestamp |
| `descriptor` | String | Merchant name shown on statement |
| `amount` | String | Transaction amount |
| `currency` | String | Currency code |

### Error Response

**HTTP Status**: 200 OK (errors are in response body)

```json
{
  "result": "ERROR",
  "error_code": 1001,
  "error_message": "Invalid payment token",
  "errors": {
    "payment_token": ["Payment token is invalid or expired"]
  }
}
```

### Decline Response

```json
{
  "action": "SALE",
  "result": "DECLINED",
  "status": "DECLINED",
  "order_id": "order-abc-123-xyz",
  "trans_id": "3f8c2a1e-9b7d-4c6e-a5f3-1234567890ab",
  "trans_date": "2024-01-15 14:30:45",
  "decline_reason": "Insufficient funds"
}
```

---

## Code Examples

### Basic Apple Pay Integration

```swift
import UIKit
import PassKit
import EdfaPgSdk

class CheckoutViewController: UIViewController {
    
    // Apple Pay merchant ID from Apple Developer Portal
    let applePayMerchantID = "merchant.com.yourcompany.applepay"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupApplePayButton()
    }
    
    func setupApplePayButton() {
        // Create Apple Pay button
        let applePayButton = PKPaymentButton(
            paymentButtonType: .buy,
            paymentButtonStyle: .black
        )
        applePayButton.addTarget(
            self,
            action: #selector(handleApplePayButtonTapped),
            for: .touchUpInside
        )
        
        // Add to view
        applePayButton.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 50)
        view.addSubview(applePayButton)
    }
    
    @objc func handleApplePayButtonTapped() {
        initiateApplePayment()
    }
    
    func initiateApplePayment() {
        // Prepare order
        let order = EdfaPgSaleOrder(
            id: UUID().uuidString,
            description: "Premium Subscription",
            currency: "SAR",
            amount: 99.99,
            country: "SA"
        )
        
        // Prepare payer info
        let payer = EdfaPgPayer(
            firstName: "John",
            lastName: "Doe",
            address: "123 Main Street",
            country: "SA",
            city: "Riyadh",
            zip: "12345",
            email: "john.doe@example.com",
            phone: "+966500000000",
            ip: getDeviceIP()
        )
        
        // Initialize Apple Pay
        EdfaApplePay()
            .set(order: order)
            .set(payer: payer)
            .set(applePayMerchantID: applePayMerchantID)
            .enable(logs: true)
            .on(authentication: { [weak self] payment in
                self?.handleAuthentication(payment)
            })
            .on(transactionSuccess: { [weak self] response in
                self?.handleTransactionSuccess(response)
            })
            .on(transactionFailure: { [weak self] response in
                self?.handleTransactionFailure(response)
            })
            .initialize(
                target: self,
                onError: { [weak self] errors in
                    self?.handleInitializationError(errors)
                },
                onPresent: {
                    print("Apple Pay sheet presented")
                }
            )
    }
    
    func handleAuthentication(_ payment: PKPayment) {
        print("✅ Payment authorized")
        print("Transaction ID: \(payment.token.transactionIdentifier)")
        print("Payment method: \(payment.token.paymentMethod.displayName ?? "Unknown")")
    }
    
    func handleTransactionSuccess(_ response: [String: Any]?) {
        guard let response = response else { return }
        
        print("✅ Transaction successful!")
        
        if let transactionId = response["trans_id"] as? String {
            print("Transaction ID: \(transactionId)")
        }
        
        if let amount = response["amount"] as? String,
           let currency = response["currency"] as? String {
            print("Amount: \(amount) \(currency)")
        }
        
        // Show success UI
        showSuccessAlert(message: "Payment successful!")
    }
    
    func handleTransactionFailure(_ response: [String: Any]) {
        print("❌ Transaction failed")
        
        let errorMessage = response["error"] as? String 
            ?? response["decline_reason"] as? String 
            ?? "Payment failed"
        
        print("Error: \(errorMessage)")
        
        // Show error UI
        showErrorAlert(message: errorMessage)
    }
    
    func handleInitializationError(_ errors: Any) {
        print("❌ Apple Pay initialization failed")
        print("Errors: \(errors)")
        
        if let errorArray = errors as? [String] {
            let message = errorArray.joined(separator: "\n")
            showErrorAlert(message: message)
        } else {
            showErrorAlert(message: "Unable to initialize Apple Pay")
        }
    }
    
    // Helper methods
    func getDeviceIP() -> String {
        // Implement IP detection
        // For production, fetch from your backend
        return "192.168.1.1"
    }
    
    func showSuccessAlert(message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### Advanced Configuration

#### Custom Payment Summary Items

```swift
EdfaApplePay()
    .set(order: order)
    .set(payer: payer)
    .set(applePayMerchantID: applePayMerchantID)
    // Add custom line items
    .addPurchaseItem(
        label: "Subtotal",
        amount: 89.99,
        type: .final
    )
    .addPurchaseItem(
        label: "Tax",
        amount: 10.00,
        type: .final
    )
    .addPurchaseItem(
        label: "Total",
        amount: 99.99,
        type: .final
    )
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

#### Specific Payment Networks

```swift
import PassKit

EdfaApplePay()
    .set(order: order)
    .set(payer: payer)
    .set(applePayMerchantID: applePayMerchantID)
    // Restrict to specific networks
    .addSupported(paymentNetworks: [
        .visa,
        .masterCard,
        .amex
    ])
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

#### Custom Merchant Capabilities

```swift
EdfaApplePay()
    .set(order: order)
    .set(payer: payer)
    .set(applePayMerchantID: applePayMerchantID)
    // Set merchant capabilities
    .set(merchantCapability: [.capability3DS, .capabilityEMV])
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

#### Collect Shipping Address

```swift
let shippingAddress = EdfaPgShippingAddress(
    name: "John Doe",
    address: "123 Main St, Riyadh, SA",
    email: "john.doe@example.com",
    phone: "+966500000000"
)

EdfaApplePay()
    .set(order: order)
    .set(payer: payer)
    .set(applePayMerchantID: applePayMerchantID)
    .set(shippingAddress: shippingAddress)
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

---

## Payment Token Details

### PKPayment Object Structure

When Apple Pay authorization succeeds, you receive a `PKPayment` object:

```swift
public class PKPayment {
    var token: PKPaymentToken          // Encrypted payment data
    var billingContact: PKContact?     // Billing address
    var shippingContact: PKContact?    // Shipping address
    var shippingMethod: PKShippingMethod?
}
```

### PKPaymentToken Structure

```swift
public class PKPaymentToken {
    var paymentMethod: PKPaymentMethod  // Card details
    var paymentData: Data               // Encrypted payment data
    var transactionIdentifier: String   // Unique transaction ID
}
```

### PKPaymentMethod Structure

```swift
public class PKPaymentMethod {
    var displayName: String?     // e.g., "Visa 1234"
    var network: PKPaymentNetwork?  // e.g., .visa
    var type: PKPaymentMethodType   // .debit, .credit, .prepaid
}
```

### Encrypted Payment Data

The `paymentData` field contains encrypted card information in PKPayment token format:

```json
{
  "version": "EC_v1",
  "data": "encrypted-payment-data-base64",
  "signature": "signature-base64",
  "header": {
    "ephemeralPublicKey": "ephemeral-key-base64",
    "publicKeyHash": "key-hash-base64",
    "transactionId": "transaction-identifier"
  }
}
```

**Important**: This data is encrypted by Apple and can only be decrypted by EdfaPg servers using the merchant's payment processing certificate.

### Payment Token Extraction

The SDK automatically extracts and formats the payment token:

```swift
// Inside EdfaApplePay implementation
let token = payment.token
let method = payment.token.paymentMethod

if let paymentDataJSON = try? JSONSerialization.jsonObject(
    with: token.paymentData
) as? [String: Any] {
    let paymentJSON: [String: Any] = [
        "paymentData": paymentDataJSON,
        "paymentMethod": [
            "displayName": method.displayName ?? "",
            "network": method.network?.rawValue ?? "",
            "type": method.type.name()
        ],
        "transactionIdentifier": token.transactionIdentifier
    ]
    
    // Convert to JSON string
    let paymentToken = try? JSONSerialization.data(withJSONObject: paymentJSON)
    let paymentTokenString = String(data: paymentToken!, encoding: .utf8)
}
```

---

## Error Handling

### Common Error Scenarios

#### 1. Apple Pay Not Supported

**Error**: Device doesn't support Apple Pay

```swift
.initialize(
    target: self,
    onError: { errors in
        // errors contains: 
        // ["Cannot start apple pay, device may not supported or user/merchant is restricted from authorizing payments"]
    },
    onPresent: nil
)
```

**Solution**:
- Check device capability before showing Apple Pay button
- Provide alternative payment methods

```swift
func isApplePayAvailable() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments()
}

// Check specific networks
func canUseApplePayWithCards() -> Bool {
    return PKPaymentAuthorizationViewController.canMakePayments(
        usingNetworks: [.visa, .masterCard]
    )
}
```

#### 2. No Cards Configured

**Error**: User hasn't added cards to Apple Wallet

```swift
if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) {
    // Show "Set up Apple Pay" button
    showSetupApplePayButton()
}
```

#### 3. Invalid Merchant ID

**Error**: Merchant ID not configured correctly

```swift
.initialize(
    target: self,
    onError: { errors in
        // errors contains:
        // ["Missing or invalid apple pay 'merchant identifier'"]
    },
    onPresent: nil
)
```

**Solution**:
- Verify merchant ID in Apple Developer Portal
- Ensure merchant ID is added to Xcode capabilities
- Check merchant ID matches exactly

#### 4. Invalid Amount

**Error**: Amount less than minimum (0.10)

```swift
.initialize(
    target: self,
    onError: { errors in
        // errors contains:
        // ["Missing or invalid amount should be greater than 0.09"]
    },
    onPresent: nil
)
```

**Solution**:
```swift
// Validate amount before initialization
guard order.amount >= 0.10 else {
    print("Amount must be at least 0.10")
    return
}
```

#### 5. Missing Required Callbacks

**Error**: Transaction callbacks not set

```swift
.initialize(
    target: self,
    onError: { errors in
        // errors contains:
        // ["onTransactionSuccess not set, try to call function 'EdfaApplePay.on(transactionSuccess:)'"]
    },
    onPresent: nil
)
```

**Solution**:
```swift
// Always set both success and failure callbacks
EdfaApplePay()
    .on(transactionSuccess: { response in
        // Handle success
    })
    .on(transactionFailure: { response in
        // Handle failure
    })
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

#### 6. User Cancellation

**Scenario**: User cancels Apple Pay sheet

```swift
// Apple Pay sheet is automatically dismissed
// No callback is triggered
// Simply return user to previous screen
```

#### 7. Network/Server Errors

**Error**: Request to EdfaPg server fails

```swift
.on(transactionFailure: { response in
    if let error = response["error"] as? String {
        if error.contains("Error while performing purchase") {
            // Network error or server unavailable
            print("Please check your connection and try again")
        }
    }
})
```

### Validation Before Initialization

```swift
func validateApplePayConfiguration() -> (valid: Bool, errors: [String]) {
    var errors: [String] = []
    
    // Check device support
    if !PKPaymentAuthorizationViewController.canMakePayments() {
        errors.append("Apple Pay is not available on this device")
    }
    
    // Check amount
    if order.amount < 0.10 {
        errors.append("Amount must be at least 0.10")
    }
    
    // Check currency
    if order.currency.isEmpty {
        errors.append("Currency code is required")
    }
    
    // Check country
    if order.country.isEmpty {
        errors.append("Country code is required")
    }
    
    // Check merchant ID
    if applePayMerchantID.isEmpty {
        errors.append("Apple Pay Merchant ID is required")
    }
    
    return (errors.isEmpty, errors)
}

// Use before initialization
let validation = validateApplePayConfiguration()
if !validation.valid {
    showErrors(validation.errors)
    return
}

// Proceed with initialization
initiateApplePayment()
```

---

## Testing

### Test Environment Setup

1. **Use Sandbox Account**
   - Sign in with sandbox Apple ID in Settings → Wallet & Apple Pay
   - Add test cards provided by Apple

2. **Test Cards**
   - Visa: 4761 1200 1000 0492
   - Mastercard: 5204 2477 5000 1471
   - Amex: 3782 822463 10005

3. **Simulator Testing**
   - Open Simulator
   - Go to Features → Wallet → Add Card
   - Enter test card details

### Test Scenarios

#### Successful Payment
```swift
// Expected flow:
// 1. Apple Pay sheet appears
// 2. User authenticates
// 3. onAuthentication callback triggered
// 4. Server processes payment
// 5. onTransactionSuccess callback triggered
// 6. Apple Pay sheet dismisses
```

#### Declined Payment
```swift
// Test with declined test card
// Expected: onTransactionFailure with decline_reason
```

#### User Cancellation
```swift
// User taps Cancel on Apple Pay sheet
// Expected: Sheet dismisses, no callbacks
```

#### Network Failure
```swift
// Disable network connection
// Expected: onTransactionFailure with network error
```

### Debug Logging

Enable detailed logging:

```swift
EdfaApplePay()
    .enable(logs: true)  // Enables debug output
    .initialize(target: self, onError: { _ in }, onPresent: nil)
```

Debug output includes:
- Request URL and parameters
- Payment token data
- Server response
- Error messages

Example output:
```
-------------------------------------------------------------
POST
REQUEST:
  URL: 
    https://pay.expresspay.sa/applepay/orders/s2s/sale
  HEADERS: 
    {
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
      "X-User-Agent": "ios"
    }
  PARAMETERS:
    action: SALE
    client_key: merchant-key
    order_id: order-123
    ...
RESPONSE:
  {
    "result": "SUCCESS",
    "status": "SETTLED",
    ...
  }
-------------------------------------------------------------
```

---

## Best Practices

### 1. Device Capability Check

Always check if Apple Pay is available before showing the button:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    if PKPaymentAuthorizationViewController.canMakePayments() {
        setupApplePayButton()
    } else {
        showAlternativePaymentMethods()
    }
}
```

### 2. User Experience

- Show Apple Pay button only when available
- Use standard PKPaymentButton for consistency
- Handle all callback scenarios gracefully
- Provide clear error messages

```swift
// Use standard Apple Pay button
let button = PKPaymentButton(
    paymentButtonType: .buy,    // or .donate, .checkout
    paymentButtonStyle: .black   // or .white, .whiteOutline
)
```

### 3. Security

- Never log payment tokens in production
- Use HTTPS for all API calls
- Validate amounts on server side
- Implement proper error handling

```swift
#if DEBUG
    .enable(logs: true)
#else
    .enable(logs: false)
#endif
```

### 4. Amount Formatting

Always format amounts correctly:

```swift
// Use order.formatedAmountString() for consistency
let amount = order.formatedAmountString()  // "100.00"
```

### 5. Callback Retention

Avoid retain cycles in callbacks:

```swift
EdfaApplePay()
    .on(transactionSuccess: { [weak self] response in
        self?.handleSuccess(response)
    })
    .on(transactionFailure: { [weak self] response in
        self?.handleFailure(response)
    })
```

### 6. Error Communication

Provide user-friendly error messages:

```swift
func getUserFriendlyError(_ error: String) -> String {
    switch error {
    case let e where e.contains("Invalid payment token"):
        return "Payment authorization failed. Please try again."
    case let e where e.contains("Insufficient funds"):
        return "Insufficient funds. Please use another card."
    case let e where e.contains("network"):
        return "Network error. Please check your connection."
    default:
        return "Payment failed. Please try again or use another payment method."
    }
}
```

### 7. Transaction Tracking

Store transaction IDs for reference:

```swift
func handleTransactionSuccess(_ response: [String: Any]?) {
    guard let transactionId = response?["trans_id"] as? String else { return }
    
    // Store for later reference
    UserDefaults.standard.set(transactionId, forKey: "lastTransactionId")
    
    // Or save to your backend
    saveTransactionToBackend(transactionId)
}
```

### 8. Timeout Handling

Implement timeout for long-running requests:

```swift
// Set a timeout for the payment process
DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) { [weak self] in
    if !self.paymentCompleted {
        self?.handleTimeout()
    }
}
```

---

## Troubleshooting

### Issue: Apple Pay Button Not Appearing

**Possible Causes**:
1. Device doesn't support Apple Pay
2. No cards in Wallet
3. Merchant ID not configured

**Solutions**:
```swift
// Check support
print("Can make payments: \(PKPaymentAuthorizationViewController.canMakePayments())")

// Check with networks
let networks: [PKPaymentNetwork] = [.visa, .masterCard]
print("Can make payments with cards: \(PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: networks))")

// Verify merchant ID in capabilities tab
```

### Issue: Payment Authorization Fails Immediately

**Possible Causes**:
1. Invalid merchant ID
2. Missing certificates
3. Merchant ID not approved by Apple

**Solutions**:
1. Verify merchant ID in Apple Developer Portal
2. Check payment processing certificate
3. Wait for Apple approval (can take 24-48 hours)

### Issue: Transaction Always Fails

**Possible Causes**:
1. Invalid credentials
2. Incorrect hash calculation
3. Server configuration

**Solutions**:
```swift
// Enable debug logging
.enable(logs: true)

// Check credentials
print("Client Key: \(EdfaPgSdk.shared.credentials.clientKey)")
print("Payment URL: \(EdfaPgSdk.shared.credentials.paymentUrl)")

// Verify hash
let hash = EdfaPgHashUtil.hashApplePayVirtual(...)
print("Calculated Hash: \(hash)")
```

### Issue: "Cannot start apple pay" Error

**Possible Causes**:
1. Device restrictions
2. Region restrictions
3. Parental controls

**Solutions**:
- Test on different device
- Check Settings → Wallet & Apple Pay
- Verify region settings

### Issue: Payment Token Invalid

**Possible Causes**:
1. Token expired
2. Malformed token data
3. Certificate mismatch

**Solutions**:
- Process payment immediately after authorization
- Check token structure in logs
- Verify certificate configuration with EdfaPg support

### Getting Help

If issues persist:

1. **Enable Debug Logging**:
   ```swift
   .enable(logs: true)
   ```

2. **Collect Information**:
   - iOS version
   - Device model
   - Error messages
   - Request/response logs

3. **Contact Support**:
   - Email: support@edfapay.com
   - Phone: +966920033633
   - Include transaction ID and timestamp

---

## Additional Resources

### Apple Documentation
- [Apple Pay Programming Guide](https://developer.apple.com/documentation/passkit/apple_pay)
- [PKPaymentAuthorizationViewController](https://developer.apple.com/documentation/passkit/pkpaymentauthorizationviewcontroller)
- [Apple Pay Sandbox Testing](https://developer.apple.com/apple-pay/sandbox-testing/)

### EdfaPg Resources
- Website: [https://edfapay.com](https://edfapay.com)
- Support Email: [support@edfapay.com](mailto:support@edfapay.com)
- Phone: [+966920033633](tel:+966920033633)

### Related Documentation
- [HTTP_API_DOCUMENTATION.md](./HTTP_API_DOCUMENTATION.md) - Complete API reference
- [README.md](./README.md) - SDK overview and basic usage

---

## Summary Checklist

Before going live with Apple Pay:

- [ ] Apple Pay Merchant ID created
- [ ] Payment Processing Certificate configured
- [ ] Merchant ID added to Xcode capabilities
- [ ] SDK initialized with correct credentials
- [ ] Apple Pay tested in sandbox
- [ ] Success callback implemented
- [ ] Failure callback implemented
- [ ] Error handling implemented
- [ ] User-friendly messages configured
- [ ] Transaction logging added
- [ ] Production certificates installed
- [ ] Live testing completed
- [ ] Support contact information added

---

*Last Updated: January 2025*
*SDK Version: Compatible with EdfaPgSdk v1.x*
*Apple Pay Version: iOS 11.0+*
