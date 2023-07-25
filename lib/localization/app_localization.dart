import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';

class AppLocalization{

  AppLocalization(this.locale);
  final Locale locale;

  static AppLocalization? of(BuildContext context){
    return Localizations.of<AppLocalization>(context, AppLocalization);

  }
  Map<String,String>? _localizedValues;
  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key){
    return _localizedValues![key]!;
  }
  static const LocalizationsDelegate<AppLocalization> delegate = _DemoLocalizationsDelegate();

}

class _DemoLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    List<String> _languageString = [];
    AppConstants.languages.forEach((element) {
      _languageString.add(element.languageCode!);
    });
  return _languageString.contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async{
   AppLocalization localization = AppLocalization(locale);
   await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
   return false;
  }
}