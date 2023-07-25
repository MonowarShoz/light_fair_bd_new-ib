import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/Dio/dio_client.dart';
import 'package:light_fair_bd_new/data/exception/api_error_handler.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';

import '../data/datasource/apiservices/responseApi/api_response.dart';

class MobilFeedRepo {
  final DioClient dioClient;

  MobilFeedRepo({required this.dioClient});

  Future<ApiResponse> postProcData(String data1) async {
    try {
      final response = await dioClient.post(
        AppConstants.hmsMblQuery,
        data: '"$data1"',
        options: buildCacheOptions(Duration(seconds: 500), forceRefresh: true),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Future<ApiResponse> readFileAppv() async {
  //   try {
  //     final response =
  //         await Dio().get('http://103.56.7.68/updateapps/system_info.txt');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}
