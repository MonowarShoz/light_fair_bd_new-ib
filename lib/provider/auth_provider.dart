import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart' as crypto;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:light_fair_bd_new/data/datasource/apiservices/responseApi/api_response.dart';
import 'package:light_fair_bd_new/data/datasource/model/app_user_list_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/branch_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/config_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/customer_category_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/customer_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/edit_product_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/jwttoken_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/menu_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/order_history_info_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/process_param_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/response_model.dart';
import 'package:light_fair_bd_new/data/datasource/model/user_model.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/repository/auth_repo.dart';
import 'package:light_fair_bd_new/repository/mobil_feed_repo.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:light_fair_bd_new/util/code_util.dart';
import 'package:light_fair_bd_new/util/date_converter.dart';
import 'package:convert/convert.dart';
import 'dart:io' show Platform;
import 'package:light_fair_bd_new/util/images.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/view/base_widget/animated_custom_dialog.dart';
import 'package:dartx/dartx.dart';

// import 'package:pointycastle/pointycastle.dart';
import 'package:light_fair_bd_new/view/order/order_history/all_order_screen.dart';
import 'package:light_fair_bd_new/view/order/order_history/order_status_screen.dart';
import 'package:light_fair_bd_new/view/order/order_process/ordtest_process.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import '../data/datasource/model/date_time_model.dart';
import '../view/order/customer_preview/customer_menu_new.dart';
import '../view/product_preview/product_preview._screen.dart';

class UserConfigurationProvider with ChangeNotifier {
  final AuthRepo? authRepo;
  final MobilFeedRepo? mobilFeedRepo;
  final MobilFeedProvider? mp;

  UserConfigurationProvider(this.mp,
      {required this.authRepo, required this.mobilFeedRepo});

  // UserConfigurationProvider({this.authRepo});

  generateMd5(String input) {
    var content = Utf8Encoder().convert(input);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);

