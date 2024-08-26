// To parse this JSON data, do
//
//     final getCustomerListRespone = getCustomerListResponeFromMap(jsonString);

import 'dart:convert';

GetCustomerListRespone getCustomerListResponeFromMap(String str) =>
    GetCustomerListRespone.fromMap(json.decode(str));

String getCustomerListResponeToMap(GetCustomerListRespone data) =>
    json.encode(data.toMap());

class GetCustomerListRespone {
  final String? object;
  final List<Datum>? data;
  final bool? hasMore;
  final String? url;

  GetCustomerListRespone({
    this.object,
    this.data,
    this.hasMore,
    this.url,
  });

  GetCustomerListRespone copyWith({
    String? object,
    List<Datum>? data,
    bool? hasMore,
    String? url,
  }) =>
      GetCustomerListRespone(
        object: object ?? this.object,
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
        url: url ?? this.url,
      );

  factory GetCustomerListRespone.fromMap(Map<String, dynamic> json) =>
      GetCustomerListRespone(
        object: json["object"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
        hasMore: json["has_more"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "object": object,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "has_more": hasMore,
        "url": url,
      };
}

class Datum {
  final String? id;
  final String? object;
  final dynamic address;
  final int? balance;
  final int? created;
  final dynamic currency;
  final String? defaultSource;
  final bool? delinquent;
  final String? description;
  final dynamic discount;
  final String? email;
  final String? invoicePrefix;
  final InvoiceSettings? invoiceSettings;
  final bool? livemode;
  final dynamic name;
  final int? nextInvoiceSequence;
  final dynamic phone;
  final List<dynamic>? preferredLocales;
  final dynamic shipping;
  final String? taxExempt;
  final dynamic testClock;

  Datum({
    this.id,
    this.object,
    this.address,
    this.balance,
    this.created,
    this.currency,
    this.defaultSource,
    this.delinquent,
    this.description,
    this.discount,
    this.email,
    this.invoicePrefix,
    this.invoiceSettings,
    this.livemode,
    this.name,
    this.nextInvoiceSequence,
    this.phone,
    this.preferredLocales,
    this.shipping,
    this.taxExempt,
    this.testClock,
  });

  Datum copyWith({
    String? id,
    String? object,
    dynamic address,
    int? balance,
    int? created,
    dynamic currency,
    String? defaultSource,
    bool? delinquent,
    String? description,
    dynamic discount,
    String? email,
    String? invoicePrefix,
    InvoiceSettings? invoiceSettings,
    bool? livemode,
    dynamic name,
    int? nextInvoiceSequence,
    dynamic phone,
    List<dynamic>? preferredLocales,
    dynamic shipping,
    String? taxExempt,
    dynamic testClock,
  }) =>
      Datum(
        id: id ?? this.id,
        object: object ?? this.object,
        address: address ?? this.address,
        balance: balance ?? this.balance,
        created: created ?? this.created,
        currency: currency ?? this.currency,
        defaultSource: defaultSource ?? this.defaultSource,
        delinquent: delinquent ?? this.delinquent,
        description: description ?? this.description,
        discount: discount ?? this.discount,
        email: email ?? this.email,
        invoicePrefix: invoicePrefix ?? this.invoicePrefix,
        invoiceSettings: invoiceSettings ?? this.invoiceSettings,
        livemode: livemode ?? this.livemode,
        name: name ?? this.name,
        nextInvoiceSequence: nextInvoiceSequence ?? this.nextInvoiceSequence,
        phone: phone ?? this.phone,
        preferredLocales: preferredLocales ?? this.preferredLocales,
        shipping: shipping ?? this.shipping,
        taxExempt: taxExempt ?? this.taxExempt,
        testClock: testClock ?? this.testClock,
      );

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
        address: json["address"],
        balance: json["balance"],
        created: json["created"],
        currency: json["currency"],
        defaultSource: json["default_source"],
        delinquent: json["delinquent"],
        description: json["description"],
        discount: json["discount"],
        email: json["email"],
        invoicePrefix: json["invoice_prefix"],
        invoiceSettings: json["invoice_settings"] == null
            ? null
            : InvoiceSettings.fromMap(json["invoice_settings"]),
        livemode: json["livemode"],
        name: json["name"],
        nextInvoiceSequence: json["next_invoice_sequence"],
        phone: json["phone"],
        preferredLocales: json["preferred_locales"] == null
            ? []
            : List<dynamic>.from(json["preferred_locales"]!.map((x) => x)),
        shipping: json["shipping"],
        taxExempt: json["tax_exempt"],
        testClock: json["test_clock"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "address": address,
        "balance": balance,
        "created": created,
        "currency": currency,
        "default_source": defaultSource,
        "delinquent": delinquent,
        "description": description,
        "discount": discount,
        "email": email,
        "invoice_prefix": invoicePrefix,
        "invoice_settings": invoiceSettings?.toMap(),
        "livemode": livemode,
        "name": name,
        "next_invoice_sequence": nextInvoiceSequence,
        "phone": phone,
        "preferred_locales": preferredLocales == null
            ? []
            : List<dynamic>.from(preferredLocales!.map((x) => x)),
        "shipping": shipping,
        "tax_exempt": taxExempt,
        "test_clock": testClock,
      };
}

class InvoiceSettings {
  final dynamic customFields;
  final dynamic defaultPaymentMethod;
  final dynamic footer;
  final dynamic renderingOptions;

  InvoiceSettings({
    this.customFields,
    this.defaultPaymentMethod,
    this.footer,
    this.renderingOptions,
  });

  InvoiceSettings copyWith({
    dynamic customFields,
    dynamic defaultPaymentMethod,
    dynamic footer,
    dynamic renderingOptions,
  }) =>
      InvoiceSettings(
        customFields: customFields ?? this.customFields,
        defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
        footer: footer ?? this.footer,
        renderingOptions: renderingOptions ?? this.renderingOptions,
      );

  factory InvoiceSettings.fromMap(Map<String, dynamic> json) => InvoiceSettings(
        customFields: json["custom_fields"],
        defaultPaymentMethod: json["default_payment_method"],
        footer: json["footer"],
        renderingOptions: json["rendering_options"],
      );

  Map<String, dynamic> toMap() => {
        "custom_fields": customFields,
        "default_payment_method": defaultPaymentMethod,
        "footer": footer,
        "rendering_options": renderingOptions,
      };
}
