// To parse this JSON data, do
//
//     final payPaymentRespone = payPaymentResponeFromMap(jsonString);

import 'dart:convert';

import 'package:deal_diligence/screens/stripe_payment_module/model/get_token_response.dart';

PayPaymentRespone payPaymentResponeFromMap(String str) =>
    PayPaymentRespone.fromMap(json.decode(str));

String payPaymentResponeToMap(PayPaymentRespone data) =>
    json.encode(data.toMap());

class PayPaymentRespone {
  final String? id;
  final String? object;
  final int? amount;
  final int? amountCaptured;
  final int? amountRefunded;
  final dynamic application;
  final dynamic applicationFee;
  final dynamic applicationFeeAmount;
  final String? balanceTransaction;
  final BillingDetails? billingDetails;
  final String? calculatedStatementDescriptor;
  final bool? captured;
  final int? created;
  final String? currency;
  final String? customer;
  final String? description;
  final dynamic destination;
  final dynamic dispute;
  final bool? disputed;
  final dynamic failureBalanceTransaction;
  final dynamic failureCode;
  final dynamic failureMessage;
  final dynamic invoice;
  final bool? livemode;
  final dynamic onBehalfOf;
  final dynamic order;
  final Outcome? outcome;
  final bool? paid;
  final dynamic paymentIntent;
  final String? paymentMethod;
  final PaymentMethodDetails? paymentMethodDetails;
  final dynamic receiptEmail;
  final dynamic receiptNumber;
  final String? receiptUrl;
  final bool? refunded;
  final dynamic review;
  final dynamic shipping;
  final Source? source;
  final dynamic sourceTransfer;
  final dynamic statementDescriptor;
  final dynamic statementDescriptorSuffix;
  final String? status;
  final dynamic transferData;
  final dynamic transferGroup;

