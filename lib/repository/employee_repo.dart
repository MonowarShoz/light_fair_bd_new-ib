import 'package:flutter/foundation.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/Dio/dio_client.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/responseApi/api_response.dart';
import 'package:light_fair_bd_new/data/datasource/model/process_param_model.dart';
import 'package:light_fair_bd_new/data/exception/api_error_handler.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';

class EmployeeRepo {
  final DioClient dioClient;

  EmployeeRepo({required this.dioClient});

  Future<ApiResponse> heatApiForEmployeeInfo() async {
    try {
      final response = await dioClient.get('users');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
