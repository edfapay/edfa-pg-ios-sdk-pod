# EdfaPg iOS SDK - HTTP API Documentation

## Table of Contents
- [Overview](#overview)
- [Authentication](#authentication)
- [Base Configuration](#base-configuration)
- [API Endpoints](#api-endpoints)
  - [SALE Transaction](#1-sale-transaction)
  - [CAPTURE Transaction](#2-capture-transaction)
  - [CREDITVOID Transaction](#3-creditvoid-transaction)
  - [RECURRING_SALE Transaction](#4-recurring_sale-transaction)
  - [GET_TRANS_STATUS](#5-get_trans_status)
  - [GET_TRANS_DETAILS](#6-get_trans_details)
  - [Apple Pay Virtual Sale](#7-apple-pay-virtual-sale)
- [Response Structures](#response-structures)
- [Error Handling](#error-handling)
- [Hash Calculation](#hash-calculation)

---

## Overview

The EdfaPg iOS SDK communicates with the EdfaPg Payment Platform through HTTP POST requests. All requests use one of two content types:
- `application/x-www-form-urlencoded` - For standard payment operations
- `multipart/form-data` - For Apple Pay virtual transactions

All requests include custom headers:
- `X-User-Agent: ios`
- `Accept: application/json`

---

## Authentication

All API requests require authentication using:
1. **Client Key** (`client_key`) - Your merchant identifier
2. **Client Password** - Used for hash generation (not sent directly)
3. **Hash** - A cryptographic signature to validate requests

### SDK Initialization

```swift
let edfaPgCredential = EdfaPgCredential(
    clientKey: "YOUR_MERCHANT_KEY",
    clientPass: "YOUR_MERCHANT_PASSWORD",
    paymentUrl: "PAYMENT_URL"
)
EdfaPgSdk.config(edfaPgCredential)
```

---

## Base Configuration

**Base URL**: Configured via `paymentUrl` in credentials (e.g., `https://pay.expresspay.sa/payment/post`)

**HTTP Method**: POST for all endpoints

**Request Format**: URL-encoded form data or multipart form data

**Response Format**: JSON

---

## API Endpoints

### 1. SALE Transaction

**Purpose**: Authorize and capture payment in a single transaction (Single Message System - SMS). Can also be used for AUTH-only transactions.

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgSaleAdapter`

**Service Class**: `EdfaPgSaleService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "SALE" |
| `client_key` | String | Yes | Merchant identifier |
| `channel_id` | String | No | Sub-account identifier for specific channel |
| `order_id` | String | Yes | Unique order identifier |
| `order_amount` | String | Yes | Transaction amount (format: XXXX.XX) |
| `order_currency` | String | Yes | Currency code (e.g., "SAR", "USD") |
| `order_description` | String | Yes | Order description |
| `card_number` | String | Yes | Credit card number |
| `card_exp_month` | String | Yes | Card expiration month (format: MM) |
| `card_exp_year` | String | Yes | Card expiration year (format: YYYY) |
| `card_cvv2` | String | Yes | Card CVV/CVV2 code |
| `payer_first_name` | String | Yes | Payer's first name |
| `payer_last_name` | String | Yes | Payer's last name |
| `payer_middle_name` | String | No | Payer's middle name |
| `payer_birth_date` | String | No | Payer's birth date (format: YYYY-MM-DD) |
| `payer_address` | String | Yes | Payer's address |
| `payer_address2` | String | No | Additional address line |
| `payer_country` | String | Yes | Payer's country code (2 letters, e.g., "SA") |
| `payer_state` | String | No | Payer's state/region |
| `payer_city` | String | Yes | Payer's city |
| `payer_zip` | String | Yes | Payer's ZIP/postal code |
| `payer_email` | String | Yes | Payer's email (max 256 chars) |
| `payer_phone` | String | Yes | Payer's phone number |
| `payer_ip` | String | Yes | Payer's IP address |
| `term_url_3ds` | String | Yes | Return URL after 3D Secure (max 1024 chars) |
| `recurring_init` | String | No | "Y" to initialize recurring payments |
| `auth` | String | No | "Y" for AUTH-only (hold funds), omit for SALE (capture) |
| `hash` | String | Yes | Security hash (see Hash Calculation) |
| `req_token` | String | Yes | Always "N" |

#### Hash Calculation for SALE

```swift
let hash = EdfaPgHashUtil.hash(
    email: payer.email,
    cardNumber: card.number
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=SALE" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "order_id=order-12345" \
  -d "order_amount=100.00" \
  -d "order_currency=SAR" \
  -d "order_description=Test Order" \
  -d "card_number=5123445000000008" \
  -d "card_exp_month=01" \
  -d "card_exp_year=2039" \
  -d "card_cvv2=100" \
  -d "payer_first_name=John" \
  -d "payer_last_name=Doe" \
  -d "payer_address=123 Main St" \
  -d "payer_country=SA" \
  -d "payer_city=Riyadh" \
  -d "payer_zip=12345" \
  -d "payer_email=john.doe@example.com" \
  -d "payer_phone=+966500000000" \
  -d "payer_ip=192.168.1.1" \
  -d "term_url_3ds=https://yourapp.com/3ds-callback" \
  -d "hash=CALCULATED_HASH" \
  -d "req_token=N"
```

#### Response Structure

**Success Response** (`EdfaPgSaleSuccess`):
```json
{
  "action": "SALE",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:30:45",
  "descriptor": "Merchant Name",
  "amount": "100.00",
  "currency": "SAR"
}
```

**Decline Response** (`EdfaPgSaleDecline`):
```json
{
  "action": "SALE",
  "result": "DECLINED",
  "status": "DECLINED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:30:45",
  "decline_reason": "Insufficient funds"
}
```

**3D Secure Response** (`EdfaPgSale3ds`):
```json
{
  "action": "SALE",
  "result": "3DS",
  "status": "3DS",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "redirect_url": "https://3ds-server.com/authenticate",
  "redirect_params": {
    "PaReq": "encoded-pareq",
    "MD": "merchant-data",
    "TermUrl": "https://yourapp.com/3ds-callback"
  },
  "redirect_method": "POST"
}
```

**Recurring Response** (`EdfaPgSaleRecurring`):
```json
{
  "action": "SALE",
  "result": "SUCCESS",
  "status": "SETTLED",
  "recurring_token": "recurring-token-string",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id"
}
```

#### iOS Usage Example

```swift
let saleAdapter = EdfaPgSaleAdapter()

let order = EdfaPgSaleOrder(
    id: UUID().uuidString,
    description: "Test Order",
    currency: "SAR",
    amount: 100.00
)

let card = EdfaPgCard(
    number: "5123445000000008",
    expireMonth: 01,
    expireYear: 2039,
    cvv: "100"
)

let payer = EdfaPgPayer(
    firstName: "John",
    lastName: "Doe",
    address: "123 Main St",
    country: "SA",
    city: "Riyadh",
    zip: "12345",
    email: "john.doe@example.com",
    phone: "+966500000000",
    ip: "192.168.1.1"
)

saleAdapter.execute(
    order: order,
    card: card,
    payer: payer,
    termUrl3ds: "https://yourapp.com/3ds-callback",
    auth: false
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Payment successful: \(success.transactionId)")
        case .decline(let decline):
            print("Payment declined: \(decline.declineReason)")
        case .secure3d(let secure3d):
            // Redirect to 3DS authentication
            print("3DS required: \(secure3d.redirectUrl)")
        case .recurring(let recurring):
            print("Recurring initialized: \(recurring.recurringToken)")
        case .redirect(let redirect):
            print("Redirect required: \(redirect.redirectUrl)")
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 2. CAPTURE Transaction

**Purpose**: Capture funds from a previously authorized transaction (created with `auth=Y`).

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgCaptureAdapter`

**Service Class**: `EdfaPgCaptureService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "CAPTURE" |
| `client_key` | String | Yes | Merchant identifier |
| `trans_id` | String | Yes | Original transaction ID (UUID format) |
| `amount` | String | No | Amount to capture (partial capture). Format: XXXX.XX. Omit for full capture |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for CAPTURE

```swift
let hash = EdfaPgHashUtil.hash(
    email: payerEmail,
    cardNumber: cardNumber,
    transactionId: transactionId
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.trans_id.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=CAPTURE" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "trans_id=uuid-transaction-id" \
  -d "amount=50.00" \
  -d "hash=CALCULATED_HASH"
```

#### Response Structure

**Success Response** (`EdfaPgCaptureSuccess`):
```json
{
  "action": "CAPTURE",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:35:00",
  "amount": "50.00",
  "currency": "SAR"
}
```

#### iOS Usage Example

```swift
let captureAdapter = EdfaPgCaptureAdapter()

captureAdapter.execute(
    transactionId: "uuid-transaction-id",
    payerEmail: "john.doe@example.com",
    cardNumber: "5123445000000008",
    amount: 50.00 // Optional for partial capture
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Capture successful: \(success.transactionId)")
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 3. CREDITVOID Transaction

**Purpose**: Complete REFUND or REVERSAL transactions.
- **REVERSAL**: Cancel hold on authorized funds (AUTH transactions)
- **REFUND**: Return funds to card (SALE/CAPTURE transactions)

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgCreditvoidAdapter`

**Service Class**: `EdfaPgCreditvoidService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "CREDITVOID" |
| `client_key` | String | Yes | Merchant identifier |
| `trans_id` | String | Yes | Original transaction ID (UUID format) |
| `amount` | String | No | Amount to refund. Format: XXXX.XX. Omit for full refund |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for CREDITVOID

```swift
let hash = EdfaPgHashUtil.hash(
    email: payerEmail,
    cardNumber: cardNumber,
    transactionId: transactionId
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.trans_id.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=CREDITVOID" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "trans_id=uuid-transaction-id" \
  -d "amount=100.00" \
  -d "hash=CALCULATED_HASH"
```

#### Response Structure

**Success Response** (`EdfaPgCreditvoidSuccess`):
```json
{
  "action": "CREDITVOID",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-new-transaction-id",
  "trans_date": "2024-01-15 10:40:00",
  "amount": "100.00",
  "currency": "SAR"
}
```

#### iOS Usage Example

```swift
let creditvoidAdapter = EdfaPgCreditvoidAdapter()

creditvoidAdapter.execute(
    transactionId: "uuid-transaction-id",
    payerEmail: "john.doe@example.com",
    cardNumber: "5123445000000008",
    amount: 100.00 // Optional for partial refund
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Creditvoid successful: \(success.transactionId)")
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 4. RECURRING_SALE Transaction

**Purpose**: Create new transactions based on stored cardholder information from previous operations. Uses data from a primary transaction to create secondary transactions.

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgRecurringSaleAdapter`

**Service Class**: `EdfaPgRecurringSaleService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "RECURRING_SALE" |
| `client_key` | String | Yes | Merchant identifier |
| `order_id` | String | Yes | Unique order identifier for new transaction |
| `order_amount` | String | Yes | Transaction amount (format: XXXX.XX) |
| `order_description` | String | Yes | Order description |
| `recurring_first_trans_id` | String | Yes | Primary transaction ID |
| `recurring_token` | String | Yes | Recurring token from initial transaction |
| `auth` | String | No | "Y" for AUTH-only, omit for SALE |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for RECURRING_SALE

```swift
let hash = EdfaPgHashUtil.hash(
    email: payerEmail,
    cardNumber: cardNumber
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=RECURRING_SALE" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "order_id=recurring-order-456" \
  -d "order_amount=75.00" \
  -d "order_description=Recurring Payment" \
  -d "recurring_first_trans_id=uuid-original-trans-id" \
  -d "recurring_token=token-string" \
  -d "hash=CALCULATED_HASH"
```

#### Response Structure

Same as SALE transaction responses (`EdfaPgSaleResult`).

#### iOS Usage Example

```swift
let recurringSaleAdapter = EdfaPgRecurringSaleAdapter()

let order = EdfaPgOrder(
    id: "recurring-order-456",
    amount: 75.00,
    description: "Recurring Payment"
)

let options = EdfaPgRecurringOptions(
    firstTransactionId: "uuid-original-trans-id",
    token: "token-string"
)

recurringSaleAdapter.execute(
    order: order,
    options: options,
    payerEmail: "john.doe@example.com",
    cardNumber: "5123445000000008",
    auth: false
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Recurring payment successful: \(success.transactionId)")
        case .decline(let decline):
            print("Recurring payment declined: \(decline.declineReason)")
        case .secure3d(let secure3d):
            print("3DS required: \(secure3d.redirectUrl)")
        case .recurring, .redirect:
            break
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 5. GET_TRANS_STATUS

**Purpose**: Retrieve the current status of a transaction from the Payment Platform.

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgGetTransactionStatusAdapter`

**Service Class**: `EdfaPgGetTransactionStatusService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "GET_TRANS_STATUS" |
| `client_key` | String | Yes | Merchant identifier |
| `trans_id` | String | Yes | Transaction ID to query (UUID format) |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for GET_TRANS_STATUS

```swift
let hash = EdfaPgHashUtil.hash(
    email: payerEmail,
    cardNumber: cardNumber,
    transactionId: transactionId
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.trans_id.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=GET_TRANS_STATUS" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "trans_id=uuid-transaction-id" \
  -d "hash=CALCULATED_HASH"
```

#### Response Structure

**Success Response** (`EdfaPgGetTransactionStatusSuccess`):
```json
{
  "action": "GET_TRANS_STATUS",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:30:45",
  "amount": "100.00",
  "currency": "SAR"
}
```

**Possible Status Values**:
- `PENDING` - Transaction is being processed
- `SETTLED` - Transaction completed successfully
- `DECLINED` - Transaction was declined
- `REFUNDED` - Transaction was refunded
- `REVERSED` - Transaction was reversed
- `3DS` - Awaiting 3D Secure authentication

#### iOS Usage Example

```swift
let statusAdapter = EdfaPgGetTransactionStatusAdapter()

statusAdapter.execute(
    transactionId: "uuid-transaction-id",
    payerEmail: "john.doe@example.com",
    cardNumber: "5123445000000008"
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Transaction status: \(success.status)")
            print("Transaction ID: \(success.transactionId)")
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 6. GET_TRANS_DETAILS

**Purpose**: Retrieve complete transaction history and details for a specific order.

**Endpoint**: `{paymentUrl}` (Base URL from configuration)

**Content-Type**: `application/x-www-form-urlencoded`

**Adapter Class**: `EdfaPgGetTransactionDetailsAdapter`

**Service Class**: `EdfaPgGetTransactionDetailsService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "GET_TRANS_DETAILS" |
| `client_key` | String | Yes | Merchant identifier |
| `trans_id` | String | Yes | Transaction ID to query (UUID format) |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for GET_TRANS_DETAILS

```swift
let hash = EdfaPgHashUtil.hash(
    email: payerEmail,
    cardNumber: cardNumber,
    transactionId: transactionId
)
```

**Formula**: `md5(strtoupper(strrev(email).client_password.trans_id.strrev(substr(card_number, 0, 6).substr(card_number, -4))))`

#### Sample Request (cURL)

```bash
curl -X POST https://pay.expresspay.sa/payment/post \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -d "action=GET_TRANS_DETAILS" \
  -d "client_key=YOUR_MERCHANT_KEY" \
  -d "trans_id=uuid-transaction-id" \
  -d "hash=CALCULATED_HASH"
```

#### Response Structure

**Success Response** (`EdfaPgGetTransactionDetailsSuccess`):
```json
{
  "action": "GET_TRANS_DETAILS",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:30:45",
  "amount": "100.00",
  "currency": "SAR",
  "transactions": [
    {
      "trans_id": "uuid-transaction-id",
      "type": "SALE",
      "status": "SETTLED",
      "amount": "100.00",
      "currency": "SAR",
      "date": "2024-01-15 10:30:45"
    },
    {
      "trans_id": "uuid-refund-id",
      "type": "REFUND",
      "status": "SETTLED",
      "amount": "50.00",
      "currency": "SAR",
      "date": "2024-01-15 11:00:00"
    }
  ]
}
```

#### iOS Usage Example

```swift
let detailsAdapter = EdfaPgGetTransactionDetailsAdapter()

detailsAdapter.execute(
    transactionId: "uuid-transaction-id",
    payerEmail: "john.doe@example.com",
    cardNumber: "5123445000000008"
) { response in
    switch response {
    case .result(let result):
        switch result {
        case .success(let success):
            print("Order ID: \(success.orderId)")
            print("Transaction count: \(success.transactions?.count ?? 0)")
            success.transactions?.forEach { transaction in
                print("- \(transaction.type): \(transaction.amount) \(transaction.currency)")
            }
        }
    case .error(let error):
        print("API Error: \(error)")
    case .failure(let error):
        print("Request Failed: \(error)")
    }
}
```

---

### 7. Apple Pay Virtual Sale

**Purpose**: Process Apple Pay payment using tokenized payment data from PassKit.

**Endpoint**: `{baseUrl}/applepay/orders/s2s/sale`

Note: The base URL is derived from the payment URL by removing "/payment/post"

Example: If `paymentUrl` = `https://pay.expresspay.sa/payment/post`
Then Apple Pay endpoint = `https://pay.expresspay.sa/applepay/orders/s2s/sale`

**Content-Type**: `multipart/form-data; boundary=boundary-edfapay-pg-formdata`

**Adapter Class**: `EdfaPgVirtualSaleAdapter`

**Service Class**: `EdfaPgVirtualSaleService`

#### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `action` | String | Yes | Always "SALE" |
| `client_key` | String | Yes | Merchant identifier |
| `order_id` | String | Yes | Unique order identifier |
| `order_amount` | String | Yes | Transaction amount (format: XXXX.XX) |
| `order_currency` | String | Yes | Currency code (e.g., "SAR") |
| `order_description` | String | Yes | Order description |
| `payer_first_name` | String | Yes | Payer's first name |
| `payer_last_name` | String | Yes | Payer's last name |
| `payer_middle_name` | String | No | Payer's middle name |
| `payer_birth_date` | String | No | Payer's birth date |
| `payer_address` | String | Yes | Payer's address |
| `payer_address2` | String | No | Additional address line |
| `payer_country` | String | Yes | Payer's country code |
| `payer_state` | String | No | Payer's state/region |
| `payer_city` | String | Yes | Payer's city |
| `payer_zip` | String | Yes | Payer's ZIP/postal code |
| `payer_email` | String | Yes | Payer's email |
| `payer_phone` | String | Yes | Payer's phone number |
| `payer_ip` | String | Yes | Payer's IP address |
| `brand` | String | Yes | Always "applepay" |
| `identifier` | String | Yes | Apple Pay transaction identifier |
| `return_url` | String | Yes | Return URL after processing |
| `parameters` | String | Yes | JSON string containing Apple Pay payment token |
| `hash` | String | Yes | Security hash (see Hash Calculation) |

#### Hash Calculation for Apple Pay

```swift
let hash = EdfaPgHashUtil.hashApplePayVirtual(
    identifier: applePayTransactionIdentifier,
    number: order.id,
    amount: order.formatedAmountString(),
    currency: order.currency
)
```

**Formula**: `md5(strtoupper(strrev(identifier.number.amount.currency.client_password)))`

#### Payment Token Structure

The `parameters` field contains a JSON string with the following structure:

```json
{
  "paymentData": {
    "version": "EC_v1",
    "data": "encrypted-payment-data",
    "signature": "signature-string",
    "header": {
      "ephemeralPublicKey": "key-string",
      "publicKeyHash": "hash-string",
      "transactionId": "transaction-id"
    }
  },
  "paymentMethod": {
    "displayName": "Visa 1234",
    "network": "Visa",
    "type": "debit"
  },
  "transactionIdentifier": "unique-transaction-id"
}
```

#### Sample Request (cURL with multipart)

```bash
curl -X POST https://pay.expresspay.sa/applepay/orders/s2s/sale \
  -H "Content-Type: multipart/form-data; boundary=boundary-edfapay-pg-formdata" \
  -H "X-User-Agent: ios" \
  -H "Accept: application/json" \
  -F "action=SALE" \
  -F "client_key=YOUR_MERCHANT_KEY" \
  -F "order_id=order-12345" \
  -F "order_amount=100.00" \
  -F "order_currency=SAR" \
  -F "order_description=Apple Pay Order" \
  -F "payer_first_name=John" \
  -F "payer_last_name=Doe" \
  -F "payer_email=john.doe@example.com" \
  -F "payer_phone=+966500000000" \
  -F "payer_address=123 Main St" \
  -F "payer_country=SA" \
  -F "payer_city=Riyadh" \
  -F "payer_zip=12345" \
  -F "payer_ip=192.168.1.1" \
  -F "brand=applepay" \
  -F "identifier=apple-pay-transaction-id" \
  -F "return_url=https://yourapp.com/callback" \
  -F "parameters={\"paymentData\":{...},\"paymentMethod\":{...}}" \
  -F "hash=CALCULATED_HASH"
```

#### Response Structure

**Success Response** (`EdfaPgSaleVirtualTransaction`):
```json
{
  "action": "SALE",
  "result": "SUCCESS",
  "status": "SETTLED",
  "order_id": "order-12345",
  "trans_id": "uuid-transaction-id",
  "trans_date": "2024-01-15 10:30:45",
  "amount": "100.00",
  "currency": "SAR",
  "descriptor": "Merchant Name"
}
```

#### iOS Usage Example

See [APPLE_PAY_DOCUMENTATION.md](./APPLE_PAY_DOCUMENTATION.md) for complete Apple Pay integration guide.

---

## Response Structures

### Common Response Fields

All successful responses include:

| Field | Type | Description |
|-------|------|-------------|
| `action` | String | The action that was performed |
| `result` | String | "SUCCESS", "DECLINED", "ERROR", "3DS", "REDIRECT" |
| `status` | String | Current transaction status |
| `order_id` | String | Merchant's order identifier |
| `trans_id` | String | Platform transaction identifier (UUID) |
| `trans_date` | String | Transaction timestamp |
| `amount` | String | Transaction amount |
| `currency` | String | Currency code |

### Success Result (`result: "SUCCESS"`)

Additional fields:
- `descriptor` - Merchant descriptor on customer's statement
- `recurring_token` - Token for recurring payments (if applicable)

### Decline Result (`result: "DECLINED"`)

Additional fields:
- `decline_reason` - Human-readable decline reason

### 3D Secure Result (`result: "3DS"`)

Additional fields:
- `redirect_url` - URL for 3DS authentication
- `redirect_params` - Parameters to send to redirect URL
- `redirect_method` - HTTP method ("POST" or "GET")

### Redirect Result (`result: "REDIRECT"`)

Additional fields:
- `redirect_url` - URL to redirect the customer
- `redirect_params` - Parameters for the redirect
- `redirect_method` - HTTP method

---

## Error Handling

### Error Response Structure

When an error occurs, the API returns an `EdfaPgError` object:

```json
{
  "result": "ERROR",
  "error_code": 1001,
  "error_message": "Invalid card number",
  "errors": {
    "card_number": ["Card number is invalid"]
  }
}
```

### Common Error Codes

| Code | Description |
|------|-------------|
| 1001 | Invalid card number |
| 1002 | Card expired |
| 1003 | Invalid CVV |
| 1004 | Insufficient funds |
| 1005 | Invalid merchant credentials |
| 1006 | Invalid hash |
| 1007 | Duplicate order ID |
| 2001 | Transaction not found |
| 3001 | System error |

### Handling Errors in iOS

```swift
switch response {
case .result(let result):
    // Handle successful response
    break
    
case .error(let error):
    // API returned an error
    print("Error code: \(error.errorCode)")
    print("Error message: \(error.errorMessage)")
    if let errors = error.errors {
        for (field, messages) in errors {
            print("\(field): \(messages.joined(separator: ", "))")
        }
    }
    
case .failure(let error):
    // Network or decoding error
    print("Request failed: \(error.localizedDescription)")
}
```

---

## Hash Calculation

Hash generation is crucial for request security. The SDK provides utilities in `EdfaPgHashUtil`:

### Hash Formula Patterns

1. **For SALE and RECURRING_SALE**:
   ```
   md5(
     strtoupper(
       strrev(email) . 
       client_password . 
       strrev(substr(card_number, 0, 6) . substr(card_number, -4))
     )
   )
   ```

2. **For CAPTURE, CREDITVOID, GET_TRANS_STATUS, GET_TRANS_DETAILS**:
   ```
   md5(
     strtoupper(
       strrev(email) . 
       client_password . 
       trans_id . 
       strrev(substr(card_number, 0, 6) . substr(card_number, -4))
     )
   )
   ```

3. **For Apple Pay Virtual Sale**:
   ```
   md5(
     strtoupper(
       strrev(
         identifier . 
         number . 
         amount . 
         currency . 
         client_password
       )
     )
   )
   ```

### Hash Calculation Examples

**Example 1: SALE Hash**
```swift
// Given:
let email = "john.doe@example.com"
let clientPassword = "merchant-password-123"
let cardNumber = "5123445000000008"

// Step 1: Extract card parts
let cardFirst6 = "512344"
let cardLast4 = "0008"
let cardPart = cardFirst6 + cardLast4  // "5123440008"

// Step 2: Reverse strings
let emailRev = String(email.reversed())  // "moc.elpmaxe@eod.nhoj"
let cardPartRev = String(cardPart.reversed())  // "8004431215"

// Step 3: Concatenate
let combined = emailRev + clientPassword + cardPartRev

// Step 4: Uppercase
let upper = combined.uppercased()

// Step 5: MD5
let hash = md5(upper)
```

**Example 2: Apple Pay Hash**
```swift
// Given:
let identifier = "apple-pay-trans-12345"
let orderNumber = "order-12345"
let amount = "100.00"
let currency = "SAR"
let clientPassword = "merchant-password-123"

// Step 1: Concatenate all values
let combined = identifier + orderNumber + amount + currency + clientPassword

// Step 2: Reverse the entire combined string
let reversed = String(combined.reversed())

// Step 3: Uppercase
let upper = reversed.uppercased()

// Step 4: MD5
let hash = md5(upper)
```

### Using SDK Hash Utilities

The SDK provides convenient methods:

```swift
// For regular card transactions
let hash = EdfaPgHashUtil.hash(
    email: "john.doe@example.com",
    cardNumber: "5123445000000008"
)

// For transactions with trans_id
let hash = EdfaPgHashUtil.hash(
    email: "john.doe@example.com",
    cardNumber: "5123445000000008",
    transactionId: "uuid-trans-id"
)

// For Apple Pay
let hash = EdfaPgHashUtil.hashApplePayVirtual(
    identifier: "apple-pay-trans-id",
    number: "order-12345",
    amount: "100.00",
    currency: "SAR"
)
```

---

## Best Practices

1. **Always use HTTPS** - Never send payment data over unsecured connections

2. **Validate data before sending** - Ensure all required fields are populated

3. **Handle 3D Secure properly** - Implement redirect handling for 3DS authentication

4. **Store recurring tokens securely** - Use iOS Keychain for sensitive data

5. **Implement proper error handling** - Show user-friendly messages for common errors

6. **Test with test cards** - Use provided test card numbers during development

7. **Log requests in debug mode** - The SDK provides built-in logging for debugging

8. **Monitor transaction status** - Use GET_TRANS_STATUS for long-running transactions

9. **Implement timeouts** - Handle network timeouts gracefully

10. **Follow PCI compliance** - Never log or store full card numbers in production

---

## Debugging

### Enable Debug Logging

The SDK includes comprehensive request/response logging:

```swift
// Debug logging is controlled by ENABLE_DEBUG flag
// In EdfaPgRestApiClient, set printRequestInfo = true

let apiClient = EdfaPgRestApiClient()
apiClient.printRequestInfo = true  // Enables detailed logging
```

### Debug Output Format

```
-------------------------------------------------------------
SUCCESS 200

POST
REQUEST:

  URL: 
    https://pay.expresspay.sa/payment/post
  HEADERS: 
    {
      "Accept" : "application/json",
      "Content-Type" : "application/x-www-form-urlencoded",
      "X-User-Agent" : "ios"
    }
  PARAMETERS:
    action: SALE
    client_key: YOUR_MERCHANT_KEY
    order_id: order-12345
    ...

RESPONSE:
  {
    "action" : "SALE",
    "result" : "SUCCESS",
    "status" : "SETTLED",
    ...
  }
-------------------------------------------------------------
```

---

## Test Cards

Use these test card numbers during development:

| Card Number | Type | 3DS | Expected Result |
|-------------|------|-----|-----------------|
| 5123445000000008 | Mastercard | No | Success |
| 4111111111111111 | Visa | No | Success |
| 4000000000000002 | Visa | Yes | 3DS Required |
| 4000000000000010 | Visa | No | Declined |

**Test Card Details:**
- Expiry: Any future date (e.g., 01/2039)
- CVV: Any 3 digits (e.g., 100)

---

## Support

For additional support:

- Email: [support@edfapay.com](mailto:support@edfapay.com)
- Phone: [+966920033633](tel:+966920033633)
- Website: [https://edfapay.com](https://edfapay.com)

---

*Last Updated: January 2025*
*SDK Version: Compatible with EdfaPgSdk v1.x*