  PayPaymentRespone({
    this.id,
    this.object,
    this.amount,
    this.amountCaptured,
    this.amountRefunded,
    this.application,
    this.applicationFee,
    this.applicationFeeAmount,
    this.balanceTransaction,
    this.billingDetails,
    this.calculatedStatementDescriptor,
    this.captured,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.destination,
    this.dispute,
    this.disputed,
    this.failureBalanceTransaction,
    this.failureCode,
    this.failureMessage,
    this.invoice,
    this.livemode,
    this.onBehalfOf,
    this.order,
    this.outcome,
    this.paid,
    this.paymentIntent,
    this.paymentMethod,
    this.paymentMethodDetails,
    this.receiptEmail,
    this.receiptNumber,
    this.receiptUrl,
    this.refunded,
    this.review,
    this.shipping,
    this.source,
    this.sourceTransfer,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  PayPaymentRespone copyWith({
    String? id,
    String? object,
    int? amount,
    int? amountCaptured,
    int? amountRefunded,
    dynamic application,
    dynamic applicationFee,
    dynamic applicationFeeAmount,
    String? balanceTransaction,
    BillingDetails? billingDetails,
    String? calculatedStatementDescriptor,
    bool? captured,
    int? created,
    String? currency,
    String? customer,
    String? description,
    dynamic destination,
    dynamic dispute,
    bool? disputed,
    dynamic failureBalanceTransaction,
    dynamic failureCode,
    dynamic failureMessage,
    dynamic invoice,
    bool? livemode,
    dynamic onBehalfOf,
    dynamic order,
    Outcome? outcome,
    bool? paid,
    dynamic paymentIntent,
    String? paymentMethod,
    PaymentMethodDetails? paymentMethodDetails,
    dynamic receiptEmail,
    dynamic receiptNumber,
    String? receiptUrl,
    bool? refunded,
    dynamic review,
    dynamic shipping,
    Source? source,
    dynamic sourceTransfer,
    dynamic statementDescriptor,
    dynamic statementDescriptorSuffix,
    String? status,
    dynamic transferData,
    dynamic transferGroup,
  }) =>
      PayPaymentRespone(
        id: id ?? this.id,
        object: object ?? this.object,
        amount: amount ?? this.amount,
        amountCaptured: amountCaptured ?? this.amountCaptured,
        amountRefunded: amountRefunded ?? this.amountRefunded,
        application: application ?? this.application,
        applicationFee: applicationFee ?? this.applicationFee,
        applicationFeeAmount: applicationFeeAmount ?? this.applicationFeeAmount,
        balanceTransaction: balanceTransaction ?? this.balanceTransaction,
        billingDetails: billingDetails ?? this.billingDetails,
        calculatedStatementDescriptor:
            calculatedStatementDescriptor ?? this.calculatedStatementDescriptor,
        captured: captured ?? this.captured,
        created: created ?? this.created,
        currency: currency ?? this.currency,
        customer: customer ?? this.customer,
        description: description ?? this.description,
        destination: destination ?? this.destination,
        dispute: dispute ?? this.dispute,
        disputed: disputed ?? this.disputed,
        failureBalanceTransaction:
            failureBalanceTransaction ?? this.failureBalanceTransaction,
        failureCode: failureCode ?? this.failureCode,
        failureMessage: failureMessage ?? this.failureMessage,
        invoice: invoice ?? this.invoice,
        livemode: livemode ?? this.livemode,
        onBehalfOf: onBehalfOf ?? this.onBehalfOf,
        order: order ?? this.order,
        outcome: outcome ?? this.outcome,
        paid: paid ?? this.paid,
        paymentIntent: paymentIntent ?? this.paymentIntent,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentMethodDetails: paymentMethodDetails ?? this.paymentMethodDetails,
        receiptEmail: receiptEmail ?? this.receiptEmail,
        receiptNumber: receiptNumber ?? this.receiptNumber,
        receiptUrl: receiptUrl ?? this.receiptUrl,
        refunded: refunded ?? this.refunded,
        review: review ?? this.review,
        shipping: shipping ?? this.shipping,
        source: source ?? this.source,
        sourceTransfer: sourceTransfer ?? this.sourceTransfer,
        statementDescriptor: statementDescriptor ?? this.statementDescriptor,
        statementDescriptorSuffix:
            statementDescriptorSuffix ?? this.statementDescriptorSuffix,
        status: status ?? this.status,
        transferData: transferData ?? this.transferData,
        transferGroup: transferGroup ?? this.transferGroup,
      );

  factory PayPaymentRespone.fromMap(Map<String, dynamic> json) =>
      PayPaymentRespone(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCaptured: json["amount_captured"],
        amountRefunded: json["amount_refunded"],
        application: json["application"],
        applicationFee: json["application_fee"],
        applicationFeeAmount: json["application_fee_amount"],
        balanceTransaction: json["balance_transaction"],
        billingDetails: json["billing_details"] == null
            ? null
            : BillingDetails.fromMap(json["billing_details"]),
        calculatedStatementDescriptor: json["calculated_statement_descriptor"],
        captured: json["captured"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        destination: json["destination"],
        dispute: json["dispute"],
        disputed: json["disputed"],
        failureBalanceTransaction: json["failure_balance_transaction"],
        failureCode: json["failure_code"],
        failureMessage: json["failure_message"],
        invoice: json["invoice"],
        livemode: json["livemode"],
        onBehalfOf: json["on_behalf_of"],
        order: json["order"],
        outcome:
            json["outcome"] == null ? null : Outcome.fromMap(json["outcome"]),
        paid: json["paid"],
        paymentIntent: json["payment_intent"],
        paymentMethod: json["payment_method"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? null
            : PaymentMethodDetails.fromMap(json["payment_method_details"]),
        receiptEmail: json["receipt_email"],
        receiptNumber: json["receipt_number"],
        receiptUrl: json["receipt_url"],
        refunded: json["refunded"],
        review: json["review"],
        shipping: json["shipping"],
        source: json["source"] == null ? null : Source.fromMap(json["source"]),
        sourceTransfer: json["source_transfer"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_captured": amountCaptured,
        "amount_refunded": amountRefunded,
        "application": application,
        "application_fee": applicationFee,
        "application_fee_amount": applicationFeeAmount,
        "balance_transaction": balanceTransaction,
        "billing_details": billingDetails?.toMap(),
        "calculated_statement_descriptor": calculatedStatementDescriptor,
        "captured": captured,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "destination": destination,
        "dispute": dispute,
        "disputed": disputed,
        "failure_balance_transaction": failureBalanceTransaction,
        "failure_code": failureCode,
        "failure_message": failureMessage,
        "invoice": invoice,
        "livemode": livemode,
        "on_behalf_of": onBehalfOf,
        "order": order,
        "outcome": outcome?.toMap(),
        "paid": paid,
        "payment_intent": paymentIntent,
        "payment_method": paymentMethod,
        "payment_method_details": paymentMethodDetails?.toMap(),
        "receipt_email": receiptEmail,
        "receipt_number": receiptNumber,
        "receipt_url": receiptUrl,
        "refunded": refunded,
        "review": review,
        "shipping": shipping,
        "source": source?.toMap(),
        "source_transfer": sourceTransfer,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class BillingDetails {
  final Address? address;
  final dynamic email;
  final dynamic name;
  final dynamic phone;

  BillingDetails({
    this.address,
    this.email,
    this.name,
    this.phone,
  });

  BillingDetails copyWith({
    Address? address,
    dynamic email,
    dynamic name,
    dynamic phone,
  }) =>
      BillingDetails(
        address: address ?? this.address,
        email: email ?? this.email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
      );

  factory BillingDetails.fromMap(Map<String, dynamic> json) => BillingDetails(
        address:
            json["address"] == null ? null : Address.fromMap(json["address"]),
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "address": address?.toMap(),
        "email": email,
        "name": name,
        "phone": phone,
      };
}

class Address {
  final dynamic city;
  final dynamic country;
  final dynamic line1;
  final dynamic line2;
  final dynamic postalCode;
  final dynamic state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  Address copyWith({
    dynamic city,
    dynamic country,
    dynamic line1,
    dynamic line2,
    dynamic postalCode,
    dynamic state,
  }) =>
      Address(
        city: city ?? this.city,
        country: country ?? this.country,
        line1: line1 ?? this.line1,
        line2: line2 ?? this.line2,
        postalCode: postalCode ?? this.postalCode,
        state: state ?? this.state,
      );

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        city: json["city"],
        country: json["country"],
        line1: json["line1"],
        line2: json["line2"],
        postalCode: json["postal_code"],
        state: json["state"],
      );

  Map<String, dynamic> toMap() => {
        "city": city,
        "country": country,
        "line1": line1,
        "line2": line2,
        "postal_code": postalCode,
        "state": state,
      };
}

class Outcome {
  final String? networkStatus;
  final dynamic reason;
  final String? riskLevel;
  final int? riskScore;
  final String? sellerMessage;
  final String? type;

  Outcome({
    this.networkStatus,
    this.reason,
    this.riskLevel,
    this.riskScore,
    this.sellerMessage,
    this.type,
  });

  Outcome copyWith({
    String? networkStatus,
    dynamic reason,
    String? riskLevel,
    int? riskScore,
    String? sellerMessage,
    String? type,
  }) =>
      Outcome(
        networkStatus: networkStatus ?? this.networkStatus,
        reason: reason ?? this.reason,
        riskLevel: riskLevel ?? this.riskLevel,
        riskScore: riskScore ?? this.riskScore,
        sellerMessage: sellerMessage ?? this.sellerMessage,
        type: type ?? this.type,
      );

  factory Outcome.fromMap(Map<String, dynamic> json) => Outcome(
        networkStatus: json["network_status"],
        reason: json["reason"],
        riskLevel: json["risk_level"],
        riskScore: json["risk_score"],
        sellerMessage: json["seller_message"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "network_status": networkStatus,
        "reason": reason,
        "risk_level": riskLevel,
        "risk_score": riskScore,
        "seller_message": sellerMessage,
        "type": type,
      };
}

class PaymentMethodDetails {
  final Card? card;
  final String? type;

  PaymentMethodDetails({
    this.card,
    this.type,
  });

  PaymentMethodDetails copyWith({
    Card? card,
    String? type,
  }) =>
      PaymentMethodDetails(
        card: card ?? this.card,
        type: type ?? this.type,
      );

  factory PaymentMethodDetails.fromMap(Map<String, dynamic> json) =>
      PaymentMethodDetails(
        card: json["card"] == null ? null : Card.fromMap(json["card"]),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "card": card?.toMap(),
        "type": type,
      };
}

class ExtendedAuthorization {
  final String? status;

  ExtendedAuthorization({
    this.status,
  });

  ExtendedAuthorization copyWith({
    String? status,
  }) =>
      ExtendedAuthorization(
        status: status ?? this.status,
      );

  factory ExtendedAuthorization.fromMap(Map<String, dynamic> json) =>
      ExtendedAuthorization(
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
      };
}

class NetworkToken {
  final bool? used;

  NetworkToken({
    this.used,
  });

  NetworkToken copyWith({
    bool? used,
  }) =>
      NetworkToken(
        used: used ?? this.used,
      );

  factory NetworkToken.fromMap(Map<String, dynamic> json) => NetworkToken(
        used: json["used"],
      );

  Map<String, dynamic> toMap() => {
        "used": used,
      };
}

class Overcapture {
  final int? maximumAmountCapturable;
  final String? status;

  Overcapture({
    this.maximumAmountCapturable,
    this.status,
  });

  Overcapture copyWith({
    int? maximumAmountCapturable,
    String? status,
  }) =>
      Overcapture(
        maximumAmountCapturable:
            maximumAmountCapturable ?? this.maximumAmountCapturable,
        status: status ?? this.status,
      );

  factory Overcapture.fromMap(Map<String, dynamic> json) => Overcapture(
        maximumAmountCapturable: json["maximum_amount_capturable"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "maximum_amount_capturable": maximumAmountCapturable,
        "status": status,
      };
}

class Source {
  final String? id;
  final String? object;
  final dynamic addressCity;
  final dynamic addressCountry;
  final dynamic addressLine1;
  final dynamic addressLine1Check;
  final dynamic addressLine2;
  final dynamic addressState;
  final dynamic addressZip;
  final dynamic addressZipCheck;
  final String? brand;
  final String? country;
  final String? customer;
  final String? cvcCheck;
  final dynamic dynamicLast4;
  final int? expMonth;
  final int? expYear;
  final String? fingerprint;
  final String? funding;
  final String? last4;
  final dynamic name;
  final dynamic tokenizationMethod;
  final dynamic wallet;

  Source({
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
    this.name,
    this.tokenizationMethod,
    this.wallet,
  });

  Source copyWith({
    String? id,
    String? object,
    dynamic addressCity,
    dynamic addressCountry,
    dynamic addressLine1,
    dynamic addressLine1Check,
    dynamic addressLine2,
    dynamic addressState,
    dynamic addressZip,
    dynamic addressZipCheck,
    String? brand,
    String? country,
    String? customer,
    String? cvcCheck,
    dynamic dynamicLast4,
    int? expMonth,
    int? expYear,
    String? fingerprint,
    String? funding,
    String? last4,
    dynamic name,
    dynamic tokenizationMethod,
    dynamic wallet,
  }) =>
      Source(
        id: id ?? this.id,
        object: object ?? this.object,
        addressCity: addressCity ?? this.addressCity,
        addressCountry: addressCountry ?? this.addressCountry,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine1Check: addressLine1Check ?? this.addressLine1Check,
        addressLine2: addressLine2 ?? this.addressLine2,
        addressState: addressState ?? this.addressState,
        addressZip: addressZip ?? this.addressZip,
        addressZipCheck: addressZipCheck ?? this.addressZipCheck,
        brand: brand ?? this.brand,
        country: country ?? this.country,
        customer: customer ?? this.customer,
        cvcCheck: cvcCheck ?? this.cvcCheck,
        dynamicLast4: dynamicLast4 ?? this.dynamicLast4,
        expMonth: expMonth ?? this.expMonth,
        expYear: expYear ?? this.expYear,
        fingerprint: fingerprint ?? this.fingerprint,
        funding: funding ?? this.funding,
        last4: last4 ?? this.last4,
        name: name ?? this.name,
        tokenizationMethod: tokenizationMethod ?? this.tokenizationMethod,
        wallet: wallet ?? this.wallet,
      );

  factory Source.fromMap(Map<String, dynamic> json) => Source(
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
        name: json["name"],
        tokenizationMethod: json["tokenization_method"],
        wallet: json["wallet"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "address_city": addressCity,
        "address_country": addressCountry,
        "address_line1": addressLine1,
        "address_line1_check": addressLine1Check,
        "address_line2": addressLine2,
        "address_state": addressState,
        "address_zip": addressZip,
        "address_zip_check": addressZipCheck,
        "brand": brand,
        "country": country,
        "customer": customer,
        "cvc_check": cvcCheck,
        "dynamic_last4": dynamicLast4,
        "exp_month": expMonth,
        "exp_year": expYear,
        "fingerprint": fingerprint,
        "funding": funding,
        "last4": last4,
        "name": name,
        "tokenization_method": tokenizationMethod,
        "wallet": wallet,
      };
}
