
import 'network_api_services.dart';

abstract class BaseApiServices {
  ResultFuture getGetApiResponse(String serviceUrl, Map<String, dynamic> body);
  ResultFuture getPostApiResponse(String serviceUrl, Map<String, dynamic> body);
}
