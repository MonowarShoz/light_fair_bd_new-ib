import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FormProvider extends ChangeNotifier{
  ValidationModel _name = ValidationModel();
  ValidationModel _qty = ValidationModel();

  ValidationModel get name => _name;
  ValidationModel get qty => _qty;

  void validateName(String? val){
    if(val != null && val.isValidName){
      _name = ValidationModel(value: val,error: null);
    } else {
      _name = ValidationModel(value: null,error: 'Please Enter a Valid Data');
    }
    notifyListeners();

  }
  bool get validate{
    return _name.value != null &&
    _qty.value != null;
  }




}

class ValidationModel{
  String? value;
  String? error;

  ValidationModel({this.value, this.error});
}

extension ExtString on String{
  bool get isValidName{
    final nameRegExp =  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return nameRegExp.hasMatch(this);
  }
  bool get isNotNull{
    return this!= null;
  }
  bool get isValidQty{
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
  
}