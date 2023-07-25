// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:light_fair_bd_new/data/datasource/model/employee_info_model.dart';
// import 'package:light_fair_bd_new/repository/employee_repo.dart';

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/responseApi/api_response.dart';
import 'package:light_fair_bd_new/data/datasource/model/employee_info_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/mobil_product.dart';
import 'package:light_fair_bd_new/repository/employee_repo.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeRepo? employeeAttendanceRepo;

  EmployeeProvider({this.employeeAttendanceRepo});

  List<UserModel>? _employeeInfoModel = [];
  List<UserModel>? _employeeInfoModelTemp = [];

  List<UserModel>? get employeeInfoModel => _employeeInfoModel;

  List<UserModel>? get employeeInfoModelTemp => _employeeInfoModelTemp;

  Future initializeAllEmployeeInfo(
    BuildContext context,
  ) async {
    _employeeInfoModel = null;
    _employeeInfoModelTemp = null;

    ApiResponse apiResponse =
        await employeeAttendanceRepo!.heatApiForEmployeeInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _employeeInfoModel = [];
      _employeeInfoModelTemp = [];
      for (var zone in apiResponse.response!.data) {
        _employeeInfoModel!.add(UserModel.fromJson(zone));
      }
      // apiResponse.response.data.forEach((zone) {
      //   _employeeInfoModel.add(EmployeeInfoModel.fromJson(zone));
      // });

      _employeeInfoModelTemp = employeeInfoModel;
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    notifyListeners();
  }

  // for search
  bool isSearch = false;
  bool isSearchForAppointment = false;

  searchEmployee(String query) {
    if (query.isEmpty) {
      _employeeInfoModel!.clear();
      _employeeInfoModel = employeeInfoModelTemp;
      isSearch = false;
      notifyListeners();
    } else {
      _employeeInfoModel = [];
      isSearch = true;
      employeeInfoModelTemp!.forEach((employeeInfo) async {
        if ((employeeInfo.name!.toLowerCase().contains(query.toLowerCase()))) {
          _employeeInfoModel!.add(employeeInfo);
        }
      });
      notifyListeners();
    }
  }
}
