//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:deal_diligence/components/app_toast.dart';
import 'package:deal_diligence/components/custom_loading.dart';
import 'package:deal_diligence/core_data/index.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/add_cust_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_card_list_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_token_response.dart'
    as r;
import 'package:deal_diligence/screens/stripe_payment_module/model/pay_payment_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/stripe_state_model.dart';
// import 'package:deal_diligence/screens/stripe_payment_module/model/stripe_state_model.dart'as r;
import 'package:deal_diligence/screens/stripe_payment_module/repository/stripe_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/stripe_payment_module/model/get_customer_list_response.dart';

class GetStripeNotifier extends StateNotifier<GetStripeState> {
  final StripeRepository apiServices = StripeHttpApiRepository();
  GetStripeNotifier() : super(const GetStripeState.initial()) {}
  Future<bool> getStripeToken(
      {String? userName,
      String? cardNumber,
      String? month,
      String? year,
      String? cvc}) async {
    try {
      final response = await apiServices.getToken({
        "card[number]": cardNumber,
        "card[exp_month]": month,
        "card[exp_year]": year,
        "card[cvc]": cvc,
        "auth": ApiURL.publicTestKey
      });

      return await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
          return false;
        },
        (data) async {
          LoadingScreenOL().hide();
          final card = r.Card.fromMap(data.toMap());
          state = state.copyWith(card: card, id: data.id);
          return await addCustomer(userName: userName, source: data.id);
        },
      );
    } catch (e) {
      AppToast.toastMessage(e.toString());
      print(e.toString());
      return false;
    }
  }

  Future<bool> addCustomer(
      {String? userName,
      String? description,
      String? source,
      String? email}) async {
    try {
      final response = await apiServices.addCustomer({
        "description": description ?? '',
        "source": source,
        "email": email ?? '',
        "name": userName ?? '',
        "auth": ApiURL.secretKey
      });

      return await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
          return false;
        },
        (data) async {
          LoadingScreenOL().hide();
          final addCust = AddCustomerResponse.fromMap(data.toMap());
          state = state.copyWith(addCustomerResponse: addCust);
          return await payPayment(cust: data.id);
        },
      );
    } catch (e) {
      AppToast.toastMessage(e.toString());
      print(e.toString());
      return false;
    }
  }

  Future<bool> payPayment(
      {String? cust, String? description, String? source}) async {
    try {
      final response = await apiServices.payPayment({
        "description": description ?? '',
        "amount": 1500,
        "currency": 'USD',
        "customer": cust,
        if (source != null) 'source': source,
        "auth": ApiURL.secretKey
      });

      return await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
          return false;
        },
        (data) async {
          LoadingScreenOL().hide();
          final payPayment = PayPaymentRespone.fromMap(data.toMap());
          state = state.copyWith(payPaymentRespone: payPayment);
          return true;
        },
      );
    } catch (e) {
      AppToast.toastMessage(e.toString());
      print(e.toString());
      return false;
    }
  }

  Future<void> getCustomerList() async {
    try {
      final response =
          await apiServices.getCustomerList({"auth": ApiURL.secretKey});
      await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
        },
        (data) async {
          LoadingScreenOL().hide();
          final customers = GetCustomerListRespone.fromMap(data.toMap());
          state = state.copyWith(getCustomerList: customers);
          getCardList(custId: customers.data!.first.id);
          // AppToast.toastMessage(data.status.toString());
          // print(data.id);
        },
      ).catchError((onError) {
        LoadingScreenOL().hide();
        print(onError.toString());
      });
    } catch (e) {
      AppToast.toastMessage(e.toString());

      print(e.toString());
    }
  }

  Future<void> getCardList({String? custId}) async {
    try {
      final response =
          await apiServices.getCardList({"auth": ApiURL.secretKey}, custId);
      await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
        },
        (data) async {
          LoadingScreenOL().hide();
          final cards = GetCardListResponse.fromMap(data.toMap());
          state = state.copyWith(getCardList: cards);
          // AppToast.toastMessage(data.status.toString());
          // print(data.id);
        },
      ).catchError((onError) {
        LoadingScreenOL().hide();
        print(onError.toString());
      });
    } catch (e) {
      AppToast.toastMessage(e.toString());

      print(e.toString());
    }
  }
}

final getStripeTokenProvider =
    StateNotifierProvider<GetStripeNotifier, GetStripeState>((ref) {
  return GetStripeNotifier();
});
