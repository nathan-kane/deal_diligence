// To parse this JSON data, do
//
//     final getStripeTokenResponse = getStripeTokenResponseFromMap(jsonString);

import 'dart:convert';

GetStripeTokenResponse getStripeTokenResponseFromMap(String str) => GetStripeTokenResponse.fromMap(json.decode(str));

String getStripeTokenResponseToMap(GetStripeTokenResponse data) => json.encode(data.toMap());

class GetStripeTokenResponse {
    final String? id;
    final String? object;
    final Card? card;
    final String? clientIp;
    final int? created;
    final bool? livemode;
    final String? type;
    final bool? used;

    GetStripeTokenResponse({
        this.id,
        this.object,
        this.card,
        this.clientIp,
        this.created,
        this.livemode,
        this.type,
        this.used,
    });

    GetStripeTokenResponse copyWith({
        String? id,
        String? object,
        Card? card,
        String? clientIp,
        int? created,
        bool? livemode,
        String? type,
        bool? used,
    }) => 
        GetStripeTokenResponse(
            id: id ?? this.id,
            object: object ?? this.object,
            card: card ?? this.card,
            clientIp: clientIp ?? this.clientIp,
            created: created ?? this.created,
            livemode: livemode ?? this.livemode,
            type: type ?? this.type,
            used: used ?? this.used,
        );

    factory GetStripeTokenResponse.fromMap(Map<String, dynamic> json) => GetStripeTokenResponse(
        id: json["id"],
        object: json["object"],
        card: json["card"] == null ? null : Card.fromMap(json["card"]),
        clientIp: json["client_ip"],
        created: json["created"],
        livemode: json["livemode"],
        type: json["type"],
        used: json["used"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "card": card?.toMap(),
        "client_ip": clientIp,
        "created": created,
        "livemode": livemode,
        "type": type,
        "used": used,
    };
}

class Card {
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
    final String? cvcCheck;
    final dynamic dynamicLast4;
    final int? expMonth;
    final int? expYear;
    final String? funding;
    final String? last4;
    final dynamic name;
    final Networks? networks;
    final dynamic tokenizationMethod;
    final dynamic wallet;

    Card({
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
        this.cvcCheck,
        this.dynamicLast4,
        this.expMonth,
        this.expYear,
        this.funding,
        this.last4,
        this.name,
        this.networks,
        this.tokenizationMethod,
        this.wallet,
    });

    Card copyWith({
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
        String? cvcCheck,
        dynamic dynamicLast4,
        int? expMonth,
        int? expYear,
        String? funding,
        String? last4,
        dynamic name,
        Networks? networks,
        dynamic tokenizationMethod,
        dynamic wallet,
    }) => 
        Card(
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
            cvcCheck: cvcCheck ?? this.cvcCheck,
            dynamicLast4: dynamicLast4 ?? this.dynamicLast4,
            expMonth: expMonth ?? this.expMonth,
            expYear: expYear ?? this.expYear,
            funding: funding ?? this.funding,
            last4: last4 ?? this.last4,
            name: name ?? this.name,
            networks: networks ?? this.networks,
            tokenizationMethod: tokenizationMethod ?? this.tokenizationMethod,
            wallet: wallet ?? this.wallet,
        );

    factory Card.fromMap(Map<String, dynamic> json) => Card(
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
        cvcCheck: json["cvc_check"],
        dynamicLast4: json["dynamic_last4"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        funding: json["funding"],
        last4: json["last4"],
        name: json["name"],
        networks: json["networks"] == null ? null : Networks.fromMap(json["networks"]),
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
        "cvc_check": cvcCheck,
        "dynamic_last4": dynamicLast4,
        "exp_month": expMonth,
        "exp_year": expYear,
        "funding": funding,
        "last4": last4,
        "name": name,
        "networks": networks?.toMap(),
        "tokenization_method": tokenizationMethod,
        "wallet": wallet,
    };
}

class Networks {
    final dynamic preferred;

    Networks({
        this.preferred,
    });

    Networks copyWith({
        dynamic preferred,
    }) => 
        Networks(
            preferred: preferred ?? this.preferred,
        );

    factory Networks.fromMap(Map<String, dynamic> json) => Networks(
        preferred: json["preferred"],
    );

    Map<String, dynamic> toMap() => {
        "preferred": preferred,
    };
}

