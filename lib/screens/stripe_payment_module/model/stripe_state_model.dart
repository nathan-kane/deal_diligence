import 'package:deal_diligence/screens/stripe_payment_module/model/add_cust_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_card_list_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_customer_list_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/pay_payment_response.dart';
import 'package:equatable/equatable.dart';

import 'get_token_response.dart';

class GetStripeState extends Equatable {
  final String? id;
  final String? object;
  final Card? card;
  final bool? livemode;
  final String? type;
  final AddCustomerResponse? addCustomerResponse;
  final PayPaymentRespone? payPaymentRespone;
  final GetCustomerListRespone? getCustomerList;
  final GetCardListResponse? getCardList;

  const GetStripeState({
    this.id,
    this.object,
    this.card,
    this.livemode,
    this.type,
    this.addCustomerResponse,
    this.payPaymentRespone,
    this.getCustomerList,
    this.getCardList,
  });
  const GetStripeState.initial()
      : this(
            card: null,
            id: '',
            livemode: false,
            object: '',
            type: '',
            addCustomerResponse: null,
            payPaymentRespone: null,
            getCustomerList: null,
            getCardList: null);

  GetStripeState copyWith({
    String? id,
    String? object,
    Card? card,
    bool? livemode,
    String? type,
    AddCustomerResponse? addCustomerResponse,
    PayPaymentRespone? payPaymentRespone,
    GetCustomerListRespone? getCustomerList,
    GetCardListResponse? getCardList,
  }) =>
      GetStripeState(
        id: id ?? this.id,
        object: object ?? this.object,
        card: card ?? this.card,
        livemode: livemode ?? this.livemode,
        type: type ?? this.type,
        addCustomerResponse: addCustomerResponse ?? this.addCustomerResponse,
        payPaymentRespone: payPaymentRespone ?? this.payPaymentRespone,
        getCustomerList: getCustomerList ?? this.getCustomerList,
        getCardList: getCardList ?? this.getCardList,
      );

  @override
  List<Object?> get props => [
        id,
        object,
        card,
        livemode,
        type,
        addCustomerResponse,
        payPaymentRespone,
        getCustomerList,
        getCardList
      ];
}
