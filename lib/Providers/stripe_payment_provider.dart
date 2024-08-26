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

  Future<void> getStripeToken(
      {String? cardNumber, String? month, String? year, String? cvc}) async {
    try {
      final response = await apiServices.getToken({
        "card[number]": cardNumber,
        "card[exp_month]": month,
        "card[exp_year]": year,
        "card[cvc]": cvc,
        "auth": ApiURL.publicTestKey
      });
      await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
        },
        (data) async {
          LoadingScreenOL().hide();
          final card = r.Card.fromMap(data.toMap());
          // call api/jAM/jamdetail-page/181/
          state = state.copyWith(card: card, id: data.id);
          print(data.id);
          addCustomer(source: data.id);
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

  Future<void> addCustomer(
      {String? description, String? source, String? email}) async {
    try {
      final response = await apiServices.addCustomer({
        "description": description ?? '',
        "source": source,
        "email": email ?? '',
        "auth": ApiURL.secretKey
      });
      await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
        },
        (data) async {
          LoadingScreenOL().hide();
          final addCust = AddCustomerResponse.fromMap(data.toMap());
          // call api/jAM/jamdetail-page/181/
          state = state.copyWith(addCustomerResponse: addCust);
          payPayment(amount: '100', cust: data.id);
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

  Future<void> payPayment(
      {String? amount,
      String? cust,
      String? description,
      String? source}) async {
    try {
      final response = await apiServices.payPayment({
        "description": description ?? '',
        "amount": amount,
        "currency": 'USD',
        "customer": cust,
        if (source != null) 'source': source,
        "auth": ApiURL.secretKey
      });
      await response.fold(
        (failure) async {
          LoadingScreenOL().hide();
          AppToast.toastMessage(failure.message.toString());
        },
        (data) async {
          LoadingScreenOL().hide();
          final payPayment = PayPaymentRespone.fromMap(data.toMap());
          // call api/jAM/jamdetail-page/181/
          state = state.copyWith(payPaymentRespone: payPayment);
          AppToast.toastMessage(data.status.toString());
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
          // call api/jAM/jamdetail-page/181/
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
          // call api/jAM/jamdetail-page/181/
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
