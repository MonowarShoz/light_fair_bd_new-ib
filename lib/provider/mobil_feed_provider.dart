import 'dart:convert';
import 'dart:developer' as dv;
import 'dart:math';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:light_fair_bd_new/data/datasource/model/category_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/edit_product_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/main_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/mobil_product.dart';
import 'package:light_fair_bd_new/data/datasource/model/order_process_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/process_param_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/response_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/ret_sale_item.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/repository/mobil_feed_repo.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/view/savsol_product/product_screen.dart';
import 'package:torch_light/torch_light.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/datasource/apiservices/responseApi/api_response.dart';

class MobilFeedProvider with ChangeNotifier {
  final MobilFeedRepo? mobilFeedRepo;

  MobilFeedProvider({
    this.mobilFeedRepo,
  });

  convertingUtf(String text) {
    var encode1 = utf8.encode(text);
    return base64.encode(encode1);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  MainModel? _mainModel;

  MainModel? get mainModel => _mainModel;
  List<RateSaleItem>? _rateSaleItem = [];

  List<RateSaleItem>? get rateSaleItem => _rateSaleItem;

  List<RateSaleItem>? _tempProdItem = [];

  // List<RateSaleItem>? get tempProdItem => _tempProdItem;
  List<RetItemSale>? _tempItem = [];

  List<RetItemSale>? get tempItem => _tempItem;

  List<CategoryModel>? _categoryItems = [];
  List<CategoryModel>? get categoryItems => _categoryItems!.distinctBy((x) => x.msircode).toList();

  List<RetItemSale>? _categoryWiseItems = [];
  List<RetItemSale>? get categoryWiseItems => _categoryWiseItems!.distinctBy((element) => element.sircode).toList();

  // List<RetItemSale>? get retItemSale =>
  //     _retItemSale!.distinctBy((x) => x.sircode).toList();
  //products List
  List<RetItemSale>? _retItemSale = [];
  List<RetItemSale>? get retItemSale => _retItemSale;

  ProcessAccessParams2? _processAccessParams2;

  ProcessAccessParams2? get processAccessParams2 => _processAccessParams2;
  List<CheckRetItem>? _checkRetItem = [];

  List<CheckRetItem>? get checkRetItem => _checkRetItem;

  List<CheckRetItem> _tempCheck = [];

  List<CheckRetItem> get tempCheck => _tempCheck;

  Future postAccess({String? custId}) async {
    // String jsonString = jsonEncode(processAccessParams2);
    // convertingUtf(jsonString);
    //_isLoading = true;
    _processAccessParams2 = null;
    _retItemSale = [];
    _checkRetItem = [];

    // _mainModel = null;
    // _tempProdItem = null;

    // _rateSaleItem = [];

    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.productParam,
      comCod: AppConstants.comCode,
    );
    //var s = json.encode(_processAccessParams2);
    String jsonString = jsonEncode(_processAccessParams2);
    //convertingUtf(jsonString);
    var encode1 = utf8.encode(jsonString);
    var base64String = base64.encode(encode1);
    debugPrint('Hello Basestring  "$base64String"');
    _isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse = await mobilFeedRepo!.postProcData(base64String);

    _isLoading = false;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _retItemSale = [];
      _checkRetItem = [];
      if (apiResponse.response!.data.isNotEmpty) {
        Map jsonSaleItem = json.decode(apiResponse.response!.data);

        for (var item in jsonSaleItem['Table']) {
          _retItemSale!.add(RetItemSale.fromJson(item));
        }

        var filteredList = retItemSale!
            .where((element) => element.batchno == custId!.substring(0, min(element.batchno!.length, custId.length)))
            .toList();
        for (var element in filteredList) {
          _checkRetItem!.add(
            CheckRetItem(isCheck: false, rateIem: element),
          );
        }
        // for (var element in retItemSale!) {
        //   _checkRetItem!.add(
        //     CheckRetItem(isCheck: false, rateIem: element),
        //   );
        // }
        _tempCheck = checkRetItem!;
        //_tempCheck.addAll(_checkRetItem!);

        // _tempItem = retItemSale;
      }

      debugPrint('Success');
    }
    notifyListeners();
  }

  Future getProductsData() async {
    // String jsonString = jsonEncode(processAccessParams2);
    // convertingUtf(jsonString);
    //_isLoading = true;
    _processAccessParams2 = null;
    _retItemSale = [];

    // _mainModel = null;
    // _tempProdItem = null;

    // _rateSaleItem = [];

    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.productParam,
      comCod: AppConstants.comCode,
    );
    //var s = json.encode(_processAccessParams2);
    String jsonString = jsonEncode(_processAccessParams2);
    //convertingUtf(jsonString);
    var encode1 = utf8.encode(jsonString);
    var base64String = base64.encode(encode1);
    debugPrint('Hello Basestring  "$base64String"');
    _isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse = await mobilFeedRepo!.postProcData(base64String);

    _isLoading = false;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _retItemSale = [];

      if (apiResponse.response!.data.isNotEmpty) {
        Map jsonSaleItem = json.decode(apiResponse.response!.data);

        for (var item in jsonSaleItem['Table']) {
          _retItemSale!.add(RetItemSale.fromJson(item));
        }

        _tempItem = retItemSale;
      }

      debugPrint('Success');
    }
    notifyListeners();
  }

  Future getCategoryWiseProducts() async {
    // String jsonString = jsonEncode(processAccessParams2);
    // convertingUtf(jsonString);
    //_isLoading = true;
    _processAccessParams2 = null;
    // _retItemSale = [];
    // _checkRetItem = [];
    _categoryItems = [];
    _categoryWiseItems = [];
    _custCatTileList = [];

    // _mainModel = null;
    // _tempProdItem = null;

    // _rateSaleItem = [];

    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.productParam,
      comCod: AppConstants.comCode,
    );
    //var s = json.encode(_processAccessParams2);
    String categjsonString = jsonEncode(_processAccessParams2);
    //convertingUtf(jsonString);
    var encode2 = utf8.encode(categjsonString);
    var catebase64String = base64.encode(encode2);
    debugPrint('Hello categoryWise Prod  "$catebase64String"');
    _isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse = await mobilFeedRepo!.postProcData(catebase64String);

    _isLoading = false;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      // _retItemSale = [];
      _categoryItems = [];
      _categoryWiseItems = [];
      _custCatTileList = [];
      if (apiResponse.response!.data.isNotEmpty) {
        Map jsonCategoryItem = json.decode(apiResponse.response!.data);

        for (var item in jsonCategoryItem['Table']) {
          _categoryWiseItems!.add(RetItemSale.fromJson(item));

          //_categoryItems!.add(CategoryModel.fromJson(item));
        }
        for (var item in jsonCategoryItem['Table1']) {
          //_retItemSale!.add(RetItemSale.fromJson(item));
          _categoryItems!.add(CategoryModel.fromJson(item));
          // _custCatTileList.add(CustomerCategoryWidgetModel(
          //   titleHeader: CategoryModel.fromJson(item).msirdesc,
          //   headerItem: findByCateGory(CategoryModel.fromJson(item).msircode!),
          // ));
        }

        //  for (var item in jsonRes) {
        // _retItemSale!.add(RetItemSale.fromJson(apiResponse.response!.data));
        // _categoryItems!
        //     .add(CategoryModel.fromJson(apiResponse.response!.data));
        // }

        // for (var element in retItemSale!) {
        //   _checkRetItem!.add(
        //     CheckRetItem(isCheck: false, rateIem: element),
        //   );
        // }
        //_tempCheck = _checkRetItem!;
        //_tempCheck.addAll(_checkRetItem!);

        // _tempItem = retItemSale;
      }

      debugPrint('Success');
    }
    notifyListeners();
  }

  removeFirstCategory() {}

  List<RetItemSale> findByCateGory(String categoryID) {
    List _categoryList = categoryID == "000000000000"
        ? categoryWiseItems as List<dynamic>
        : categoryWiseItems!.where((element) => element.msircode!.toLowerCase().contains(categoryID.toLowerCase())).toList();

    return [..._categoryList];
  }

  List<CustomerCategoryWidgetModel> _custCatTileList = [];
  List<CustomerCategoryWidgetModel> get custCatTileList => _custCatTileList;

  // List<CustomerCategoryWidgetModel> custCategory() {
  //   //_custCatTileList.clear();
  //   List<CustomerCategoryWidgetModel> _custCateList = [];
  //   categoryItems!.forEach((element) {
  //     _custCatTileList.add(CustomerCategoryWidgetModel(
  //       titleHeader: element.msirdesc,
  //       headerItem: findByCateGory(element.msircode!),
  //     ));
  //   });
  //   _custCateList = _custCatTileList;
  //   return [..._custCateList];
  // }

  int? _index;
  int? get custIndex => _index;
  custIndexUpdate(int? index) {
    _isExpandCustCat = index == _index;
    //_isExpandCustCat = !_isExpandCustCat;
    //custIndex == index ? _isExpandCustCat = !_isExpandCustCat : false;
    //notifyListeners();
  }

  bool _isExpandCustCat = false;

  bool get isExpandedCustList => _isExpandCustCat;

  updateSelected(int index) {
    _index = index;
    _isExpandCustCat = !_isExpandCustCat;
    notifyListeners();
  }
  //  List<RetItemSale> findByCateGory(String categoryID) {
  //   List _categoryList = categoryID == "000000000000"
  //       ? checkRetItem as List<dynamic>
  //       : checkRetItem!
  //           .where((element) => element.rateIem!.msircode!
  //               .toLowerCase()
  //               .contains(categoryID.toLowerCase()))
  //           .toList();

  //   return [..._categoryList];
  // }

  List<RetItemSale> searchQuery(String searchText, List<RetItemSale> prodList) {
    List _searchList = prodList.where((element) => element.sirdesc!.toLowerCase().contains(searchText.toLowerCase())).toList();

    return [..._searchList];
  }

  toggleProd(String prodName, bool status, int index) {
    for (int i = 0; i < tempCheck.length; i++) {
      if (prodName == tempCheck[i].rateIem!.sirdesc) {
        _checkRetItem![index].isCheck = status;
        //_employeeInfoModelTempForSearch[index].isCheck = status;
      }
    }
    notifyListeners();
  }

  bool isnsearch = false;

  newSearchCheckProd(String query) {
    if (query.isEmpty) {
      //_rateSaleItem!.clear();
      _checkRetItem!.clear();
      _checkRetItem = tempCheck;
      //_rateSaleItem = tempProdItem;
      isnsearch = false;
      notifyListeners();
    } else {
      _checkRetItem = [];
      isnsearch = true;
      for (var item in tempCheck) {
        if ((item.rateIem!.sirdesc!.toLowerCase().contains(query.toLowerCase())) ||
            (item.rateIem!.msirdesc!.toLowerCase().contains(query.toLowerCase()))) {
          _checkRetItem!.add(item);
        }
      }
      notifyListeners();
    }
  }

  bool isSearch = false;

  searchProd(String query) {
    if (query.isEmpty) {
      //_rateSaleItem!.clear();
      _retItemSale!.clear();
      _retItemSale = tempItem;
      //_rateSaleItem = tempProdItem;
      isSearch = false;
      notifyListeners();
    } else {
      _retItemSale = [];
      isSearch = true;
      tempItem!.forEach((item) async {
        if ((item.sirdesc!.toLowerCase().contains(query.toLowerCase())) ||
            (item.msirdesc!.toLowerCase().contains(query.toLowerCase()))) {
          _retItemSale!.add(item);
        }
      });
      notifyListeners();
    }
  }

  // List<CustomerModel>? _customerList = [];

  // List<CustomerModel>? get customerList => _customerList!.where((element) => element.sirunit == authProvider!.jwtTokenModel!.hccode).toList();

  // List<CustomerModel>? _tempCustomer = [];

  // List<CustomerModel>? get tempCustomer => _tempCustomer;

  // Future initializeCustomerList(String? hccode) async {
  //   _processAccessParams2 = null;
  //   _customerList = [];

  //   _processAccessParams2 = ProcessAccessParams2(
  //     procName: AppConstants.customerParam,
  //     comCod: AppConstants.comCode,
  //   );
  //   //var s = json.encode(_processAccessParams2);
  //   String jsnString = jsonEncode(_processAccessParams2);
  //   var encode1 = utf8.encode(jsnString);
  //   var custbase64String = base64.encode(encode1);
  //   debugPrint('Customer Basestring  "$custbase64String"');
  //   _isLoading = true;
  //   //notifyListeners();
  //   ApiResponse apiResponse =
  //       await mobilFeedRepo!.postProcData(custbase64String);

  //   _isLoading = false;

  //   if (apiResponse.response != null &&
  //       (apiResponse.response!.statusCode == 200 ||
  //           apiResponse.response!.statusCode == 201 ||
  //           apiResponse.response!.statusCode == 203 ||
  //           apiResponse.response!.statusCode == 202 ||
  //           apiResponse.response!.statusCode == 204)) {
  //     _customerList = [];
  //     if (apiResponse.response!.data.isNotEmpty) {
  //       var jsonItem = jsonDecode(apiResponse.response!.data);
  //       for (var item in jsonItem) {
  //         _customerList!.add(CustomerModel.fromJson(item));
  //        // customerList!.where((element) => element.sirunit == hccode);

  //       }

  //       _tempCustomer = customerList;
  //     }

  //     debugPrint('Success');
  //   }
  //   notifyListeners();
  // }

  // bool isCustomerSearch = false;
  // searchCustomer(String query) {
  //   if (query.isEmpty) {
  //     //_rateSaleItem!.clear();
  //     _customerList!.clear();
  //     _customerList = tempCustomer;
  //     //_rateSaleItem = tempProdItem;
  //     isCustomerSearch = false;
  //     notifyListeners();
  //   } else {
  //     _customerList = [];
  //     isCustomerSearch = true;
  //     tempCustomer!.forEach((item) async {
  //       if ((item.sirdesc!.toLowerCase().contains(query.toLowerCase()))) {
  //         _customerList!.add(item);
  //       }
  //     });
  //     notifyListeners();
  //   }
  // }

  final List<MobilProduct>? _tempProd = [];

  List<MobilProduct>? get tempProd => _tempProd;

  //List<MobilProduct>? get getProdList => _prodList;

  // final List<MobilProduct>? _cartList = [];

  // List<MobilProduct>? get cartList => _cartList;

  final List<RetItemSale>? _addc = [];

  List<RetItemSale>? get addc => _addc;

  // Map<String, ProductCartModel> _cartItems = {};

  // Map<String, ProductCartModel> get cartItems => _cartItems;
  Map<String, ProductEditModel> _cartItems = {};

  Map<String, ProductEditModel> get cartItems => _cartItems;
  String? _name;

  String? get name => _name;

  // setDropdown(String name,int index) {
  //   //_name = name;
  //    drpDownSelectedItem[index] = name;
  //   notifyListeners();
  // }

  void addToCart({
    required String prodId,
    required String title,
    double? unitconv,
    double? qty,
    String? unit,
    double? price,
    //String? invremrk,
    required String batchno,
  }) {
    if (_cartItems.containsKey(prodId)) {
      _cartItems.update(
          prodId,
          (existingCartItem) => ProductEditModel(
                rsircode: existingCartItem.rsircode,
                sirdesc: existingCartItem.sirdesc,
                itmrat: existingCartItem.itmrat,
                siruconf: existingCartItem.siruconf,

                invqty: qty ?? existingCartItem.invqty,
                sirunit: unit ?? existingCartItem.sirunit,

                batchref1: existingCartItem.batchref1,
                batchref2: "",
                batchref3: "",
                batchref4: "",
                batchrmrk: "",
                comcod: "",
                idisam2: 0.0,
                idisam: 0.0,
                inetam: 0.0,
                invcode: '',
                invno: "",
                invrmrk: "",
                itmam: 0.0,
                ivatam: 0.0,
                reptsl: "",
                sirunit2: "",
                slnum: 0,

                // quantity: (existingCartItem.quantity! + 1.0),
              ));
    } else {
      _cartItems.putIfAbsent(
          prodId,
          () => ProductEditModel(
                rsircode: prodId,
                sirdesc: title,
                itmrat: price,
                invqty: 1,
                sirunit: unit ?? 'CTN',
                siruconf: unitconv,
                batchref1: batchno,
                batchref2: "",
                batchref3: "",
                batchref4: "",
                batchrmrk: "",
                comcod: "",
                idisam2: 0.0,
                idisam: 0.0,
                inetam: 0.0,
                invcode: '',
                invno: "",
                invrmrk: "",
                itmam: 0.0,
                ivatam: 0.0,
                reptsl: "",
                sirunit2: "",
                slnum: 0,
              ));
    }
    notifyListeners();
  }

  // void addToCart(
  //   String prodId,
  //   String title, {
  //   double? unitconv,
  //   double? qty,
  //   String? unit,
  //   double? price,
  // }) {
  //   if (_cartItems.containsKey(prodId)) {
  //     _cartItems.update(
  //         prodId,
  //         (existingCartItem) => ProductCartModel(
  //               id: existingCartItem.id,
  //               title: existingCartItem.title,
  //               price: existingCartItem.price,
  //               unitconv3: existingCartItem.unitconv3,

  //               quantity: qty ?? existingCartItem.quantity,
  //               unit: unit ?? existingCartItem.unit,
  //               // quantity: (existingCartItem.quantity! + 1.0),
  //             ));
  //   } else {
  //     _cartItems.putIfAbsent(
  //         prodId,
  //         () => ProductCartModel(
  //               id: prodId,
  //               title: title,
  //               price: price,
  //               quantity: 1,
  //               unit: unit ?? 'CTN',
  //               unitconv3: unitconv,
  //             ));
  //   }
  //   notifyListeners();
  // }

  // double get totalAmount {
  //   var total = 0.0;
  //   _cartItems.forEach((key, value) {
  //     total += value.price!.toDouble();
  //   });
  //   return total;
  // }

  // addProdtoCart(RetItemSale retItemSale, BuildContext context) {
  //   _addc!.add(retItemSale);
  //
  //   for (var item in _addc!) {
  //     debugPrint("NEW ADD CART ${item.sirdesc}");
  //   }
  //   debugPrint(_addc);
  //   notifyListeners();
  // }

  // bool isAddedInCart(String sircode, String title) {
  //   for (var element in cartItems.values) {
  //     if (element.id == sircode) {
  //       if (element.title == title) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }

  //   return false;
  // }

  addCustomer(String title) {}

  // addProductToCart(
  //   String title,
  //   String price,
  // ) {
  //   _cartList!.add(MobilProduct(
  //     title: title,
  //     price: price,
  //   ));
  //   notifyListeners();
  // }
  addProductToCart(
    String title,
    double price,
  ) {
    _rateSaleItem!.add(RateSaleItem(
      sirdesc: title,
      saleprice: price,
    ));
    notifyListeners();
  }

  double multyplynum(String a, String b) {
    var c = double.parse(a) * double.parse(b);
    notifyListeners();
    return c;
  }

  // void clearCart() {
  //   _cartList!.clear();
  //   notifyListeners();
  // }

  void removeCart(int prodId) {
    _addc!.removeAt(prodId);
    notifyListeners();
  }

  void removeItemFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  clearWholeCart() {
    _cartItems = {};
    notifyListeners();
  }

  final List<OrdersAttr>? _orders = [];

  List<OrdersAttr>? get getOrders => _orders;

  Future addOrderProcess({
    List<ProductEditModel>? cartProd,
    // List<ProductCartModel>? cartProd,
    String? custName,
    String? date,
    String? custID,
    String? comment,
    bool isIndvOrderDetails = false,
    String? invNum,
    String? total,
  }) async {
    _orders!.clear();

    _orders!.insert(
      0,
      OrdersAttr(
        mobilCartProducts: cartProd,
        custId: custID,
        custName: custName,
        dateTime: date,
        comment: comment,
        invNum: invNum,
        totalAmount: total,
      ),
    );

    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.customerParam,
      comCod: AppConstants.comCode,
      parm01: date,
      parm02: custName,
      parm03: custID,
      parm04: cartProd!.isNotEmpty ? jsonEncode(cartProd) : '',
      parm05: comment ?? '',
      // parm06: invNum,
      // parm07: total
    );
    String ordJsonString = jsonEncode(_processAccessParams2);
    debugPrint("json Order $ordJsonString");
    var encode1 = utf8.encode(ordJsonString);
    var ordBase64String = base64.encode(encode1);
    debugPrint('Order Basestring  "$ordBase64String"');
    debugPrint('Decoded order base64 ${base64.decode(ordBase64String)}');
    notifyListeners();
  }

  double get totalOrder {
    var total = 0.0;
    for (var index = 0; index < getOrders!.length; index++) {
      for (var i = 0; i < getOrders![index].mobilCartProducts!.length; i++) {
        total += getOrders![index].mobilCartProducts![i].itmrat! * getOrders![index].mobilCartProducts![i].invqty!;
      }
    }

    return total;
  }

  // double get totalOrder {
  //   var total = 0.0;
  //   for (var index = 0; index < getOrders!.length; index++) {
  //     for (var i = 0; i < getOrders![index].mobilCartProducts!.length; i++) {
  //       total += getOrders![index].mobilCartProducts![i].price! * getOrders![index].mobilCartProducts![i].quantity!;
  //     }
  //   }

  //   return total;
  // }
  double get totalAmountOrder {
    var total = 0.0;
    for (var index = 0; index < getOrders!.length; index++) {
      for (var i = 0; i < getOrders![index].mobilCartProducts!.length; i++) {
        if (getOrders![index].mobilCartProducts![i].sirunit == 'PCS') {
          total += getOrders![index].mobilCartProducts![i].itmrat! * getOrders![index].mobilCartProducts![i].invqty!;
        } else if (getOrders![index].mobilCartProducts![i].sirunit == 'CTN') {
          total += getOrders![index].mobilCartProducts![i].itmrat! *
              getOrders![index].mobilCartProducts![i].invqty! *
              getOrders![index].mobilCartProducts![i].siruconf!;
        }
      }
    }
    return total;
  }

  // double get totalAmountOrder {
  //   var total = 0.0;
  //   for (var index = 0; index < getOrders!.length; index++) {
  //     for (var i = 0; i < getOrders![index].mobilCartProducts!.length; i++) {
  //       if (getOrders![index].mobilCartProducts![i].unit == 'PCS') {
  //         total += getOrders![index].mobilCartProducts![i].price! * getOrders![index].mobilCartProducts![i].quantity!;
  //       } else if (getOrders![index].mobilCartProducts![i].unit == 'CTN') {
  //         total += getOrders![index].mobilCartProducts![i].price! *
  //             getOrders![index].mobilCartProducts![i].quantity! *
  //             getOrders![index].mobilCartProducts![i].unitconv3!;
  //       }
  //     }
  //   }
  //   return total;
  // }

  final List<OrdersAttr>? _orderHistory = [];

  List<OrdersAttr>? get orderHistory => _orderHistory;
  String? _invMemoNum = '';

  String? get invMemoNum => _invMemoNum;

  clearMemo() {
    _invMemoNum = '';
  }

  bool _isProcessLoading = false;
  bool get isProcessLoading => _isProcessLoading;

  Future<ResponseModel> postOrder({
    List<ProductEditModel>? cartProd,
    // List<ProductCartModel>? cartProd,
    String? custName,
    String? date,
    String? custID,
    String? comment,
    bool isIndvOrderDetails = false,
    String? invNum,
    String? total,
    required String userName,
    required String hcCode,
    required String sessionID,
    String? deviceID,
    String? section,
    BuildContext? context,
  }) async {
    _processAccessParams2 = null;
    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.orderParam,
      comCod: AppConstants.comCode,
      parm01: date,
      parm02: custName,
      parm03: custID,
      parm04: cartProd!.isNotEmpty ? jsonEncode(cartProd) : '',
      parm05: comment ?? '',
      parm06: userName,
      parm07: hcCode,
      parm08: sessionID,
      parm09: deviceID,
      parm10: section,
      parm12: "D",

      // parm06: invNum,
      // parm07: total,
    );
    String ordJsonString = jsonEncode(_processAccessParams2);
    var finalEncodedData = utf8.encode(ordJsonString);
    var finOrdBase64String = base64Encode(finalEncodedData);
    var decodOrdBase = base64Decode(finOrdBase64String);
    dv.log('order base ${decodOrdBase}');
    dv.log('final base ${finOrdBase64String}');
    _invMemoNum = '';
    _isProcessLoading = true;
    ApiResponse apiResponse = await mobilFeedRepo!.postProcData(finOrdBase64String);
    _isProcessLoading = false;
    ResponseModel responseModel;
    // log('final Basestring  "$finOrdBase64String"',);

    //log('${base64Decode(finOrdBase64String)}',);
    //debugPrint('Decoded final order base64 ${base64.decode(finOrdBase64String)}',wrapWidth: 3024);

    // print("Final Order $ordJsonString");
    // var decodedJson = json.decode(finOrdBase64String);
    // var encode1 = utf8.encode(ordJsonString);
    // var ordBase64String = base64.encode(encode1);

    // print("Beautiful json $decodedJson");
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      debugPrint('From Server ${apiResponse.response!.data}');
      var decj = jsonDecode(apiResponse.response!.data);
      _invMemoNum = decj[0]["memonum1"];
      debugPrint("${decj[0]["memonum1"]}");
      debugPrint("invMemo $invMemoNum");

      //  Map map = apiResponse.response!.data;
      // var invNum = map["memonum"];

      responseModel = ResponseModel(true, 'Order successful');
    } else {
      responseModel = ResponseModel(false, 'Order failed');
    }

    notifyListeners();
    return responseModel;
  }

  // orderHistoryDetails(List<ProductCartModel>? cartProd, String? custName, String? date, String? custID,
  //     {String? comment, bool isIndvOrderDetails = false, String? invNum, String? total}) {
  //   _orderHistory!.add(
  //     OrdersAttr(
  //         mobilCartProducts: cartProd,
  //         custName: custName,
  //         dateTime: date,
  //         custId: custID,
  //         comment: comment,
  //         invNum: invNum,
  //         totalAmount: total),
  //   );
  // }

  bool isAddedInOrderList(String sircode, String title) {
    for (OrdersAttr retItem in getOrders!) {
      if (retItem.custId == sircode) {
        if (retItem.dateTime == title) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  // void removeOrder(String prodId) {
  //   _orders?.remove(prodId);
  //   notifyListeners();
  // }

  clearORder() {
    _orders!.clear();
    _orderHistory!.clear();
    notifyListeners();
  }

  // List<MobilProduct> searchProdQuery(String value) {
  //   List searchList = _prodList!.where((element) => element.title!.toLowerCase().contains(value.toLowerCase())).toList();
  //   notifyListeners();
  //   return [...searchList];
  // }

  // Uri? _uri;
  //Uri? get uri => _uri;
  Future searchUriFromInternet({String? uriName, bool isLogin = false}) async {
    Uri? uriSearch;
    final String prodDetailsUrl = 'https://www.google.com/search?q=$uriName';
    uriSearch = isLogin ? Uri.tryParse('tel:+8801923805615') : Uri.tryParse(prodDetailsUrl);
    if (await launchUrl(uriSearch!)) {
      await launchUrl(uriSearch, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $uriSearch';
    }
  }

  // late int _editedTotal;
  // int? get editedTotal => _editedTotal;

  //  final String prodDetailsUrl = 'https://www.google.com/search?q=${prodAttribute.sirdesc}';
  //           setState(() {
  //             uri = Uri.parse(prodDetailsUrl);
  //           });
  //           if (await launchUrl(uri!)) {
  //             await launchUrl(uri!, mode: LaunchMode.externalApplication);
  //           } else {
  //             throw 'Could not launch $uri!';
  //           }

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(uri!)) {
  //     throw 'Could not launch $uri';
  //   }
  // }

  // MobilProduct findById(
  //   String prodId,
  // ) {
  //   return _prodList.firstWhere((element) => element.id == prodId,
  //       orElse: () => _bikeMobilList.firstWhere(
  //             (element) => element.id == prodId,
  //             orElse: () => _tractorMobilList.firstWhere(
  //                 (element) => element.id == prodId,
  //                 orElse: () => _truckMobil
  //                     .firstWhere((element) => element.id == prodId)),
  //           ));
  // }

  Future<void> disableTorch(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      showCustomSnackBar('Could not disable torch', context);
    }
  }

  final List<ProductPreviewModel> _prodPreviewList = [
    ProductPreviewModel(
      title: 'Savsol',
      image: Images.savsol_logo,
      route: const ProductScreen(),
    ),
    ProductPreviewModel(
      title: 'Track',
      image: Images.tracklb,
      //route: TrackLubScreen(),
    ),
    ProductPreviewModel(title: 'tire', image: Images.tires),
  ];

  List<ProductPreviewModel> get previewList => _prodPreviewList;
}

class CheckRetItem with ChangeNotifier {
  RetItemSale? rateIem;
  bool isCheck;

  CheckRetItem({required this.rateIem, this.isCheck = false});
}

class ProductPreviewModel {
  final String? title;
  final String? image;
  final Widget? route;

  ProductPreviewModel({this.title, this.image, this.route});
}
