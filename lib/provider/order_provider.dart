import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:light_fair_bd_new/data/datasource/apiservices/responseApi/api_response.dart';
import 'package:light_fair_bd_new/data/datasource/model/customer.dart';
import 'package:light_fair_bd_new/repository/employee_repo.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';

class OrderProvider with ChangeNotifier {
  EmployeeRepo? employeeRepo;
  OrderProvider({this.employeeRepo});

  //List<ProductList> _productList = [];

  Future<List<Customer>> getUserSuggestions(String query) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);
      notifyListeners();
      return users.map((json) => Customer.fromJson(json)).where((user) {
        final nameLower = user.name!.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  List<Customer>? _employeeInfoModel = [];
  List<Customer>? _employeeInfoModelTemp = [];

  List<Customer>? get employeeInfoModel => _employeeInfoModel;

  List<Customer>? get employeeInfoModelTemp => _employeeInfoModelTemp;

  Future initializeAllEmployeeInfo(BuildContext context) async {
    _employeeInfoModel = null;
    _employeeInfoModelTemp = null;

    ApiResponse apiResponse = await employeeRepo!.heatApiForEmployeeInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _employeeInfoModel = [];
      _employeeInfoModelTemp = [];
      for (var zone in apiResponse.response!.data) {
        _employeeInfoModel!.add(Customer.fromJson(zone));
      }
      // apiResponse.response.data.forEach((zone) {
      //   _employeeInfoModel.add(EmployeeInfoModel.fromJson(zone));
      // });

    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    notifyListeners();
  }

  // for search
  bool isSearch = false;
  bool isSearchForAppointment = false;

  searchEmployee(String query) async {
    if (query.isEmpty) {
      _employeeInfoModel!.clear();
      _employeeInfoModel = employeeInfoModelTemp;
      isSearch = false;
      notifyListeners();
    } else {
      _employeeInfoModel = [];
      isSearch = true;
      employeeInfoModelTemp!.forEach((employeeInfo) async {
        if ((employeeInfo.name!.toLowerCase().contains(query.toLowerCase())) ||
            (employeeInfo.username!
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (employeeInfo.email!.toLowerCase().contains(query.toLowerCase()))) {
          _employeeInfoModel!.add(employeeInfo);
        }
      });
      notifyListeners();
    }
  }

  final Map<String, MobilCart> _cartItems = {};
  Map<String, MobilCart> get cartItems {
    return {..._cartItems};
  }

  void addToCart(
    String? prodId,
    String? title,
    double? price,
  ) {
    if (_cartItems.containsKey(prodId)) {
      _cartItems.update(
          prodId!,
          (existingCartItem) => MobilCart(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity! + 1,
              ));
    } else {
      _cartItems.putIfAbsent(
          prodId!,
          () => MobilCart(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }
}

class MobilCart with ChangeNotifier {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;
  final String? imgUrl;

  MobilCart({
    this.id,
    this.title,
    this.quantity,
    this.price,
    this.imgUrl,
  });
}
