// To parse this JSON data, do
//
//     final getCardListResponse = getCardListResponseFromMap(jsonString);

import 'dart:convert';

GetCardListResponse getCardListResponseFromMap(String str) =>
    GetCardListResponse.fromMap(json.decode(str));

String getCardListResponseToMap(GetCardListResponse data) =>
    json.encode(data.toMap());

class GetCardListResponse {
  final String? object;
  final List<Datum>? data;
  final bool? hasMore;
  final String? url;

  GetCardListResponse({
    this.object,
    this.data,
    this.hasMore,
    this.url,
  });

  GetCardListResponse copyWith({
    String? object,
    List<Datum>? data,
    bool? hasMore,
    String? url,
  }) =>
      GetCardListResponse(
        object: object ?? this.object,
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
        url: url ?? this.url,
      );

  factory GetCardListResponse.fromMap(Map<String, dynamic> json) =>
      GetCardListResponse(
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

  Datum({
    this.id,
    this.object,
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

  Datum copyWith({
    String? id,
    String? object,
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
      Datum(
        id: id ?? this.id,
        object: object ?? this.object,
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

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        object: json["object"],
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
