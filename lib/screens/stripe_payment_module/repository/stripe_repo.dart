import 'package:dartz/dartz.dart';
import 'package:deal_diligence/core_data/api_host.dart';
import 'package:deal_diligence/core_data/app_exceptions.dart';
import 'package:deal_diligence/core_data/network/base_api_services.dart';
import 'package:deal_diligence/core_data/network/network_api_services.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/add_cust_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_card_list_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_customer_list_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/get_token_response.dart';
import 'package:deal_diligence/screens/stripe_payment_module/model/pay_payment_response.dart';

abstract class StripeRepository {
  ResultFuture<GetStripeTokenResponse> getToken(Map<String, dynamic> dic);
  ResultFuture<AddCustomerResponse> addCustomer(Map<String, dynamic> dic);
  ResultFuture<PayPaymentRespone> payPayment(Map<String, dynamic> dic);
  ResultFuture<GetCustomerListRespone> getCustomerList(
      Map<String, dynamic> dic);
  ResultFuture<GetCardListResponse> getCardList(
      Map<String, dynamic> dic, String? custId);
//   Future<dynamic> multiDownloadApi(Map<String, dynamic> dic);
//   Future<CancelShipmentModel> cancelShpmentApi(Map<String, dynamic> dic);
//   Future<TrackerStagesModel> trackerStageApi(Map<String, dynamic> dic);
}

class StripeHttpApiRepository implements StripeRepository {
  static final BaseApiServices _apiServices = NetworkApiService();
  @override
  ResultFuture<GetCustomerListRespone> getCustomerList(
      Map<String, dynamic> dic) async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.addCustomer, dic);
      return res.fold(
        (error) => Left(error),
        (data) {
          return Right(GetCustomerListRespone.fromMap(data));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<GetCardListResponse> getCardList(
      Map<String, dynamic> dic, String? custId) async {
    try {
      final res = await _apiServices.getGetApiResponse(
          '${ApiURL.addCustomer}/$custId/sources', dic);
      return res.fold(
        (error) => Left(error),
        (data) {
          return Right(GetCardListResponse.fromMap(data));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<GetStripeTokenResponse> getToken(
      Map<String, dynamic> dic) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.getToken, dic);
      return res.fold(
        (error) => Left(error),
        (data) {
          return Right(GetStripeTokenResponse.fromMap(data));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<AddCustomerResponse> addCustomer(
      Map<String, dynamic> dic) async {
    try {
      final res =
          await _apiServices.getPostApiResponse(ApiURL.addCustomer, dic);
      return res.fold(
        (error) => Left(error),
        (data) {
          return Right(AddCustomerResponse.fromMap(data));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<PayPaymentRespone> payPayment(Map<String, dynamic> dic) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.pay, dic);
      return res.fold(
        (error) => Left(error),
        (data) {
          return Right(PayPaymentRespone.fromMap(data));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