    // return md5.convert(utf8.encode(input)).toString();
  }

  convertingUtf(String text) {
    var encode1 = utf8.encode(text);
    return base64.encode(encode1);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // for login section

  UserConfigModel? _userConfigModel;

  UserConfigModel? get userConfigModel => _userConfigModel;

  JwtTokenModel? _jwtTokenModel;

  JwtTokenModel? get jwtTokenModel => _jwtTokenModel;
  User? _user;

  User? get user => _user;

  Future<ResponseModel> login(User user, BuildContext? context) async {
    //debugPrint("MD55555 ");

    // _jwtTokenModel = JwtTokenModel();
    _isLoading = true;
    // _hasAvailableWebPortal = false;
    notifyListeners();

    ApiResponse apiResponse = await authRepo!.login(
      userID: user.userId,
      password: user.password,
      deviceID: user.terminalID,
    );

    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201)) {
      Map map = apiResponse.response!.data;
      bool token = map["istokenstr"];

      _jwtTokenModel = JwtTokenModel.fromJson(apiResponse.response!.data);

      authRepo!.saveUserToken(_jwtTokenModel!.tokenstr);
      //  authRepo!.saveUserToken(token);

      responseModel = ResponseModel(true, '${apiResponse.response}');
      // _user = User.fromJson(apiResponse.response!.data);

      // _jwtTokenModel = JwtTokenModel.fromJson(apiResponse.response!.data);

      // authRepo!.saveUserToken(_jwtTokenModel!.tokenstr);
      // //  authRepo!.saveUserToken(token);
      // responseModel = ResponseModel(true, '${apiResponse.response}');
      // responseModel = ResponseModel(true, '${_jwtTokenModel!.tokenmsg}');
    } else {
      responseModel = ResponseModel(false, apiResponse.error);
    }

    notifyListeners();
    return responseModel;
  }

  List<CustomerModel>? _customerList = [];

  ProcessAccessParams2? _processAccessParams3;
  ProcessAccessParams2? get processAccessParams3 => _processAccessParams3;
  ProcessAccessParams2? _processAccessParams2;

  ProcessAccessParams2? get processAccessParams2 => _processAccessParams2;

  ProcessAccessParams2? _processAccessParams4;
  ProcessAccessParams2? get processAccessParams4 => _processAccessParams4;

  List<CustomerModel>? get customerList => jwtTokenModel!.hccode ==
              AppConstants.adminHccode ||
          jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
          jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
          jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
      ? _customerList
      : _customerList!
          .where(
              (customerItem) => customerItem.sirunit == jwtTokenModel!.hccode)
          .toList();

  List<CustomerModel>? _tempCustomer = [];

  List<CustomerModel>? get tempCustomer => _tempCustomer;

  Future<ResponseModel> initializeCustomerList() async {
    _processAccessParams2 = null;
    _customerList = [];

    _processAccessParams2 = ProcessAccessParams2(
      procName: AppConstants.customerParam,
      comCod: AppConstants.comCode,
    );
    //var s = json.encode(_processAccessParams2);
    String jsnString = jsonEncode(_processAccessParams2);
    var encode1 = utf8.encode(jsnString);
    var custbase64String = base64.encode(encode1);
    debugPrint('Customer Basestring  "$custbase64String"');
    _isLoading = true;
    //notifyListeners();
    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(custbase64String);

    _isLoading = false;
    ResponseModel responseModel;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _customerList = [];
      if (apiResponse.response!.data.isNotEmpty) {
        var jsonItem = jsonDecode(apiResponse.response!.data);
        for (var item in jsonItem) {
          _customerList!.add(CustomerModel.fromJson(item));
          // customerList!.where((element) => element.sirunit == hccode);
        }

        _tempCustomer = customerList;
      }
      responseModel = ResponseModel(true, '${apiResponse.response}');

      debugPrint('Success');
    } else {
      responseModel = ResponseModel(false, '${apiResponse.error}');
    }
    notifyListeners();
    return responseModel;
  }

  List<CustomerModel>? _addnewCustomer = [];

  List<CustomerModel>? get addedCustomer => _addnewCustomer;
  addcustomer({String? name, String? type, String? desc}) {
    _customerList!.add(
      CustomerModel(
        sirdesc: name,
        sirdesc1: desc,
        sircode: customerList!.isEmpty
            ? (555100209000 + 1).toString()
            : (customerList!.last.sircode!.toInt() + 1).toString(),
        sirtype: type,
        sirunit: jwtTokenModel!.hccode,
      ),
    );

    // _customerList!.add(
    //   CustomerModel(
    //     sirdesc: name,
    //     sirdesc1: desc,
    //     sircode: ,
    //     sirunit: jwtTokenModel!.hccode,
    //   ),
    // );
    //_customerList!.addAll(iterable);
    notifyListeners();
  }

  bool isCustomerSearch = false;
  searchCustomer(String query) {
    if (query.isEmpty) {
      //_rateSaleItem!.clear();
      _customerList!.clear();
      _customerList = tempCustomer;
      //_rateSaleItem = tempProdItem;
      isCustomerSearch = false;
      notifyListeners();
    } else {
      _customerList = [];
      isCustomerSearch = true;
      tempCustomer!.forEach((item) async {
        if ((item.sirdesc!.toLowerCase().contains(query.toLowerCase()))) {
          _customerList!.add(item);
        }
      });
      notifyListeners();
    }
  }

  List<CustomerCategoryModel> _custMainCategoryList = [];
  List<CustomerCategoryModel> get custMainCategoryList => _custMainCategoryList;

  List<CustomerCategoryModel> _custSubCategoryList = [];
  List<CustomerCategoryModel> get custSubCategoryList => _custSubCategoryList;

  List<CustomerCategoryModel> _allCustomerList = [];
  List<CustomerCategoryModel> get allCustomerList => _allCustomerList;

  List<CustomerCategoryModel>? _catewiseCust = [];
  List<CustomerCategoryModel>? get cateWiseCust => _catewiseCust;
  // List<CustomerCategoryModel>? get cateWiseCust => jwtTokenModel!.hccode == AppConstants.adminHccode ||
  //         jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
  //         jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
  //         jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
  //     ? _catewiseCust
  //     : _catewiseCust!.where((customerItem) => customerItem.sirunit == jwtTokenModel!.hccode).toList();

  List<CustomerCategoryModel> _custTempSubCategoryList = [];
  List<CustomerCategoryModel> get custTempSubCategoryList =>
      _custTempSubCategoryList;

  List<CustomerCategoryWidgetModel> _custCatTileList = [];
  List<CustomerCategoryWidgetModel> get custCatTileList => _custCatTileList;

  bool _custProcessLoading = false;
  bool get custProcessLoading => _custProcessLoading;

  Future customerProcess() async {
    _custProcessLoading = true;
    _processAccessParams3 = null;
    _custMainCategoryList = [];
    _allCustomerList = [];
    _custCatTileList = [];
    _custSubCategoryList = [];
    //_custTempSubCategoryList = [];
    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.customerProc,
      comCod: AppConstants.comCode,
    );
    String jsnString = jsonEncode(_processAccessParams3);
    var encode2 = utf8.encode(jsnString);
    var custProcbase64String = base64.encode(encode2);
    debugPrint('Process Basestring  "$custProcbase64String"');

    //notifyListeners();
    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(custProcbase64String);
    _custProcessLoading = false;
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201)) {
      _custMainCategoryList = [];
      _custSubCategoryList = [];
      _custCatTileList = [];
      _custTempSubCategoryList = [];
      _allCustomerList = [];
      List custCategJson = json.decode(apiResponse.response!.data);
      for (var item in custCategJson[1]) {
        _custSubCategoryList.add(CustomerCategoryModel.fromJson(item));
      }
      for (var item in custCategJson[0]) {
        _custMainCategoryList.add(CustomerCategoryModel.fromJson(item));

        // _custTempSubCategoryList = custSubCategoryList
        //     .where((element) => element.sircode!.substring(0, 7) == CustomerCategoryModel.fromJson(item).sircode!.substring(0, 7))
        //     .toList();
        // _custCatTileList.add(CustomerCategoryWidgetModel(
        //   titleHeader: CustomerCategoryModel.fromJson(item).sirdesc,
        //   titleCode: CustomerCategoryModel.fromJson(item).sircode,
        //   headerItem: findCateGory(CustomerCategoryModel.fromJson(item).sircode!),
        // ));
      }
      for (var item in custCategJson[2]) {
        _allCustomerList.add(CustomerCategoryModel.fromJson(item));
      }
    }
    notifyListeners();
  }

  custSubCategory(String categoryID) {
    //  List cust = custSubCategoryList.where((element) => element.sircode!.substring(0, 7) == categoryID.substring(0, 7)).toList();
    _custTempSubCategoryList = custSubCategoryList
        .where((element) =>
            element.sircode!.substring(0, 7) == categoryID.substring(0, 7))
        .toList();
    // List _lists = custSubCategoryList.where((element) => element.sircode == categoryID.substring(0, 7)).toList();

    //return [...cust];
  }

  custcatwise(String categoryID) {
    _catewiseCust = allCustomerList
        .where((element) =>
            element.sircode!.substring(0, 9) == categoryID.substring(0, 9))
        .toList();
    // List _lists = custSubCategoryList.where((element) => element.sircode == categoryID.substring(0, 7)).toList();

    // return [..._lists];
  }

  List<CustomerCategoryModel> findCateGory(String categoryID) {
    List _categoryList = custSubCategoryList
        .where((element) => element.sircode!
            .toLowerCase()
            .contains(categoryID.substring(0, 7).toLowerCase()))
        .toList();

    return [..._categoryList];
  }

  bool isProcessLoading = false;

  Future<ResponseModel> addCustomerDataProcess({
    String? custID,
    String? custName,
    String? subHeadCodeID,
    String? typeDes,
    String? userName,
    String? hcCode,
    String? custType,
    String? sessionID,
    String? deviceID,
    BuildContext? context,
  }) async {
    _processAccessParams3 = null;
    isProcessLoading = true;
    _processAccessParams3 = ProcessAccessParams2(
      procName: "SetClientSirInfCodeBook",
      comCod: AppConstants.comCode,
      parm01: custID,
      parm02: ('CUST.-' + custName!.toUpperCase()),
      parm03: hcCode,
      parm04: typeDes!.toUpperCase(),
      parm05: custType,
      parm06: sessionID,
      parm07: deviceID,
      //parm09: deviceID,
    );
    String addCustomerJsonString = jsonEncode(_processAccessParams3);
    var finaladdedCustomerEncodedData = utf8.encode(addCustomerJsonString);
    var addcustBase64String = base64Encode(finaladdedCustomerEncodedData);
    var decodedaddc = base64Decode(addcustBase64String);
    log(utf8.decode(decodedaddc));
    log('final add base ${addcustBase64String}');

    ResponseModel responseModel;
    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(addcustBase64String);
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201)) {
      isProcessLoading = false;
      responseModel = ResponseModel(true, 'ADDIng successful');
      showCustomSnackBar('Customer Added successfully', context!,
          isError: false);
    } else {
      responseModel = ResponseModel(false, 'ADDIng Failed');
      showCustomSnackBar('Failed to Add CCustomer', context!, isError: true);
    }

    notifyListeners();
    return responseModel;
  }

  String? _selectedCustomerName;
  String? get selectedCustomerName => _selectedCustomerName;
  String? _selectedCustomerID;
  String? get selectedCustomerID => _selectedCustomerID;

  selectCustomer({required String customerName, required String customerID}) {
    _selectedCustomerName = customerName;
    _selectedCustomerID = customerID;
    notifyListeners();
  }

  deletefromSelected() {
    _selectedCustomerName = null;
    _selectedCustomerID = null;
  }

  String? _selectedUserID;
  String? get selectedUserID => _selectedUserID;
  String? _assignedUserName;
  String? get assignedUserName => _assignedUserName;
  String? _userDescription;
  String? get userDescription => _userDescription;

  selectUser(
      {required String hcCode, required String name, required String des}) {
    _selectedUserID = hcCode;
    _assignedUserName = name;
    _userDescription = des;
    notifyListeners();
  }

  deletefromUser() {
    _assignedUserName = null;
  }

  clearAssignedUser() {
    _assignedUserName = null;
    //notifyListeners();
  }

  String? _deviceName;

  String? get deviceName => _deviceName;
  String? _deviceid;

  String? get deviceid => _deviceid;
  String? _version;
  String? get versionName => _version;

  bool _isUpdate = false;

  bool get isUpdate => _isUpdate;

  getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceName = androidInfo.model;
      _deviceid = androidInfo.brand;
      debugPrint('Device inf : $deviceid');
      print('Running on ${deviceName}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceName = iosInfo.model;
      _deviceid = iosInfo.utsname.machine;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;

    notifyListeners();
  }

  String numberText(double number) {
    var converter = NumberToCharacterConverter('en');
    return converter.convertInt(number.toInt());
  }

  Future readFile(
    BuildContext context,
    Widget? dialog, {
    String? vers,
  }) async {
    //String slv = '';
    print('pressversion ${versionName}');
//ver:2.1.6
//appversonupdate
    // var vers = "2.0.2";
    var p = await http.read(
        Uri.parse('http://27.147.220.229/lfbdappsfolder/appversonupdate/app_info.txt'));
    print('read ${p}');
    // slv = p;
    Version currentVersion = Version.parse(versionName!);
    print('current version $currentVersion');
    Version latestVersion = Version.parse(p.substring(0, 5));
    print('latest $latestVersion');
    if (latestVersion <= currentVersion) {
      print('carry on');
    } else {
      showAnimatedDialog(context, dialog!);
      //showCustomSnackBar('You need to update the app', context);
      print('update');
    }

   
  }

  List<BranchModel>? _branchList = [];
  // List<BranchModel>? get branchList => _branchList!
  //     .distinctBy((x) => x.sectcod!.endsWith('0') ? null : x.sectname)
  //     .toList();
  List<BranchModel>? get branchList => _branchList!
      .where((element) =>
          !element.sectcod!.endsWith('000') &&
          !element.sectcod!.contains("110100101001"))
      .toList();


  Future<DateTimeModel> getTime(context) async {
    late DateTimeModel data;
    try {
      final response = await http.get(
        Uri.parse('https://worldtimeapi.org/api/timezone/Etc/UTC'),
      );

      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        data = DateTimeModel.fromJson(item);
        log('Date Time Data : ${response.body}');
        log('date time data $data');
      } else {
        print('Error Occurred');
      }
    } catch (e) {
      print('Error Occurred' + e.toString());
    }
    notifyListeners();
    return data;
  }

  bool _isBranchLoading = false;
  Future<ResponseModel> getCompanyBranchInfo() async {
    _isBranchLoading = true;
    _branchList = [];
    _processAccessParams4 = ProcessAccessParams2();

    _processAccessParams4 = ProcessAccessParams2(
      procName: AppConstants.branchParam,
      comCod: AppConstants.comCode,
      parm01: AppConstants.hmsVersion,

      // parm06: invNum,
      // parm07: total,
    );
    String brncJsonString = jsonEncode(_processAccessParams4);
    var branchEncodedData = utf8.encode(brncJsonString);
    var brnchBase64String = base64Encode(branchEncodedData);
    debugPrint(' branch base ${brnchBase64String}');

    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(brnchBase64String);
    _isBranchLoading = false;
    ResponseModel responseModel;
    notifyListeners();

    // print("Beautiful json $decodedJson");
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _branchList = [];
      log('From branch ${apiResponse.response!.data}');
      if (apiResponse.response!.data.isNotEmpty) {
        var decj = jsonDecode(apiResponse.response!.data);
        decj.forEach((element) {
          _branchList!.add(BranchModel.fromJson(element));
        });
      }

      // for (var element in decj) {
      //   _branchList!.add(BranchModel.fromJson(element));

      //   debugPrint('list $branchList');
      // }
      // _invMemoNum = decj[0]["memonum1"];
      // debugPrint("${decj[0]["memonum1"]}");
      // debugPrint("invMemo $invMemoNum");

      //  Map map = apiResponse.response!.data;
      // var invNum = map["memonum"];

      responseModel = ResponseModel(true, '');
    } else {
      responseModel = ResponseModel(false, '${apiResponse.error.toString()}');
    }

    notifyListeners();
    return responseModel;
  }

  String invFromDate = DateConverter.dateFormatStyle2(
      DateTime.now().subtract(const Duration(days: 7)));

  String _invToDateTemp = DateConverter.dateFormatStyle2(DateTime.now());
  String _invFromDateTemp = DateConverter.dateFormatStyle2(
      DateTime.now().subtract(const Duration(days: 7)));

  String invToDate = DateConverter.dateFormatStyle2(DateTime.now());

  String invFromDateIb =
      DateConverter.dateFormatStyle2(DateTime.now().add(Duration(days: 0)));
  String _invFromDateTempIb = DateConverter.dateFormatStyle2(
      DateTime.now().add(const Duration(days: 0)));

  String invToDateIb = DateConverter.dateFormatStyle2(
      DateTime.now().add(const Duration(days: 0)));
  String _invToDateTempIb = DateConverter.dateFormatStyle2(
      DateTime.now().add(const Duration(days: 0)));

  List<OrderHistoryInfoModel>? _orderHistoryList = [];
  List<OrderHistoryInfoModel>? get orderHistoryList =>
      jwtTokenModel!.hccode == AppConstants.adminHccode ||
              jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
          ? _orderHistoryList
          : _orderHistoryList!
              .where((element) => element.invbyid == jwtTokenModel!.hccode)
              .toList();

  bool _isordLoading = false;
  bool get isOrdLoading => _isordLoading;
  DateTime? toDateTime;
  DateTime? fromDateTime;

  Future<ResponseModel> getOrderHistoryInfo(
    String? sectionCode,
    String fromDate,
    String toDate,
    String? sts,
    BuildContext context,
  ) async {
    _orderHistoryList = [];
    _approvedList = [];
    _rejectedList = [];
    // toDateTime = DateConverter.convertStringToDateFormat2(invToDate);
    // fromDateTime = DateConverter.convertStringToDateFormat2(invFromDate);
    _processAccessParams2 = null;
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams2 = ProcessAccessParams2(
        procName: AppConstants.orderHistoryParam,
        comCod: AppConstants.comCode,
        parm01: fromDate,
        parm02: toDate,
        parm03: sectionCode,
        // parm03: '950600801002',
        parm04: sts);
    // } else {
    //   showCustomSnackBar(
    //       'Please ensure To-Date is after or equal for From-Date', context);
    // }

    String historyOrderJsonString = jsonEncode(_processAccessParams2);
    var ordHistoryEncodedData = utf8.encode(historyOrderJsonString);
    var ordHistoryBase64String = base64Encode(ordHistoryEncodedData);
    debugPrint(' order History base ${ordHistoryBase64String}');

    _isordLoading = true;
    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(ordHistoryBase64String);
    _orderHistoryList!.clear();
    _isordLoading = false;
    ResponseModel responseModel;

    // print("Beautiful json $decodedJson");
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _orderHistoryList = [];
      _approvedList = [];
      _rejectedList = [];
      debugPrint('From ord  ${apiResponse.response!.data}');
      var decodedOHjson = jsonDecode(apiResponse.response!.data);
      for (var element in decodedOHjson) {
        if (OrderHistoryInfoModel.fromJson(element).invstatus == 'D') {
          _orderHistoryList!.add(OrderHistoryInfoModel.fromJson(element));
        } else if (OrderHistoryInfoModel.fromJson(element).invstatus == 'A') {
          _approvedList!.add(OrderHistoryInfoModel.fromJson(element));
        } else if (OrderHistoryInfoModel.fromJson(element).invstatus == 'C') {
          _rejectedList!.add(OrderHistoryInfoModel.fromJson(element));
        }

        debugPrint('list $_orderHistoryList');
      }

      responseModel = ResponseModel(true, 'Branch successful');
    } else {
      responseModel = ResponseModel(false, 'Branch failed');
    }

    notifyListeners();
    return responseModel;
  }

  List<OrderHistoryInfoModel>? _orderTodateList = [];
  List<OrderHistoryInfoModel>? get orderTodateList => _orderTodateList;
  // List<OrderHistoryInfoModel>? get orderTodateList => jwtTokenModel!.hccode == AppConstants.adminHccode ||
  //         jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
  //         jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
  //         jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
  //     ? _orderTodateList! //For Privileged User
  //     : jwtTokenModel!.hccode!.substring(0, 9) == '950100402'
  //         ? _orderTodateList!.where((element) => element.sectcod == '110100201001').toList() // For Lo Sales store Employees
  //         : _orderTodateList!.where((element) => element.invbyid == jwtTokenModel!.hccode).toList();

  //For individual User with no privileges

  List<OrderHistoryInfoModel>? _approvedList = [];
  List<OrderHistoryInfoModel>? get approvedList => _approvedList;
  List<OrderHistoryInfoModel>? _rejectedList = [];
  List<OrderHistoryInfoModel>? get rejectedList =>
      jwtTokenModel!.hccode == AppConstants.adminHccode ||
              jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
          ? _rejectedList
          : _rejectedList!
              .where((element) => element.placeid == jwtTokenModel!.hccode)
              .toList();

  bool _istodayOrderLoading = false;
  bool get isTodayOrderLoading => _istodayOrderLoading;

  List<OrderHistoryInfoModel>? _tempPendingORder = [];

  List<OrderHistoryInfoModel>? get tempPendingOrder => _tempPendingORder;

  Future getTodayOrderNotif(
      // bool? pending,
      // String? status,
      ) async {
    _orderTodateList = [];
    _processAccessParams3 = ProcessAccessParams2();
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.orderHistoryParam,
      comCod: AppConstants.comCode,
      parm01: DateConverter.dateFormatStyle2(
          DateTime.now().subtract(const Duration(days: 130))),
      parm02: DateConverter.formatDateIOS(DateTime.now().toString()),
      parm03: "%",
      parm04: "D",
    );
    String todayOrderJsonString = jsonEncode(_processAccessParams3);
    var ordTodayEncodedData = utf8.encode(todayOrderJsonString);
    var ordTodayBase64String = base64Encode(ordTodayEncodedData);
    debugPrint('order Today base ${ordTodayBase64String}');
    _istodayOrderLoading = true;

    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(ordTodayBase64String);

    _istodayOrderLoading = false;
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _orderTodateList = [];
      debugPrint('From Today ord  ${apiResponse.response!.data}');
      var decodedOTjson = jsonDecode(apiResponse.response!.data);
      for (var element in decodedOTjson) {
        _orderTodateList!.add(OrderHistoryInfoModel.fromJson(element));

        // debugPrint('list $_orderTodateList');
      }
      var tmpOrd = jwtTokenModel!.hccode == AppConstants.adminHccode ||
              jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
          ? _orderTodateList! //For Privileged User
          : jwtTokenModel!.hccode!.substring(0, 9) == '950100402'
              ? _orderTodateList!
                  .where((element) => element.sectcod == '110100201001')
                  .toList() // For Lo Sales store Employees
              : _orderTodateList!
                  .where((element) => element.invbyid == jwtTokenModel!.hccode)
                  .toList();
      _orderTodateList = tmpOrd;
      _orderTodateList!.sort(
        (b, a) => b.invdat!.compareTo(a.invdat!),
      );
      _tempPendingORder = orderTodateList;
    }
    notifyListeners();
  }

  bool isPendingOrder = false;
  searchPendingOrder(String query) {
    if (query.isEmpty) {
      _orderTodateList!.clear();
      _orderTodateList = tempPendingOrder;

      isPendingOrder = false;
      notifyListeners();
    } else {
      _orderTodateList = [];
      isPendingOrder = true;
      tempPendingOrder!.forEach((item) async {
        if ((item.custName!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invdat!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invno1!.toLowerCase().contains(query.toLowerCase()))) {
          _orderTodateList!.add(item);
        }
      });
      notifyListeners();
    }
  }

  List<OrderHistoryInfoModel>? _tempRejORder = [];

  List<OrderHistoryInfoModel>? get tempRejOrder => _tempRejORder;

  Future getOrderStatus(String stats, {BuildContext? context}) async {
    _approvedList = [];
    _rejectedList = [];
    _processAccessParams3 = ProcessAccessParams2();
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.orderHistoryParam,
      comCod: AppConstants.comCode,
      parm01: DateConverter.dateFormatStyle2(
          DateTime.now().subtract(const Duration(days: 130))),
      parm02: DateConverter.formatDateIOS(DateTime.now().toString()),
      parm03: "%",
      parm04: stats,
    );
    String todayOrderJsonString = jsonEncode(_processAccessParams3);
    var ordTodayEncodedData = utf8.encode(todayOrderJsonString);
    var ordTodayBase64String = base64Encode(ordTodayEncodedData);
    debugPrint('order get status base ${ordTodayBase64String}');
    _istodayOrderLoading = true;

    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(ordTodayBase64String);

    _istodayOrderLoading = false;
    if (apiResponse.response != null ||
        apiResponse.response!.data != "" ||
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _approvedList = [];
      _rejectedList = [];
      debugPrint('From Today ord  ${apiResponse.response!.data}');
      var decodedOTjson = jsonDecode(apiResponse.response!.data);
      for (var element in decodedOTjson) {
        if (OrderHistoryInfoModel.fromJson(element).invstatus == 'A') {
          _approvedList!.add(OrderHistoryInfoModel.fromJson(element));
        } else if (OrderHistoryInfoModel.fromJson(element).invstatus == 'C') {
          _rejectedList!.add(OrderHistoryInfoModel.fromJson(element));
        }

        // debugPrint('list $_orderTodateList');
      }
      var tempApprove = jwtTokenModel!.hccode == AppConstants.adminHccode ||
              jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
              jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
          ? _approvedList
          : _approvedList!
              .where((element) => element.placeid == jwtTokenModel!.hccode)
              .toList();
      _approvedList = tempApprove;
      _tempPendingORder = _approvedList;
      _tempRejORder = _rejectedList;
    } else {
      showCustomSnackBar('Connection Failed', context!);
    }
    notifyListeners();
  }

  Future rejectedStatus({BuildContext? context}) async {
    //   _approvedList = [];
    _rejectedList = [];
    _processAccessParams3 = ProcessAccessParams2();
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.orderHistoryParam,
      comCod: AppConstants.comCode,
      parm01: DateConverter.dateFormatStyle2(
          DateTime.now().subtract(const Duration(days: 130))),
      parm02: DateConverter.formatDateIOS(DateTime.now().toString()),
      parm03: "%",
      parm04: 'C',
    );
    String todayOrderJsonString = jsonEncode(_processAccessParams3);
    var ordTodayEncodedData = utf8.encode(todayOrderJsonString);
    var ordTodayBase64String = base64Encode(ordTodayEncodedData);
    debugPrint('order get status base ${ordTodayBase64String}');
    _istodayOrderLoading = true;

    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(ordTodayBase64String);

    _istodayOrderLoading = false;
    if (apiResponse.response != null ||
        apiResponse.response!.data != "" ||
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      // _approvedList = [];
      _rejectedList = [];
      debugPrint('From Today ord  ${apiResponse.response!.data}');
      var decodedOTjson = jsonDecode(apiResponse.response!.data);
      for (var element in decodedOTjson) {
        // if (OrderHistoryInfoModel.fromJson(element).invstatus == 'C') {
        _rejectedList!.add(OrderHistoryInfoModel.fromJson(element));
        //}

        // debugPrint('list $_orderTodateList');
      }
      // var tempApprove = jwtTokenModel!.hccode == AppConstants.adminHccode ||
      //         jwtTokenModel!.hccode == AppConstants.superAdminHccode ||
      //         jwtTokenModel!.hccode == AppConstants.lfbdRfsHccode ||
      //         jwtTokenModel!.hccode == AppConstants.lfbdEhsHccode
      //     ? _approvedList
      //     : _approvedList!.where((element) => element.placeid == jwtTokenModel!.hccode).toList();
      // _approvedList = tempApprove;
      // _tempPendingORder = _approvedList;
    } else {
      showCustomSnackBar('Connection Failed', context!);
    }
    notifyListeners();
  }

  searchApprovedOrder(String query, {bool isaq = false}) {
    if (query.isEmpty) {
      _approvedList!.clear();
      _approvedList = tempPendingOrder;

      isPendingOrder = false;
      notifyListeners();
    } else {
      _approvedList = [];
      isPendingOrder = true;
      tempPendingOrder!.forEach((item) async {
        if ((item.custName!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invdat!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invno1!.toLowerCase().contains(query.toLowerCase()))) {
          _approvedList!.add(item);
        }
      });
      notifyListeners();
    }
  }

  searchRej(String query, {bool isaq = false}) {
    if (query.isEmpty) {
      _rejectedList!.clear();
      _rejectedList = tempRejOrder;

      isPendingOrder = false;
      notifyListeners();
    } else {
      _rejectedList = [];
      isPendingOrder = true;
      tempRejOrder!.forEach((item) async {
        if ((item.custName!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invdat!.toLowerCase().contains(query.toLowerCase())) ||
            (item.invno1!.toLowerCase().contains(query.toLowerCase()))) {
          _rejectedList!.add(item);
        }
      });
      notifyListeners();
    }
  }

  List<ProductEditModel> _editProdList = [];
  List<ProductEditModel> get editProdList => _editProdList;

  bool _isEditOrder = false;
  bool get isEditOrder => _isEditOrder;

  Future orderDetailsEditable({required String invNum}) async {
    _editProdList = [];
    _processAccessParams3 = ProcessAccessParams2();
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.editOrderDetailsParam,
      comCod: AppConstants.comCode,
      parm01: invNum,
    );
    String editOrderJsonString = jsonEncode(_processAccessParams3);
    var editOrderEncodedData = utf8.encode(editOrderJsonString);
    var editOrderBaseString = base64Encode(editOrderEncodedData);
    debugPrint('Editable order base $editOrderBaseString');
    _isEditOrder = true;

    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(editOrderBaseString);
    _isEditOrder = false;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _editProdList = [];
      if (apiResponse.response!.data != null) {
        Map jsonEditProdItem = json.decode(apiResponse.response!.data);
        for (var items in jsonEditProdItem["Table1"]) {
          _editProdList.add(ProductEditModel.fromJson(items));
        }
      } else {
        print(
          'null',
        );
      }
    } else {
      print(
        'Failed',
      );
    }

    notifyListeners();
  }

  void updateEditedForm({
    required int index,
    String? selval,
    String? selProdPrice,
    String? newProdbatchNo,
    String? rateconv,
    required String changeunitdrp,
    required TextEditingController qtyEditController,
    List<TextEditingController>? remrkEditController,
  }) {
    selval != null
        ? editProdList[index].sirdesc = selval
        : editProdList[index].sirdesc;
    selProdPrice != null
        ? editProdList[index].itmrat = selProdPrice.toDouble()
        : editProdList[index].itmrat;
    newProdbatchNo != null
        ? editProdList[index].batchref1 = newProdbatchNo
        : editProdList[index].batchref1;

    editProdList[index].sirunit = changeunitdrp;
    if (rateconv != null) {
      editProdList[index].sirunit == 'CTN'
          ? editProdList[index].invqty =
              double.tryParse(qtyEditController.text)! * double.parse(rateconv)
          : editProdList[index].invqty =
              double.tryParse(qtyEditController.text)!;
    } else {
      editProdList[index].invqty = double.tryParse(qtyEditController.text)!;
    }

    //rateconv != null ?   editProdList[index].sirunit == 'CTN' ?

    editProdList[index].invrmrk = remrkEditController![index].text;

    // widget.orderAttr.mobilCartProducts![currentIndex].unit = unitController.text;
    // widget.orderAttr.comment = commentController.text;

    //Code to update the list after editing
    //ProductCartModel prods = ProductCartModel(quantity: qtyController.text.toDouble(), unit: unitController.text);
    // mobilCartProducts![currentIndex] = prods;
    notifyListeners();
  }

  final List<ProductEditModel> _addedtoEditedList = [];
  List<ProductEditModel> get addedtoEditedList => _addedtoEditedList;

  addProductinEditedList({
    String? prodName,
    double? qty,
    double? itmRate,
    String? chngunit,
    String? invno,
    String? rsircode,
    double? siruconf,
    String? batchNo,
    String? rmrk,
    //int? curIndex,
  }) {
    _editProdList.add(ProductEditModel(
      comcod: '',
      sirdesc: prodName,
      invqty: qty,
      itmrat: itmRate,
      sirunit: chngunit,
      invno: invno,
      rsircode: rsircode,
      siruconf: siruconf,
      //batchref1: "",
      batchref1: batchNo,
      batchref2: "",
      batchref3: "",
      batchref4: "",
      batchrmrk: "",
      idisam2: 0.0,
      idisam: 0.0,
      inetam: 0.0,
      invcode: '',
      invrmrk: rmrk ?? "",
      itmam: 0.0,
      ivatam: 0.0,
      reptsl: "",
      sirunit2: "",
      slnum: 0,
    ));

    notifyListeners();
  }

  String calculateSubTotal(double qty, double itmrate) {
    return (qty * itmrate).toString();
  }

  double get editedTotal {
    var totalEdit = 0.0;
    for (var i = 0; i < editProdList.length; i++) {
      totalEdit += editProdList[i].invqty! * editProdList[i].itmrat!;
    }
    return totalEdit;
  }

  //post approval
  Future<ResponseModel> postApproval(
      {List<ProductEditModel>? editProd,
      String? invonum,
      String? custID,
      String? custName,
      String? sectionCode,
      String? remark,
      String? date,
      String? invNum,
      String? total,
      String? userName,
      String? hcCode,
      String? sessionID,
      String? deviceID,
      required String? parm12,
      String? parm13,
      BuildContext? context}) async {
    _processAccessParams3 = null;

    _processAccessParams3 = ProcessAccessParams2(
      procName: AppConstants.orderParam,
      comCod: "6535",
      parm01: date,
      parm02: custName,
      parm03: custID,
      parm04: editProd!.isNotEmpty ? jsonEncode(editProd) : '',
      parm05: remark,
      parm06: userName,
      parm07: hcCode,
      parm08: sessionID,
      parm09: deviceID,
      parm10: sectionCode,

      parm11: invonum,
      parm12: parm12,
      parm13: parm13,

      // parm04: section,
      // parm05: remark,
      // parm06: date,

      //  procName: AppConstants.orderParam,
      //   comCod: AppConstants.comCode,
      //   parm01: date,
      //   parm02: custName,
      //   parm03: custID,
      //   parm04: cartProd!.isNotEmpty ? jsonEncode(cartProd) : '',
      //   parm05: comment ?? '',

      // parm05: comment ?? '',
      // parm06: userName,
      // parm07: hcCode,
      // parm08: sessionID,
      // parm09: deviceID,
      // parm10: section

      // parm06: invNum,
      // parm07: total,
    );
    String approveJsonString = jsonEncode(_processAccessParams3);
    var finalapproveEncodedData = utf8.encode(approveJsonString);
    var apprveBase64String = base64Encode(finalapproveEncodedData);
    var decodedapprv = base64Decode(apprveBase64String);
    log('approve $apprveBase64String');
    log(utf8.decode(decodedapprv));
    // jwtTokenModel!.hccode == '950600801003' || jwtTokenModel!.hccode == "950600801002"
    //     ? log('final approve base ${apprveBase64String}')
    //     : showCustomSnackBar('You do not have permission', context!);
    ApiResponse apiResponse =
        await mobilFeedRepo!.postProcData(apprveBase64String);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      debugPrint("approve response ${apiResponse.response!.data}");

      responseModel = ResponseModel(true, 'Approve successful');
    } else {
      responseModel = ResponseModel(false, 'Approve Failed');
    }

    notifyListeners();
    return responseModel;
  }

  bool _isEdit = false;
  bool get isEDit => _isEdit;

  isCustomerEdit() {
    _isEdit = true;
    notifyListeners();
  }

  String? _sectionSelect;
  String? get sectionSelect => _sectionSelect;
  sectionsSelect(String? val) {
    _sectionSelect = val;
    notifyListeners();
  }

  List<bool> _isApproveProceed = [];
  List<bool> get isApproveProceed => _isApproveProceed;
  approveOrder(int index, length) {
    for (var i = 0; i < length; i++) {}

    notifyListeners();
  }

  clearSectionSelect() {
    _sectionSelect = '';
    notifyListeners();
  }

  // String

  // updateprApprovedData(
  //     {required ProductEditModel prEdit,
  //     List<ProductEditModel>? editableList,
  //     int? currentIndex,
  //     //required TextEditingController qtyEditController,

  //     String? selval}) {
  //   currentIndex = editableList!.indexOf(prEdit);
  //   // qtyEditController.text = prEdit.invqty.toString();
  //   _changeUnitDropdown = prEdit.sirunit!;
  //   notifyListeners();
  //   // selval = prEdit.sirdesc;
  //   //notifyListeners();
  //   //unitController.text = ord.unit!;
  // }

  submitForInfo(String sec, String sts, BuildContext context) {
    toDateTime = DateConverter.convertStringToDateFormat2(invToDate);
    fromDateTime = DateConverter.convertStringToDateFormat2(invFromDate);

    if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
      getOrderHistoryInfo(sec, invFromDate, invToDate, sts, context);
    } else {
      showCustomSnackBar(
          'Please ensure To-Date is after or equal for From-Date', context);
    }
  }

  clearInfo() {
    _orderHistoryList!.clear();
    _approvedList!.clear();
    _rejectedList!.clear();
  }

  invUpdateFromOrToDate(DateTime dateTime, {bool isFromDate = false}) {
    if (isFromDate) {
      _invFromDateTemp = DateConverter.dateFormatStyle2(dateTime);
    } else {
      _invToDateTemp = DateConverter.dateFormatStyle2(dateTime);
    }
    notifyListeners();
  }

  //inv
  invOkFromOrToDate(BuildContext context, {bool isFromDate = false}) {
    DateTime fromD = DateConverter.convertStringToDateFormat2(_invFromDateTemp);
    DateTime toD = DateConverter.convertStringToDateFormat2(_invToDateTemp);
    if (isFromDate) {
      if ((fromD.isBefore(toD)) || fromD == toD) {
        invFromDate = _invFromDateTemp;
      } else {
        showCustomSnackBar(
            'From Date Should before or equal for To Date', context);
      }
    } else {
      if ((toD.isAfter(fromD)) || fromD == toD) {
        invToDate = _invToDateTemp;
      } else {
        showCustomSnackBar(
            'To Date Should After or equal for From Date', context);
      }
    }

    notifyListeners();
  }

  //ib create date formate

  invUpdateFromOrToDateIb(DateTime dateTime, {bool isFromDate = false}) {
    if (isFromDate) {
      _invFromDateTempIb = DateConverter.dateFormatStyle2(dateTime);
    } else {
      _invToDateTempIb = DateConverter.dateFormatStyle2(dateTime);
    }
    notifyListeners();
  }

  invOkFromOrToDateIb(BuildContext context, {bool isFromDate = false}) {
    DateTime fromD =
        DateConverter.convertStringToDateFormat2(_invFromDateTempIb);
    DateTime toD = DateConverter.convertStringToDateFormat2(_invToDateTempIb);
    if (isFromDate) {
      if ((fromD.isBefore(toD)) || fromD == toD) {
        invFromDate = _invFromDateTempIb;
      } else {
        showCustomSnackBar(
            'From Date Should before or equal for To Date', context);
      }
    } else {
      if ((toD.isBefore(fromD)) || fromD == toD) {
        invToDate = _invToDateTempIb;
      } else {
        showCustomSnackBar(
            'To Date Should After or equal for From Date', context);
      }
    }

    notifyListeners();
  }

  double get totalAmountOrder {
    var total = 0.0;
    for (var index = 0; index < editProdList.length; index++) {
      if (editProdList[index].sirunit == 'PCS') {
        total += editProdList[index].itmrat! * editProdList[index].invqty!;
      } else if (editProdList[index].sirunit == 'CTN') {
        total += editProdList[index].itmrat! *
            editProdList[index].invqty! *
            editProdList[index].siruconf!;
      }
    }
    return total;
  }

  final List<bool> _newExpanded = [];
  List<bool> get newExpanded => _newExpanded;

  bool _isExpanded = false;
  bool _isExpanded2 = false;
  bool get isExpanded => _isExpanded;
  bool get isExpanded2 => _isExpanded2;
  getSubHead({int? index}) {
    //_newExpanded[index!] = false;
    _newExpanded[index!] = !_newExpanded[index];
    // for (var i = 0; i < index; i++) {
    //   _newExpanded[index] = !_newExpanded[index];
    // }
    //_isExpanded = !_isExpanded;

    notifyListeners();
  }

  getMainHead() {
    _isExpanded2 = !_isExpanded2;
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = true;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo!.saveUserNumberAndPassword(number, password);
  }

  String getUserEmail() {
    return authRepo!.getUserEmail();
  }

  String getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  List<AppUserListModel> _appUserList = [];
  List<AppUserListModel> get appUserList => _appUserList;
  List<AppUserListModel> _tempappUserList = [];
  List<AppUserListModel> get tempappUserList => _tempappUserList;
  Future appUserListProvider(BuildContext context) async {
    _appUserList = [];
    _processAccessParams3 = ProcessAccessParams2();
    // if (toDateTime!.isAfter(fromDateTime!) || toDateTime == fromDateTime) {
    _processAccessParams3 = ProcessAccessParams2(
      procName: "SetParamAppUserList",
      comCod: "6535",
      //parm01: invNum,
    );

    var compData = CodeUtil.convertToBase64(_processAccessParams3!);
    log('test user $compData');
    //debugPrint('new api base $newprod');
    _isEditOrder = true;

    ApiResponse apiResponse = await mobilFeedRepo!.postProcData(compData);
    // _isEditOrder = false;

    if (apiResponse.response != null &&
        (apiResponse.response!.statusCode == 200 ||
            apiResponse.response!.statusCode == 201 ||
            apiResponse.response!.statusCode == 203 ||
            apiResponse.response!.statusCode == 202 ||
            apiResponse.response!.statusCode == 204)) {
      _appUserList = [];
      log(apiResponse.response.toString());
      Map jsonUserList = json.decode(apiResponse.response!.data);
      for (var element in jsonUserList['Table']) {
        _appUserList.add(AppUserListModel.fromJson(element));
      }
      _tempappUserList = appUserList;
    } else {
      if (context.mounted) {
        showCustomSnackBar('Failed to load data', context);
      }
    }

    notifyListeners();
  }

  bool isAssignedSearch = false;
  searchAssignedUser(String query) {
    if (query.isEmpty) {
      //_rateSaleItem!.clear();
      _appUserList!.clear();
      _appUserList = tempappUserList;
      //_rateSaleItem = tempProdItem;
      isAssignedSearch = false;
      notifyListeners();
    } else {
      _appUserList = [];
      isAssignedSearch = true;
      tempappUserList.forEach((item) async {
        if ((item.signinnam!.toLowerCase().contains(query.toLowerCase()))) {
          _appUserList.add(item);
        }
      });
      notifyListeners();
    }
  }

  // for open user permission

  bool _hasAvailableWebPortal = false;

  bool _hasPermissionForManualAttendance = false;

  bool get hasPermissionForManualAttendance =>
      _hasPermissionForManualAttendance;

  bool get hasAvailableWebPortal => _hasAvailableWebPortal;

  // for menu section

  //List<MenuModel> _getMenuList = [];

  List<MenuModel> get getMenuList => _getAllMenuModel;

