import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/datasource/model/process_param_model.dart';




class CodeUtil {
  static String convertToBase64(ProcessAccessParams2 data) {
    String encodedJson = jsonEncode(data);
    var jsonEncodedByte = utf8.encode(encodedJson);
    return base64Encode(jsonEncodedByte);
  }

  static String encodedPassword(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String addDashes(String text) {
    const int addDashEvery = 2;
    String out = '';

    for (int i = 0; i < text.length; i++) {
      if (i + 1 > addDashEvery && i % addDashEvery == 0) {
        out += '-';
      }

      out += text[i];
    }

    return out;
  }

  static String _newdecompress(String json) {
    final decodeBase64Json = base64.decode(json);
    final decodegZipJson = zlib.decode(decodeBase64Json);
    return utf8.decode(decodegZipJson);
  }

  static String decompress(String zipText) {
    final decodeBase64Json = base64Decode(zipText);
    final decodedData = GZipCodec().decode(decodeBase64Json);
    Uint8List bytes = Uint8List.fromList(decodedData);
    final utf16CodeUnits = bytes.buffer.asUint16List();
    final str = String.fromCharCodes(utf16CodeUnits);
    return str;
  }

  static String idDash(String str) {
    return '${str.substring(0, 2)}-${str.substring(3, 6)}-${str.substring(6, 8)}';
  }

  static String? numberFormatInt(var number) {
    var formatterInt = NumberFormat('#,###,###,#00');
    return formatterInt.format(number);
  }

  static Future searchUriFromInternet({String? uriName, bool isLogin = false}) async {
    Uri? uriSearch;
    const String infoLink = 'http://pfms.software.pirthe.com/usermanual/';
    uriSearch = isLogin ? Uri.tryParse('tel:+8801615-720012') : Uri.tryParse(infoLink);
    if (await launchUrl(uriSearch!)) {
      await launchUrl(uriSearch, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $uriSearch';
    }
  }
}
