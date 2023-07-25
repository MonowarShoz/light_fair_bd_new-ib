// ignore_for_file: constant_identifier_names
import 'package:light_fair_bd_new/data/datasource/model/LanguageModel.dart';

class AppConstants {
  //global api
  // static const String baseUrl = 'http://103.110.218.55:1050/api/';

//static const String baseUrl = 'http://103.56.7.68:1086/api/';
  //lfbd API
  static const String baseUrl = 'http://27.147.220.229:45/api/' ;//light fair api;

  //static const String baseUrl = 'http://192.168.0.73:1030/api/';
  //delowar sir api
  //static const String baseUrl = 'http://192.168.2.105:1002/api/';
  //static const String baseUrl = 'http://192.168.2.105:120/api/';
  //static const String baseUrl = 'https://192.168.31.204:7162/';
  //local ApI
  //static const String baseUrl = 'http://192.168.0.249:5600/api/';
  // static const String baseUrl = 'http://192.168.31.204:5600/api/';
  //static const String baseUrl ='http://192.168.1.92:88/api/';

  // static const String baseUrl = 'http://192.168.1.11:1004/api/';

  //app download link
  static const String appDownlinkUrl = 'http://27.147.220.229/lfbdappsfolder/apkbuild/';

  static const String loginUri = 'Userinfs/';

  //API routing
  static const String jwtTokenUri = 'Jwt1';
  static const String hmsMblQuery = 'HmsMblQuery';
  //static const String jwtTokenUri = 'Jwt';

  //userinf
  static const String lfbdEhsHccode = '950100101001';
  static const String lfbdRfsHccode = '950100401006';
  static const String adminHccode = '950600801003';
  static const String superAdminHccode = '950600801002';
  static const String monowarHccode = '950600801006';

  //Post data parameter
  static const String productParam = "SetParamRetSaleItemList";
  static const String comCode = "6535";
  static const String customerParam = "SetParamSirInfCodeBook";
  static const String categoryParam = "SetParamSirInfCodeBookItemListParam";
  static const String orderParam = "SetParamUpdateMSalesInvoiceXml";
  static const String customerProc = "GetClientSirInfCodeBook";
  static const String orderHistoryParam = "SetParamSalesTransList";
  static const String editOrderDetailsParam = 'SetParamSalesInvoiceXml';
  static const String hmsVersion = "220513.1";
  static const String branchParam = "SetParamCompBrnSecCodeBook";

  static const String nullTime = "1900-01-01T00:00:00";

  // sharePreference

  static const String TOKEN = 'tokenstr';
  static const String USER = 'user';
  static const String USER_EMAIL = 'user_email';
  static const String USER_PASSWORD = 'user_password';
  static const String HOME_ADDRESS = 'home_address';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String OFFICE_ADDRESS = 'office_address';
  static const String CART_LIST = 'cart_list';
  static const String CONFIG = 'config';
  static const String GUEST_MODE = 'guest_mode';
  static const String CURRENCY = 'currency';

  // order status
  static const String OBJ_PDF_BUTTON = 'PDF Button';
  static const String OBJ_TEXT_SHARE_BUTTON = 'TextShare Button';
  static const String OBJ_ADD_BUTTON = 'Add Button';
  static const String OBJ_MENU = 'Menu';
  static const String OBJ_EDIT_BUTTON = 'Edit Button';
  static const String OBJ_SAVE_BUTTON = 'Save Button';
  static const String OBJ_APPROVE_SAVE_BUTTON = 'Approve&Save Button';
  static const String OBJ_APPROVE_UPDATE_BUTTON = 'Approve&Update Button';
  static const String OBJ_DELETE_BUTTON = 'Delete Button';
  static const String OBJ_MY_APPOINTMENT_BUTTON = 'MyAppointment Button';
  static const String OBJ_OTHER_APPOINTMENT_BUTTON = 'Other Appointment Button';
  static const String OBJ_OTHER_PDF = 'Other PDF';
  static const String OBJ_MY_APPOINTMENT_PDF = 'My Appointment PDF';
  static const String OBJ_ALL = 'ALL';
  static const String OBJ_ALL_PDF_BUTTON = 'ALL PDF Button';
  static const String OBJ_LIST_PDF_BUTTON = 'List PDF Button';
  static const String OBJ_COMP_DUE_PDF_BUTTON = 'Comp Due PDF Button';
  static const String PENDING = 'pending';
  static const String PROCESSING = 'processing';
  static const String PROCESSED = 'processed';
  static const String DELIVERED = 'delivered';
  static const String FAILED = 'failed';
  static const String RETURNED = 'returned';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';
  static const String SELECT_LANGUAGE_STATUS = 'select_language_status';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Bangla', countryCode: 'BD', languageCode: 'bn'),
  ];

  static void logPrint(Object? object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }
}