//  List<MenuModel> get productMenuItem => _productMenuItem;

  // clear token
  void clearToken() async {
    await authRepo!.cleanBarearToken();
  }

  final List<MenuModel> _getAllMenuModel = [
    MenuModel(
      menuName: 'Products',
      color: Colors.green,
      imgColor: Colors.green,
      //color: Colors.green,
      icon: Images.engOil,
      routeName: const ProductPreviewScreen(),
      // routeName: NewProdDiagWidget(
      //   isNewOrderScreen: false,
      // ),
    ),
    MenuModel(
      menuName: 'Order',
      color: Color.fromARGB(255, 131, 119, 17),
      imgColor: Color.fromARGB(255, 131, 119, 17),
      icon: Images.cargo,
      routeName: const OrdTestProcess(),
      //  routeName: NewOrderScreen(),
    ),
    MenuModel(
      menuName: 'Pending Order',
      color: const Color.fromARGB(255, 211, 94, 17),
      imgColor: const Color.fromARGB(255, 131, 119, 17),
      icon: Images.orderHistory,
      routeName: const AllOrderScreen(),
      //routeName: OrderHistoryScreen(),
    ),
    MenuModel(
      menuName: 'Order Status',
      color: Color.fromARGB(255, 188, 10, 60),
      imgColor: Color.fromARGB(255, 7, 153, 166),
      icon: Images.orderHistory,
      routeName: OrderStatusScreen(),
      //routeName: OrderHistoryScreen(),
    ),
    MenuModel(
      menuName: 'Customer Menu',
      color: Color.fromARGB(255, 195, 46, 221),
      imgColor: Color.fromARGB(255, 192, 95, 209),
      icon: Images.cust_setting,
      routeName: CustNewMenuScreen(),
      //routeName: OrderHistoryScreen(),
    ),
    // MenuModel(
    //   menuName: 'Approved Order',
    //   color: Color.fromARGB(255, 9, 193, 235),
    //   imgColor: Color.fromARGB(255, 7, 124, 219),
    //   icon: Images.orderHistory,
    //   routeName: AllOrderScreen(),
    //   //routeName: OrderHistoryScreen(),
    // ),
    // MenuModel(
    //   menuName: 'Order',
    //   color: Colors.red,
    //   icon: Images.cargo,
    //   //  routeName: HomeScreen(),
    // ),
    // MenuModel(
    //   menuName: 'Savsol',
    //   color: Colors.blue,
    //   icon: Images.savsol_logo,
    //   // routeName: HomeScreen(),
    // ),
  ];
}

class CustomerCategoryWidgetModel {
  final String? titleHeader;
  final String? titleCode;
  final List<CustomerCategoryModel>? headerItem;

  CustomerCategoryWidgetModel(
      {this.titleCode, this.titleHeader, this.headerItem});
}

class SubHeaderModel {
  final String? title;

  SubHeaderModel({this.title});
}
