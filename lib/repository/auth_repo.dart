import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/Dio/dio_client.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/responseApi/api_response.dart';
import 'package:light_fair_bd_new/data/datasource/model/config_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/jwttoken_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/menu_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/user_model.dart';
import 'package:light_fair_bd_new/data/exception/api_error_handler.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/view/home/home.dart';
import 'package:light_fair_bd_new/view/order/order_process/new_order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  // Future<ApiResponse> login(User user) async {
  //   try {
  //     final response =
  //         await dioClient.post(AppConstants.jwtTokenUri, data: user.toJson());
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
  Future<ApiResponse> login({String? userID, String? password, String? deviceID}) async {
    try {
      final response = await dioClient.post(AppConstants.jwtTokenUri, data: {
        "userId": userID,
        "password": password,
        "terminalID": deviceID,
        "comcode": "6535",
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String? token) async {
    dioClient.token = token!;
    dioClient.dio!.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  Future<void> cleanBarearToken() async {
    await sharedPreferences.remove(AppConstants.TOKEN);
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_EMAIL, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_EMAIL);
  }

  Future<ApiResponse> heatStudApi() async {
    try {
      // final response = await dioClient.get('users/2');
      final response = await dioClient.get('student');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for menu section

}
