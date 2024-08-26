import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:deal_diligence/components/custom_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../index.dart';

typedef ResultFuture<T> = Future<Either<AppException, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;

class NetworkApiService implements BaseApiServices {
  @override
  ResultFuture getGetApiResponse(String url,Map<String, dynamic> body) async {    
    if (kDebugMode) {
      print(url);
    }
    final dynamic responseJson;
    try {
      
      final token = body.containsKey('auth') ? body['auth'] : '';
      final response = await http.get(Uri.parse(url), headers:token.isEmpty? {
                      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      }:{
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
                    }).timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(response, false, '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      throw const Left(NoInternetException('NoInternetException [0]'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      throw const Left(FetchDataException('Network Request time out[408]'));
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  ResultFuture getPostApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print('req======================>$url \n\n$dic');
    }
          LoadingScreenOL().show();

    final token = dic.containsKey('auth') ? dic['auth']??'' : '';
    final dynamic responseJson;
    Map<String, dynamic> b = dic;
    try {      
      b.remove('auth');
      final Response response = await http
          .post(Uri.parse(url),
            body: b.map((key, value) => MapEntry(key, value.toString())), // Convert the map to x-www-form-urlencoded
              headers: token.isNotEmpty
                  ? {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
                    }
                  : {
                      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
                    })
          .timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(response, false,
          dic.containsKey('sessionToken') ? dic['sessionToken'] : '', url);
    } on SocketException {
      LoadingScreenOL().hide();
      // AppToast.toastMessage('Communication issue.');
      throw const Left(NoInternetException('Communication issue.'));
    } on TimeoutException {
      LoadingScreenOL().hide();
      // AppToast.toastMessage('Network Request time out');
      throw const Left(FetchDataException('Network Request time out'));
    }
    if (kDebugMode) {
      print(responseJson);
      print('responseJson======================>$responseJson');
    }    
    LoadingScreenOL().hide();
    return responseJson;
  }


  

  Either<AppException, T> _returnResponse<T>(http.Response response,
      bool isMultipart, String sessionToken, String url) {
    if (kDebugMode) {
      print(response.statusCode);
    }
    switch (response.statusCode) {
      case 200:
        final responseJson = jsonDecode(response.body);        
        LoadingScreenOL().hide();
        return Right(responseJson);
      case 201:
        final responseJson = jsonDecode(response.body);
        print(responseJson);
        LoadingScreenOL().hide();
        return Right(responseJson);  
      case 400:
        LoadingScreenOL().hide();
        throw Left(BadRequestException(response.body.toString().length<80?response.body.toString(): '${response.reasonPhrase}'));
      case 500:
        LoadingScreenOL().hide();
        throw Left(InternalServerException(response.body.toString().length<80?response.body.toString():'${response.reasonPhrase}'));
      case 404:
        LoadingScreenOL().hide();
        throw Left(UnauthorisedException(response.body.toString().length<80?response.body.toString():'${response.reasonPhrase}'));
      default:
        LoadingScreenOL().hide();
        throw const Left(FetchDataException('Error occured while communicating with server')); //// isMultipart ? response.body : jsonDecode(response.body);
    }
  }




}
